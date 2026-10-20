# Network Notes

A dark-only networking journal and home lab portfolio, built with Jekyll. Posts are ordinary Markdown files; no local software is needed to publish from GitHub.

**Site:** https://not-a-designer.github.io/network-notes/

## Publish the site

1. Put these source files in the `main` branch of `not-a-designer/network-notes`.
2. In **Settings → Pages → Build and deployment**, choose **GitHub Actions** as the source.
3. In **Actions**, run **Validate and publish** if it has not already started.
4. Wait for the build and deployment jobs to turn green, then open the site above.

Pull requests build and validate without publishing. A push to `main` deploys only after all checks pass. Failed builds leave the previous deployment intact.

## Write a post in GitHub

1. Open `templates/learning-note.md` or `templates/lab-report.md` and copy its contents.
2. Choose **Add file → Create new file**. Name it `_posts/YYYY-MM-DD-your-post-slug.md`, using today's date or an earlier date.
3. Paste the template, replace the title and summary, and write your post. Use lowercase tags such as `subnetting`, `routing`, `switching`, `security`, and `troubleshooting`.
4. Use GitHub's **Preview** tab to check Markdown. This previews the content, not the site's theme.
5. Leave `published: false` while writing. When ready, change it to `published: true` and commit to `main`.
6. Check **Actions → Validate and publish**, then check your new post on the live site.

The four starter outlines are unpublished. The homepage intentionally starts with an empty state until you publish your first note. Draft source is still visible in this public repository.

Post metadata:

```yaml
---
title: "What I learned about subnet masks"
summary: "A worked example connecting prefix length to usable addresses."
tags: [subnetting, fundamentals]
kind: Learning note # or Lab report
published: false
featured: false
# updated: 2026-10-20
---
```

`featured: true` places a published post in Selected work. Published `Lab report` posts automatically appear on Home Lab. Keep the filename slug stable after publication to preserve `/posts/your-post-slug/`. Future-dated posts do not publish until a later build after that date; there is no scheduled publishing job.

## Images, diagrams, and configurations

Upload images to `assets/images/your-post-slug/` through **Add file → Upload files**. Use a PNG or SVG exported from your diagram tool. Add descriptive alt text:

```liquid
![Describe the topology]({{ '/assets/images/your-post-slug/topology.png' | relative_url }})
```

Images open at full size when clicked. For an explicit link that also works without JavaScript, wrap the image in a Markdown link using the same URL. Tables and long code blocks scroll horizontally. Use fenced code blocks with `text` for device configurations, or a supported lowercase language such as `bash` or `python`.

Before committing, remove passwords, tokens, private keys, public IP addresses you do not want exposed, and identifying details from screenshots and configuration exports. Deleting them later does not remove them from Git history.

## Personalize

Edit `_config.yml` to set the title, description, author name, certification wording, and GitHub/LinkedIn/résumé links. Empty identity fields are hidden. Only add credentials you actually hold. Edit `about.md` for your story and `lab.md` as the lab develops; distinguish planned and completed work.

For a user site, set `baseurl: ""`; for this project site, keep `baseurl: "/network-notes"`. `url` is the origin only (`https://not-a-designer.github.io`). Always use `relative_url` for internal links and images. Add résumé PDFs under `assets/` and set the résumé link to their path, for example `/assets/resume.pdf`.

## Local preview and validation (optional)

Install Ruby 3.3 and Bundler, then run:

```sh
bundle install
bundle exec ruby scripts/check.rb
bundle exec jekyll serve --baseurl /network-notes
```

Visit `http://127.0.0.1:4000/network-notes/`. To preview unpublished posts locally, add `--unpublished`; never add that flag to the deployment workflow. Windows local setup may require RubyInstaller with its development tools; GitHub's web editor avoids that requirement.

The checks build both root and project URL variants, validate post metadata and local links, parse RSS and sitemap XML, and exercise empty, single-post, featured, topic, and draft states in a disposable copy. No test posts are published.

## If publishing fails

Open the failed Actions run and expand the red step. Check YAML indentation, a quoted title containing colons, valid filenames, and missing image links. Correct the file and commit again. A missing Pages configuration is fixed in **Settings → Pages**, choosing **GitHub Actions**.

To undo a change, revert the offending commit and push the revert to `main`. With Git locally: `git revert <commit-sha>` followed by `git push`. For a single text file, you can also restore its previous contents through GitHub's History view and commit the correction. Do not force-push history to roll back the website.

## Maintenance

Dependencies are locked in `Gemfile.lock`. Update deliberately with `bundle update`, run the checks, and commit the revised lockfile. CSS is plain CSS; there is no Node build step. RSS, sitemap, and social metadata are generated automatically. Comments, analytics, newsletters, and search are intentionally absent.
