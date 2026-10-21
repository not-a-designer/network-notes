# Run with: bundle exec ruby scripts/check.rb
require 'jekyll'
require 'tmpdir'
require 'fileutils'
require 'yaml'
require 'date'
require 'cgi'
require 'uri'
require 'rexml/document'

ROOT = File.expand_path('..', __dir__)

def assert(condition, message)
  raise message unless condition
end

def frontmatter(file)
  text = File.read(file, encoding: 'UTF-8')
  match = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  assert(match, "Missing front matter: #{file}")
  YAML.safe_load(match[1], permitted_classes: [Date, Time]) || {}
end

def validate_source
  slugs = []
  Dir.glob(File.join(ROOT, '_posts', '*.md')).each do |file|
    name = File.basename(file)
    assert(name.match?(/\A\d{4}-\d{2}-\d{2}-.+\.md\z/), "Invalid post filename: #{name}")
    Date.iso8601(name[0, 10])
    data = frontmatter(file)
    %w[title summary].each { |key| assert(data[key].is_a?(String) && !data[key].strip.empty?, "Missing #{key}: #{name}") }
    assert(data['tags'].is_a?(Array) && data['tags'].all? { |tag| tag.is_a?(String) && tag.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/) }, "Use lowercase hyphenated tags: #{name}")
    assert([true, false].include?(data['published']), "Set published: true or false: #{name}")
    assert(['Learning note', 'Lab report'].include?(data['kind']), "Unknown post kind: #{name}")
    slug = data['slug'] || name.sub(/\A\d{4}-\d{2}-\d{2}-/, '').sub(/\.md\z/, '')
    assert(!slugs.include?(slug), "Duplicate post slug: #{slug}")
    slugs << slug
  end
end

def build(source, dest, base)
  site = Jekyll::Site.new(Jekyll.configuration('source' => source, 'destination' => dest, 'baseurl' => base, 'quiet' => true, 'future' => false))
  site.process
  site
end

