---
title: The home lab
eyebrow: From the drawing board
description: A place to turn networking concepts into experiments that can be observed, tested, and explained.
permalink: /lab/
---
<div class="callout"><span class="eyebrow">Status · Planning</span><p>This lab is still being designed. The items below are learning goals, not a record of installed equipment or completed configurations.</p></div>

## What the lab is for

The goal is to build a small environment for learning how networks work: how devices find each other, how traffic moves between networks, and how to diagnose a connection that fails.

Each experiment will become a lab report with an objective, configuration details, verification results, and an explanation of what changed.

## A starting point to explore

This is a conceptual layout to guide planning. Equipment, interfaces, addressing, and the choice of physical or simulated devices are still to be decided.

<figure><a href="{{ '/assets/images/planned-topology.svg' | relative_url }}"><img src="{{ '/assets/images/planned-topology.svg' | relative_url }}" alt="Conceptual lab: a routing device connects to a switch, which connects to two test hosts. All devices and connections are planned." width="1000" height="380"></a><figcaption>Concept only · Open the diagram for a full-size view.</figcaption></figure>

## The first milestones

| Milestone | What I want to document | Status |
| --- | --- | --- |
| Define the environment | Scope, requirements, and equipment or simulator choices | Planned |
| Create an addressing plan | Subnets, gateways, and the reasoning behind the choices | Planned |
| Establish connectivity | A small topology with repeatable verification steps | Planned |
| Investigate a fault | Symptoms, evidence, root cause, and a verified correction | Planned |
| Explore segmentation | VLANs, routing between networks, and traffic controls | Planned |

## Lab notes

{% assign lab_posts = site.posts | where: 'kind', 'Lab report' %}
{% if lab_posts.size > 0 %}
<ul>{% for post in lab_posts %}<li><a href="{{ post.url | relative_url }}">{{ post.title | escape }}</a></li>{% endfor %}</ul>
{% else %}
Lab reports will appear here as experiments are completed and documented.
{% endif %}
