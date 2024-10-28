---
title: Six Months as a SOC Analyst - My Top Three Tips
categories: ["IT and Cyber Security"]
tags: ['Security Monitoring']
date: 2021-07-25
---

## Introduction

It's already been six months since I started my journey as a Security Analyst (time flies!) so I thought I'd share some thoughts to help other aspiring SOC Analysts.

I started with **no professional IT experience**, only a lifelong interest. My background was primarily in engineering. I prepared for an infosec role by doing **CompTIA Security+ and Blue Team Level One** certifications ([review here](http://btl1.gibbins.me)), playing around on [TryHackMe](https://www.jamesgibbins.com/posts/thm-aoc2/) and with Security Onion, and generally learning as much as possible.

It goes without saying that **every SOC and every company is different**. I work for a UK-based hosting provider within their security team, which acts as a managed security service provider (MSSP). We have thousands of clients, from small one-man bands to enterprise companies with thousands of employees. Our team uses a combination of FOSS, commercial, and in-house tools.

It's hard to tell stories without giving away confidential or revealing information about my company. But it goes without saying that **a lot has happened in the last six months**: I've found compromised systems and done malware investigations; I've broken things and received calls from concerned clients; and of course I've triaged thousands of alerts.

Instead of stories, I'll give my **top three bits of advice for new and soon-to-be analysts**. Don't expect anything ground-breaking here, but what's tried-and-true is tried-and-true for a reason.

## Three Bits of Advice

### 1. Know your tools

You'll spend a *lot* of time looking through logs, so get to know how to sort through them using your SIEM. Being able to filter millions of logs down to the specific ones you need, and then quickly add or remove other potentially relevant ones, will save you a lot of time - and stress. **Nothing is more annoying than searching for a needle in a haystack.**

Every SIEM has it's own syntax for searching, but they're all pretty similar. Splunk, for example, has a complex searching system, with piping, calculations, lookups, stats, and more. ELK (Elastic/Logstash/Kibana), on the other hand, has a more simple search, but has separate tools for creating visualisations and data tables, as well as Elasticsearch Query DSL which allows you to create JSON-like searches. However, **fundamentally, they're all logical operators (ANDs, ORs) mixed with fields and values**, e.g. `data_source=flow_logs AND (destination_port=80 OR destination_port=443)`.

<br>

Also, learn how the events in your SIEM get there. In general, raw logs will be created by the endpoint, transmitted to your infrastructure, processed, and then appear in your SIEM. **But what specifically generates the logs on the endpoint? Where exactly does the processing take place? How is it done?**

By learning this you can better understand why some data does end up in your SIEM, and why some doesn't. It's very frustrating trying to find a specific piece of data only to find your endpoints don't log it or your SIEM is configured to not record it! Through understanding the entire process you can see what needs changing to optimise and improve your data.

For example, one of my projects has been ensuring our ruleset is correctly aligned with the MITRE ATT&CK framework. I've been using Atomic Red Team in our test environment, prioritised by Red Canary's Threat Detection Report 2021, to run the atomic tests and see what it flags up in our SIEM. **Because I understand which logs would track these tests (Sysmon), how it logs different events (sysmonconfig.xml), and how our SIEM processes these logs (using rules), I've been able to edit configuration and write new rules to ensure everything is detected and, if malicious, alert our SOC.** Without understanding the log sources, processing systems, the rule syntax, and the alerting pipeline, I wouldn't have been able to improve our detections so effectively.

### 2. Scripting, regex, automation, and templates

This really is a broken record but it's true! I knew some Python before starting, but little else. Over the last six months **I've used PowerShell daily**, both by itself and writing scripts, and it's saved me huge amounts of time. I've also used **Bash** (for Linux machines), and some **Python** for more general tasks. Scripting is especially important when you need **to do the same task hundreds of times** - such as on a schedule, or across an entire network of machines.

For example, **I wanted to do a complex installation across our entire infrastructure**, with pre-installation checks, downloading the installer from our repo and installing it, and then post-installation verification. Doing this manually would have probably taken 30 minutes per machine, totalling hundreds of hours. It took me a couple hours to write and test the script, and then I pushed it out and all machines were sorted within a matter of minutes.

Another time **I wanted to check the status of a service and check the size of a directory every few hours, indefinitely**. I wrote a simple script that would check these for me, scheduled it to run when I needed it, and added a logging function that would report back to me. Not only does it save me time, it avoids the stress of worrying about having to do it - the script runs 24/7, regardless of if I'm in a meeting, or sleeping, or on a client call.

Automation and scripting really are the **ultimate timesavers**.

<br>

Another advantage of knowing these languages is being able to **understand something someone else has written**.

**GitHub** is full of incredibly powerful tools and scripts; however, downloading and running one without first checking it yourself is not the wisest thing to do. What if the script is actually malicious? Being able to do a quick manual code review and understand the main functions etc gives you the confidence to use it.

Relatedly, sooner or later you'll find a **malicious script** on a machine (an Empire script, a PHP backdoor, a Bash reverse shell) placed there by a friendly threat actor. Being able to read and understand what it does will let you know what next steps to take - and how ^&%$ed you might be.

<br>

**How do you learn** to write scripts? You don't need me to tell you this. Google. StackOverflow. There are so many great resources.

<br>

Even **Excel** can be a powerful tool, especially when dealing with data that needs to be made user-friendly (i.e. for sharing with management, or copy-pasting) or comes from other sources (e.g. CSV exports). Sure, you could write a Python script using Pandas/Numpy to manipulate it and Matplotlib or Seaborn to visualise it, but Excel is often a lot quicker! Simple Excel spreadsheets with a few interconnected functions have also saved me countless hours.

<br>

I'm also going to throw **regex** (regular expressions) in here too. It's an incredibly efficient tool for extracting and manipulating data, and can be done easily in text editors such as VSCodium. The more regex you know, the more powerful it is, and it's very easy to get proficient quickly! If you look at my challenge write-ups and other investigations, you'll see I use regex a lot. And a lot of detection rules are based on regex, so there's yet another reason to learn it.

<br>

Finally, **templates**. A lot of alerts will be similar and hence will require sending similar tickets/emails. Don't go through the pain of writing it out each time - create a template that you can copy and paste! Even better, using scripting and automation, integrate this template with your tools so that the email auto-generates. Another small thing, but it saves you yet more hours.

### 3. Take the initiative

The third suggestion I'll make applies to almost everything in life. Take the initiative! **Don't wait for someone else to do something for you**, or simply complain about it - do it yourself.

<br>

This ties in nicely with the previous two points too.

If, through learning your tools, you find your logs are missing data you think might be useful, find out why. Do you need to write new rules? Do you need to implement new software to log new data? **Discover what needs to be done, make a plan, then do it.** Some things may be too big for you to do yourself (e.g. major infrastructure changes); however, you can still make a detailed plan and business case as to what needs to be implemented, why, and how, to be passed on to the relevant people. It will help you get the changes you need actioned, and the guys and girls who do have to action it will thank you for doing a lot of the prep work for them!

If you find yourself doing something simple regularly (checking things, configuration changes, processing data), you should try and automate it. **Write a script or web application, test it, and if it's working well, share it with your team.** Even if you can't write it yourself, see if one already exists. As mentioned, GitHub is an excellent resource - it's very unlikely you're the only person to have faced the issue you're facing. Just remember to check the code first and don't trust it blindly.

<br>

Of course, there are caveats to taking the initiative. Don't go fiddling with things you shouldn't and annoying your Engineers by breaking things (you shouldn't be able to anyway if you're abiding by the principle of least privilege, but better safe than sorry). Test a lot, and check with whomever you need to before rolling something out. For bigger, more strategic things, you should check you won't be wasting your time - don't spend months investigating SOAR A if there's already a plan to implement SOAR B. And, most importantly, make sure this doesn't detract from you doing your actual job - those alerts need to be dealt with!

## Summary

There we have it; three simple bits of advice for new people in infosec. There's a lot more I could have written, but these are what have helped me most in my first six months, and for a newbie, these are where I'd recommend you start.

<br>

Here's to another six months - and another six years! (decades might be pushing it)

## Comments?

Feel free to comment on my [LinkedIn post](https://www.linkedin.com/posts/jamgib_six-months-as-a-soc-analyst-my-top-three-activity-6826133780428918785-7NfO), my [Reddit post](https://www.reddit.com/r/cybersecurity/comments/ot9fdy/six_months_as_a_soc_analyst_my_top_three_tips/), or [contact me directly](https://www.jamesgibbins.com/)