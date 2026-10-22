---
title: "Looking past the Wi-Fi: understanding what each network component does"
summary: "My first step from using a network to understanding it: exploring the jobs behind a simple connection, from laptop to web server."
tags: [ccna, fundamentals]
kind: Learning note
published: true
featured: false
---

*CCNA 200-301 v1.1 · Objective 1.1 a–h*

I’m used to being on the user side of a network: connecting to Wi-Fi, plugging in an Ethernet cable, and expecting things to work. Now that I’m studying networking, I want to understand what happens between making that connection and reaching something on the other end.

Before designing a home lab, I’m starting with a basic question: **what does each part of the network actually do?**

The terminology can be confusing because the box we usually call a “router” at home often does several jobs. It can provide Wi-Fi, connect wired devices, route traffic, and apply firewall rules. Learning those functions separately is helping me see what that one box is responsible for.

For this post, I’m using an example network. This is my starting point for understanding the components, rather than a setup I’ve already built.

## Starting with something familiar

Imagine opening a website on a laptop connected to Wi-Fi:

```text
Laptop
   │ Wi-Fi
Access point
   │ Ethernet + power
PoE switch
   │
Router / firewall
   │
Internet
   │
Web server
```

This diagram leaves out much of the internet between the router and the server. It also shows the components as separate devices, even though some of these functions can share one box.

I find it easier to start with that familiar action—opening a website—and work out what each component contributes.

## 1.1a — Routers

The router’s job is to move traffic between networks.

In this example, the website is outside the laptop’s local subnet. The laptop sends the traffic to its default gateway, and the router uses its routing table to decide where to forward it next.

The part I want to get comfortable with is that routing also happens inside networks. If I eventually put my lab clients and servers in different subnets, something will need to route traffic between them.

For now, the question I’m keeping in mind is: **does this traffic need to reach another network?** [Cisco’s networking overview](https://www.cisco.com/site/us/en/learn/topics/small-business/networking-basics.html)

## 1.1b — Layer 2 and Layer 3 switches

A switch gives wired devices a way to communicate on the local network. In the example, it connects the access point to the router.

A Layer 2 switch uses MAC addresses to forward Ethernet frames within a VLAN. Its MAC address table helps it determine which port leads toward a destination.

I’m also learning that switches can do more than that. A Layer 3 switch can perform routing, including between VLANs.

At this stage, I’m organizing the difference like this:

- **Layer 2:** forwarding frames within a VLAN.
- **Layer 3:** routing packets between IP networks.

That gives me a starting point for understanding why a network might use both switches and routers, and where their capabilities can overlap. [Cisco’s networking explanation](https://www.cisco.com/site/us/en/learn/topics/networking/what-is-computer-networking.html), [Layer 3 interface documentation](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus3000/sw/interfaces/6_x/b_Cisco_n3k_Interfaces_Configuration_Guide_602_U11/b_Cisco_n3k_Interfaces_Configuration_Guide_602_U11_chapter_011.pdf)

## 1.1c — Next-generation firewalls and IPS

Getting traffic to its destination is only part of the job. The network also needs rules about which communication is allowed.

A firewall applies those rules. A next-generation firewall adds capabilities such as recognizing applications and integrating intrusion prevention.

An intrusion prevention system, or IPS, inspects traffic for signs of attacks and can block traffic that matches its detection rules. It can be part of the firewall or a separate system.

The distinction that helps me is:

- The router decides where traffic should go.
- Firewall policy determines whether the communication is permitted.
- IPS inspection looks for signs of an attack in the traffic it can inspect.

For my future lab, I want to get beyond seeing a connection succeed. I also want to understand why it was allowed—and how to check that a connection I intended to block actually fails. [Cisco’s NGFW explanation](https://www.cisco.com/site/us/en/learn/topics/security/what-is-a-next-generation-firewall.html)

## 1.1d — Access points

The access point provides the laptop’s wireless connection. In this example, it carries the wireless client’s traffic onto the wired LAN.

Separating this role from routing helps explain something familiar from the user side: **being connected to Wi-Fi doesn’t necessarily mean the internet is reachable.**

The laptop might have a working wireless connection while something farther along the path is failing. That is a distinction I want to remember when I start troubleshooting. [Cisco’s networking overview](https://www.cisco.com/site/us/en/learn/topics/small-business/networking-basics.html)

## 1.1e — Controllers

Controllers become easier for me to understand when I imagine managing several access points.

Configuring each device individually could become repetitive and make it easier to end up with inconsistent settings. A wireless LAN controller provides a central place to coordinate access points and their configuration.

One detail I need to keep straight is that centralized management does not always mean all client traffic follows the same path. Some designs send wireless client traffic through the controller; others forward it locally at the access point.

That leaves me with two separate questions to ask about a design: **where is it managed, and where does the traffic travel?** [Cisco’s campus design guide](https://www.cisco.com/c/en/us/td/docs/solutions/CVD/Campus/cisco-campus-lan-wlan-design-guide.html), [Local and central switching](https://www.cisco.com/c/en/us/support/docs/wireless/catalyst-9800-series-wireless-controllers/213945-understand-flexconnect-on-9800-wireless.html)

## 1.1f — Endpoints

Endpoints are the part of networking I’m most familiar with as a user: laptops, phones, desktops, printers, and other connected devices.

In this example, the laptop starts the request and receives the response.

Looking at the laptop as part of the network also changes how I want to approach troubleshooting. Before assuming the router or switch is at fault, I need to check whether the client itself has the right settings. [Cisco’s overview of connected devices](https://www.cisco.com/site/us/en/learn/topics/networking/what-is-computer-networking.html)

## 1.1g — Servers

A server provides a service to clients. Here, the laptop requests website content and the web server provides it.

“Server” describes the role being performed. It doesn’t have to mean a large physical machine in a rack; a service can also run in a virtual environment.

Servers are endpoints too. In this example, calling one device the client and the other the server helps describe their roles in the interaction.

For my lab, I’d like to run a small local service eventually. Having something inside the lab to connect to would give me a clearer starting point for testing than relying entirely on an internet destination.

## 1.1h — Power over Ethernet

Power over Ethernet, or PoE, lets compatible devices receive power and data through the same Ethernet cable.

In this example, the switch powers the access point. That could make placement easier because the access point would not need a separate power adapter at its location.

There are still details to check. The switch and powered device need compatible PoE support, and the switch needs enough power available for the connected equipment.

That gives me another item for my eventual equipment checklist: check the power requirements and available budget, as well as the number of ports. [Cisco’s PoE configuration guide](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst9300/software/release/17-5/configuration_guide/int_hw/b_175_int_and_hw_9300_cg/configuring_poe.pdf)

## What I’m taking into my first lab

My starting point is to look at a network as a collection of jobs: connecting devices, moving traffic between networks, applying security rules, providing services, and managing the equipment.

I don’t expect to understand every detail from reading about the components once. The next step is to make a small setup where I can predict what should happen and then check that prediction.

I want to start with two questions:

1. What happens when two devices communicate within the same subnet?
2. What changes when they are in different subnets?

For each test, I’ll draw the expected path, record the configuration, and compare it with what I observe. That should give me something concrete to build on as I move through the rest of the syllabus.