def inspect_build(site, destination, base)
  html_files = Dir.glob(File.join(destination, '**', '*.html'))
  assert(!html_files.empty?, 'Build produced no HTML')
  html_files.each do |file|
    html = File.read(file)
    assert(html.scan(/<h1[\s>]/).size == 1, "Expected one h1: #{file}")
    assert(html.include?('name="color-scheme" content="dark"'), "Missing dark mode: #{file}")
    assert(html.include?('Skip to content'), "Missing skip link: #{file}")
    assert(!html.match?(/\{\{|\{%/), "Unrendered Liquid: #{file}")
    html.scan(/(?:href|src)="([^"]+)"/).flatten.each do |raw|
      link = CGI.unescapeHTML(raw)
      next if link.start_with?('#', 'http:', 'https:', 'mailto:', 'data:')
      path = URI::DEFAULT_PARSER.unescape(link.split(/[?#]/).first || '')
      next if path.empty?
      if path.start_with?('/')
        assert(base.empty? || path == base || path.start_with?(base + '/'), "Missing base path: #{link} in #{file}")
        path = path.delete_prefix(base).delete_prefix('/')
        target = File.join(destination, path)
      else
        target = File.expand_path(path, File.dirname(file))
      end
      target = File.join(target, 'index.html') if File.directory?(target)
      assert(File.file?(target), "Broken local link: #{link} in #{file}")
    end
  end
  %w[feed.xml sitemap.xml].each do |name|
    xml = File.read(File.join(destination, name))
    REXML::Document.new(xml)
    expected_posts = site.posts.docs
    if name == 'feed.xml'
      limit = site.config.dig('feed', 'posts_limit') || 10
      expected_posts = expected_posts.sort_by(&:date).reverse.first(limit)
    end
    expected_posts.each { |post| assert(xml.include?(post.url), "Missing published post from #{name}") }
  end
  assert(!File.exist?(File.join(destination, 'templates')), 'Templates leaked into site')
  assert(!File.exist?(File.join(destination, 'scripts')), 'Build scripts leaked into site')
end

validate_source
Dir.mktmpdir('network-notes-check-') do |temporary|
  source = File.join(temporary, 'source')
  FileUtils.mkdir_p(source)
  Dir.children(ROOT).reject { |name| %w[.git .bundle _site .jekyll-cache vendor].include?(name) }.each do |name|
    FileUtils.cp_r(File.join(ROOT, name), source)
  end
  ['', '/network-notes'].each do |base|
    destination = File.join(temporary, base.empty? ? 'root' : 'project')
    site = build(source, destination, base)
    inspect_build(site, destination, base)
    puts "PASS actual content, baseurl=#{base.inspect}"
  end
  # Fixtures live only in a temporary copy; they can never be deployed.
  FileUtils.rm_rf(File.join(source, '_posts'))
  FileUtils.mkdir_p(File.join(source, '_posts'))
  destination = File.join(temporary, 'empty')
  site = build(source, destination, '/network-notes')
  inspect_build(site, destination, '/network-notes')
  assert(File.read(File.join(destination, 'index.html')).include?('Every network starts somewhere.'), 'Missing empty state')
  assert(File.read(File.join(destination, 'topics/index.html')).include?('The first connections are ahead.'), 'Missing empty topics')

  File.write(File.join(source, '_posts/2020-01-01-qa-visible.md'), <<~POST)
    ---
    title: "QA visible post"
    summary: "A test of the publication pipeline."
    tags: [routing]
    kind: Lab report
    published: true
    featured: true
    updated: 2020-02-01
    ---
    ## Verification

    ```text
    show ip route
    ```

    | Test | Result |
    | --- | --- |
    | Connectivity | Verified in this test fixture only |
  POST
  File.write(File.join(source, '_posts/2020-01-02-qa-hidden.md'), "---\ntitle: QA_SECRET_DRAFT\nsummary: Hidden\ntags: [secret-topic]\nkind: Learning note\npublished: false\n---\nQA_SECRET_DRAFT\n")
  ['', '/network-notes'].each do |base|
    destination = File.join(temporary, base.empty? ? 'single-root' : 'single-project')
    site = build(source, destination, base)
    inspect_build(site, destination, base)
    all_output = Dir.glob(File.join(destination, '**/*.{html,xml}')).map { |file| File.read(file) }.join
    assert(!all_output.include?('QA_SECRET_DRAFT') && !all_output.include?('secret-topic'), 'Unpublished content leaked')
    assert(!File.exist?(File.join(destination, 'posts/qa-hidden/index.html')), 'Draft page generated')
    assert(File.exist?(File.join(destination, 'posts/qa-visible/index.html')), 'Stable post URL missing')
    assert(File.read(File.join(destination, 'index.html')).include?('Selected work'), 'Featured placement missing')
    assert(File.read(File.join(destination, 'topics/index.html')).include?('routing'), 'Topic missing')
    assert(File.read(File.join(destination, 'lab/index.html')).include?('QA visible post'), 'Lab report missing from lab page')
    if base.empty? && ENV['QA_PREVIEW']
      FileUtils.cp_r(destination, ENV.fetch('QA_PREVIEW'))
    end
    puts "PASS single post, featured work, topics, lab report, draft exclusion, baseurl=#{base.inspect}"
  end
  # The feed intentionally contains only recent posts; the sitemap covers the archive.
  11.times do |index|
    day = format('%02d', index + 1)
    File.write(File.join(source, "_posts/2020-02-#{day}-archive-#{day}.md"), "---\ntitle: Archive #{day}\nsummary: Feed boundary fixture\ntags: [routing]\nkind: Learning note\npublished: true\n---\nArchive fixture.\n")
  end
  destination = File.join(temporary, 'archive')
  site = build(source, destination, '/network-notes')
  inspect_build(site, destination, '/network-notes')
  feed = REXML::Document.new(File.read(File.join(destination, 'feed.xml')))
  assert(REXML::XPath.match(feed, '//atom:entry', { 'atom' => 'http://www.w3.org/2005/Atom' }).size == 10, 'Expected latest ten RSS entries')
  assert(!File.read(File.join(destination, 'feed.xml')).include?('/posts/qa-visible/'), 'Oldest post should have aged out of the RSS feed')
  assert(File.read(File.join(destination, 'sitemap.xml')).include?('/posts/qa-visible/'), 'Older posts must remain in the sitemap')
  puts 'PASS twelve-post archive and ten-entry RSS limit'
end
puts 'All content and build checks passed.'
