---
title: "Hammered (Log Analysis)"
categories: ["IT and Cyber Security"]
tags: ['CyberDefenders']
date: 2021-05-27
---

[https://cyberdefenders.org/labs/42](https://cyberdefenders.org/labs/42)

## Contents

- [Initial Analysis](#initial-analysis)
  * [Initial Findings](#initial-findings)
- [Manipulating the Logs](#manipulating-the-logs)
  * [auth.log - sorted by command then time](#authlog---sorted-by-command-then-time)
  * [auth.log - all unique lines sorted by command (excluding timestamp)](#authlog---all-unique-lines-sorted-by-command-excluding-timestamp)
  * [auth.log - extract commands](#authlog---extract-commands)
  * [auth.log - extract IPs](#authlog---extract-ips)
  * [www-access.log - extract IPs](#www-accesslog---extract-ips)
  * [www-access.log - extract user agents](#www-accesslog---extract-user-agents)
- [Questions](#questions)
  * [#1 Which service did the attackers use to gain access to the system?](#1-which-service-did-the-attackers-use-to-gain-access-to-the-system)
  * [#2 What is the operating system version of the targeted system? (one word)](#2-what-is-the-operating-system-version-of-the-targeted-system-one-word)
  * [#3 What is the name of the compromised account](#3-what-is-the-name-of-the-compromised-account)
  * [#4](#4)
  * [#5 Consider that each unique IP represents a different attacker. How many attackers were able to get access to the system?](#5-consider-that-each-unique-ip-represents-a-different-attacker-how-many-attackers-were-able-to-get-access-to-the-system)
  * [#6 Which attackers IP address successfully logged into the system the most number of times?](#6-which-attackers-ip-address-successfully-logged-into-the-system-the-most-number-of-times)
  * [#7 How many requests were sent to the Apache Server?](#7-how-many-requests-were-sent-to-the-apache-server)
  * [#8 How many rules have been added to the firewall?](#8-how-many-rules-have-been-added-to-the-firewall)
  * [#9 One of the downloaded files to the target system is a scanning tool. Provide the tool name.](#9-one-of-the-downloaded-files-to-the-target-system-is-a-scanning-tool-provide-the-tool-name)
  * [#10 When was the last login from the attacker with IP 219.150.161.20?](#10-when-was-the-last-login-from-the-attacker-with-ip-21915016120)
  * [#11 The database displayed two warning messages, provide the most important and dangerous one.](#11-the-database-displayed-two-warning-messages--provide-the-most-important-and-dangerous-one)
  * [#12 Multiple accounts were created on the target system. Which one was created on Apr 26 04:43:15?](#12-multiple-accounts-were-created-on-the-target-system-which-one-was-created-on-apr-26-044315)
  * [#13 Few attackers were using a proxy to run their scans. What is the corresponding user-agent used by this proxy?](#13-few-attackers-were-using-a-proxy-to-run-their-scans-what-is-the-corresponding-user-agent-used-by-this-proxy)
- [Failures](#failures)

## Initial Analysis

When we first unzip the archive, we get a large number of files. The challenge description says there are only five files (although apache2 is a folder containing three files, so seven in total); however, I found some answers are not in those seven files, so we need to consider all the files in the archive. However, most are in those primary five/seven.

Ideally we would create some tools and scripts to aid parsing the data, or even import it into a SIEM, and it would make it a lot quicker - but for my own learning I want to look through manually, get to understand the raw logs.

### Initial Findings

- `auth.log` for logins
- `daemon.log` is mainly `dhclient`, `mysqld`, `ntpd`, `collectd`
- `www-access.log` and `www-media.log` make lots of references to WordPress
- Earliest log: Mar 16 08:09:58 (`kern.log`)
- Latest log: 23/Apr/2010:23:31:27 -0700 (`www-media-log`)

## Manipulating the Logs

As part of my analysis, I need to extract some information from the logs. Without using a script or a tool, the easiest way is to use regex to reorder and filter the data. It's possible these will lose some data but they worked for me!

I love regex.

### auth.log - sorted by command then time

1. Move date to between command and PID: `^(.{15}).{7}(\w+)(:|\[)` → `$2 | $1 | $3`
2. Change month names to month numbers: `Mar`  → `03` , `Apr`  → `04` , `May`  → `05` 
3. Sort Ascending (built into VSCodium; you have to select the lines first)

102,164 lines → 102,164 lines

### auth.log - all unique lines sorted by command (excluding timestamp)

1. Delete the first 22 characters (timestamp): `^.{22}` → nothing
2. Delete command numbers: `\[\d+\]` → nothing
3. Sort ascending, remove duplicates.

102,164 lines → 26,516 lines

### auth.log - extract commands

1. Delete the first 22 characters: `^.{22}` → nothing
2. Delete everything after the command: `(^\w+).*` → `$1`
3. Sort Ascending (built into VSCodium; you have to select the lines first)
4. Remove duplicates: `^(.*)(\n\1)+$` → `$1`

102,164 lines → 13 lines

### auth.log - extract IPs

1. `^.*(\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b).*$` → `$1` [I found the IP regex online]
2. Delete all lines without IPs: `^[a-zA-Z].*$\n` → nothing
3. Sort ascending, remove duplicates.

65 IPs

### www-access.log - extract IPs

`10.0.1.2 - - [19/Apr/2010:06:36:15 -0700] "GET /feed/ HTTP/1.1" 200 16605 "-" "Apple-PubSub/65.12.1" C4nE4goAAQ4AAEP1Dh8AAAAA 3822005`

Very similar to above

1. `^(\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b).*$` → `$1`
2. Sort ascending, remove duplicates.

27 IPs

### www-access.log - extract user agents

`10.0.1.2 - - [19/Apr/2010:06:36:15 -0700] "GET /feed/ HTTP/1.1" 200 16605 "-" "Apple-PubSub/65.12.1" C4nE4goAAQ4AAEP1Dh8AAAAA 3822005`

1. `^.* (\d+|-) ".*" "(.+)".*$` → `$2`
2. Sort ascending, remove duplicates.

13 User Agents (including "-")

## Questions

### #1 Which service did the attackers use to gain access to the system?

We're looking for a service. `auth.log` is related to authentication and authorisation (i.e. access), so that's a good place to start. Let's use the unique commands list created above.

Grouping is mine:

- `CRON`
- `login`, `sshd`
- `su`, `sudo`
- `useradd`, `userdel`, `usermod`, `groupadd`, `passwd`, `chage`, `chfn`, `chsh`

Only two of these are related to actually logging in, and one is the answer.

### #2 What is the operating system version of the targeted system? (one word)

We're looking for OS-related information, and `dmesg` and `kern.log` both give kernel information. They seem like a good place to look.

In fact, the third line of `dmesg` gives us our answer - easy!

### #3 What is the name of the compromised account

Looking through `auth.log` from the beginning, there are mentions of `user1`, `user2`, `user3`, `user4`, and `root`. However, saying exactly *why* it is `root` I can't yet say.

### #4

*There is no question 4*

### #5 Consider that each unique IP represents a different attacker. How many attackers were able to get access to the system?

6. Honestly, I don't know why. Based on how I got #6 below, I think the answer should be 18. Even if you remove IPs that ONLY successfully logged in to `root`, it's still not 6.

### #6 Which attacker's IP address successfully logged into the system the most number of times?

We're looking for `sshd: Accepted password for root`, as `root` was compromised, and `Accepted password` is a successful login. We can use the `auth.log` showing only unique lines sorted by command, as in this file these will all be grouped. Do the above IP extraction on this subset of data and simply see which one appears most. Or look at a later question...

### #7 How many requests were sent to the Apache Server?

How many lines does the `www-access.log` files have?

### #8 How many rules have been added to the firewall?

Linux firewalls are done through `iptables`. It would likely be done through a `sudo` command, and as `auth.log` logs `sudo` commands, let's search that file for `iptables`.

### #9 One of the downloaded files to the target system is a scanning tool. Provide the tool name.

I was expecting this to be in one of the server logs e.g. `www-access.log` or `www-media.log`, as the question mentions "downloaded". But there was nothing there.

Let's take another route. What scanning tool was installed? We have `apt\term.log` and `dpkg.log`, which will relate to installed software. I didn't need to extract all the installed software, I just searched for everyone's favourite scanning software beginning with `n`.

### #10 When was the last login from the attacker with IP 219.150.161.20?

If we start just looking for the IP, we get **a lot** of results. And, if we go to the last one, we see the login failed (`Invalid user`). So what we're looking for is a log with `Accepted` as well as the IP: `^.+Accepted.+219.150.161.20.+$`.

This gives us four results, and the last is the correct answer.

### #11 The database displayed two warning messages, provide the most important and dangerous one.

`daemon.log` looks to have logs regarding MySQL databases. Let's search for `warning` and see what we find.

### #12 Multiple accounts were created on the target system. Which one was created on Apr 26 04:43:15?

Simple, search `auth.log` for the date.

### #13 Few attackers were using a proxy to run their scans. What is the corresponding user-agent used by this proxy?

We go to the `www-access.log` for this one and check the User Agent part. I've already extracted these above. One stands out.

## Failures

I tried to extract usernames from `auth.log` but it didn't succeed.

1. `^.+for user ([a-zA-Z0-9_\-\.]+) by.+$` → `$1`
2. `^.+for user ([a-zA-Z0-9_\-\.]+)$` → `$1`
3. `^.+user=([a-zA-Z0-9_\-\.]+).+$` → `$1`
4. `^.+for ([a-zA-Z0-9]+).*$` → `$1`
5. `^.+name=([a-zA-Z0-9]+).*$` → `$1`
6. `^.+invalid user.+$\n` → nothing
7. `^.+user= rhost.+$\n` → nothing
8. `^.+unknown.*$\n` → nothing
9. `^.+POSSIBLE BREAK-IN ATTEMPT.*$\n` → nothing
10. `^.+\?\?\?.$\n` → nothing
11. `^.+Server listening.$\n` → nothing
12. `^.+Bind to port.$\n` → nothing
13. `^.+identification.$\n` → nothing