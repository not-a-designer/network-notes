---
title: Learning in the open.
eyebrow: About the journal
description: Building a foundation in networking, one question and one experiment at a time.
permalink: /about/
---
{% if site.author.name != '' %}<p class="eyebrow">{{ site.author.name | escape }}</p>{% endif %}

Network Notes is my record of learning networking and planning a home lab, with the goal of working toward the CCNA and a role in networking.

This journal starts at the planning stage. As the lab develops, I’ll document the decisions, configurations, test results, and troubleshooting that go into making it work.

## What you’ll find here

- **Learning notes:** concepts explained in my own words, with examples and references.
- **Lab reports:** experiments that connect a configuration to an observable result.
- **Troubleshooting notes:** the symptoms, evidence, and reasoning behind a fix.

The aim is to make the work understandable and repeatable, including the things that do not work the first time.

{% if site.author.certification != '' %}
## Certification

{{ site.author.certification | escape }}
{% endif %}

## Elsewhere

{% if site.social_links.github != '' %}- [GitHub]({{ site.social_links.github }}){% endif %}
{% if site.social_links.linkedin != '' %}- [LinkedIn]({{ site.social_links.linkedin }}){% endif %}
{% if site.social_links.resume != '' %}- [Résumé]({{ site.social_links.resume | relative_url }}){% endif %}
