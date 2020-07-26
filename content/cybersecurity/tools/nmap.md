---
title: 'nmap'
---

- [general](#general)
- [devices on network](#devices-on-network)
- [scripts](#scripts)
- [find ciphers](#find-ciphers)
- [timing and IDP/IPS](#timing-and-idpips)
- [webmap](#webmap)

## general

filtered = unsure if open or closed

up arrow to check status if in progress

```bash
nmap <args> <ip_address>

# default: top 1000 ports
-F # fast (100 ports)
-p # ports
-p- # all ports
--top-ports X # X top ports
--open # only open

-s<> # scan type
-sS # stealth - syn scan
-sX # XMAS - rst if closed, nothing if open
-sF # FIN - rst if closed, nothing if open
-sN # NULL - rst if closed, nothing if open
-sA # ACK - test if there is firewall (no firewall = rst, firewall = no response)
-sU # UDP

--script ipidseq <ip/24> # to find zombie - Incremental
-sI <zombie_id> <target_id> # idle scan

-Pn # open ports only

-A # aggressive; lots of stuff inc OS; very noisy
-sV # software/service version
-O # operating system

-vvv # (very) (very) verbose
-n # only ips not names

--reason # why nmap says something

-L iplist.txt # from list

-oG # grep output, fewer lines
-oX output.xml # XML output
-oA # all outputs
```

## devices on network

```bash
nmap -sn <ip/24> # with ping, no port scan ; was sP
nmap -sL <ip/24> # no ping, just list
nmap -Pn <ip/24> # no ping, more info, no discovery
# shows MAC, name

| grep "Nmap scan" | cut -d" " -f5 > iplist.txt # find and save
```

## scripts

```bash
ls /usr/share/nmap/scripts
# or
locate *.nse

| grep # to find

--script-help <script-name>

-sC # default scripts for those ports

# add -sV to ensure the port does relate to the correct service or script won't work

--script(=)

# common scripts
vuln
*-brute.nse
*.info-nse
dns-recursion
dns-zone-transfer
http-slowloris-check
ms-sql-info
ms-sql-dump-hashes
nbstat
smb-enum-users
smb-enum-shares

sudo nmap --traceroute --script traceroute-geolocation.nse -p<> <url>
nmap --script http-enum <ip>
```

## find ciphers

```bash
nmap --script=ssl-enum-ciphers -p 443 <ip/url>
```

## timing and IDP/IPS

```bash
-f # fragmentation - small packets - not available for all scans
--source-port 80
--randomize-hosts
-S # spoof
--badsum # purposefully force rejection?

-T0~5 (5min 15s 0.4s normal aggressive insane)(0~2 no parallelism)
--max-retries 2
--host-timeout 30m

--scan-delay 1
--max-parallelism 1
--max-hostgroup 1
```

## webmap

[SabyasachiRana/WebMap](https://github.com/SabyasachiRana/WebMap)

```bash
mkdir /tmp/webmap
docker run -d \
         --name webmap \
         -h webmap \
         -p 8000:8000 \
         -v /tmp/webmap:/opt/xml \
         reborntc/webmap
# now you can run Nmap and save the XML Report on /tmp/webmap
nmap -sT -A -T4 -oX /tmp/webmap/myscan.xml 192.168.1.0/24
# go to http://localhost:8000/
docker stop webmap
```