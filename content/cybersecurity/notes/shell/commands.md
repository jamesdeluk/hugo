---
title: commands
---

Bash, Terminal, Cmd, PowerShell

## standard

### basic operations

```bash
sudo rm -frv ~/.Trash

cd \
dir /a /r .DS_STORE
del /s /q /f /a .DS_STORE
del /s /q /f /a ._.*

touch
mkdir
mv # can rename
rm (-r)
cp

echo
cat
less
tail
head

<command> | xclip -sel c # to clipboard
```

### connecting commands

```bash
<command> > file.txt
<command> 2> file.txt # error code
<command> >> file.txt # append to file
<command> < file.txt # use file as input for command
file.txt | <command> # same as <

<command> | tee (-a) file.txt # show and add (append)

<command1> && <command2> # first then if successful second
<command1> || <command2> # second if first fails

<command1> | <command2> # pass output of first to second
<command> | cut -d: -f2 # take input, cut lines by ':', take '2'th part
<command> | sort
<command> | uniq # unique lines

<command> -- <input> # -- signifies end of options/parameters
# e.g. rm -f -- -f # force remove a file called -f
```

### grep

```bash
grep ./* # search all files in directory
<command> | grep <search_term>
grep -- -n # search for -n
-i # ignore case
-w # full words
```

### tasks and open files

```bash
tasklist | find "<search_term>"

ps
ps aux
top
ps aux | grep <process_name> # find pid
strace
sudo renice <niceness> <pid>

kill <num> <pid> # num opt, def 15, 9 is extreme kill
pkill
xkill # click window

lsof # list open files
lsof <path/to/file> # processes using file
lsof -p <pid>
lsof | grep log
lsof -i :80 # port 80
lsof -i tcp
```

### system and filesystem

```bash
uname -a

which <binary>

file <file> # file type

xdg-open <file> # open with default program

mount # see mounted
mount /dev/<addr> /mnt # mount <addr> to mnt

df -ah # all, human-readable
du # disk usage, -s for whole folder, -h for MB/GB not B

service <name> status/start/stop # 'old' stype
systemctl status/start/stop/enable/disable/reload/restart <service> # 'new' version
journalctl

man hier
/etc/passwd # users
/etc/shadow # hashes
```

### users and permissions

```bash
w
who

chmod (-R) <num><num><num> # read write execute in binary-coded decimal for admin group all
chmod +x <file>

useradd
userdel
passwd <user> <new_password>
usermod -L/U <user> # un/lock
```

### cron

```bash
/etc/chron.d/ # user
/etc/crontab # global

crontab -e # edit, init
crontab -l # list

/etc/cron.allow
/etc/cron.deny # to block
```

### manuals etc

```bash
man <command>
whatis <command>
```

### change prompt

```bash
# cmd
$ PROMPT $G # >
```

### path

```bash
# show
echo $PATH
echo %PATH% # or %path%
set (displays path and others)

# temporary
PATH=$PATH:/newdir
PATH=/newdir:$PATH
set PATH="%PATH%;C:\newdir"

# permanent
.profile
.bashrc
export PATH=$PATH:/newdir # at bottom
setx PATH "%PATH%;C:\newdir" (this user, no space, copies all users to local...]

# beware of fake sudos etc - so use absolute paths
```

### text-related

```bash
# Bulk replace text in .txt/.html
perl -pi -w -e 's/SEARCH_FOR/REPLACE_WITH/g;' *.txt

# Files to text
ls -lhR > list.txt

wc (-l) # word (line) count
pdftotext myfile.pdf - | wc -w # PDF word count
```

### video-related

```bash
echo 'filename'{01..71}.ts | tr " " "\n" > tslist
while read line; do cat $line >> your_new_video.ts; done < tslist
```

### tar

```bash
tar -<> <filename>.tar.gz <directory/>
-zxf # unzip
-xcf # zip
-v # verbose
```

*avoid tarbombs → best to do from outside directory*

### script

```bash
script <filename.log> # default is 'typescript'
# other commands
exit # or ctrl-c

script -c '<command>' <filename.log> # output of single command to log

less <filename.log> # to view
scriptreplay -s <filename.log> --timing=time.log # real time replay
```

### loop

```bash
# *nix
for i in *.*; do <>; done

# Windows
for /f %a in (file.txt) do <>
# (file) can include command e.g. ('dir /B *.txt')
# also: for /f "tokens=1 delims=." %a in () do <>
for /L %i in (1,1,10); do <%i> done
```

## shell control

### commands

```bash
history

alias <alias_name>="<command>"
# add to .bashrc for permanent
```

### keyboard shortcuts

ctrl-c stops

ctrl-d close shell

tab autocompletion

clear or ctrl-l

ctrl-a or home to start

ctrl-e or end to end

alt-f alt-b for forward back by word or ctrl left ctrl right

ctrl-r to search history by most recent, ctrl-g to go back

### tmux

```bash
tmux
tmux ls # view sessions
tmux attach -t 0 # attach to session 0
tmux rename-session -t 0 <name> # rename session
tmux new -s <name> # new session with name
tmux kill-session -t 0 # kill session 0

ctrl-b = command key

% # new pane to right
" # new pane to bottom
arrows # swap panes
c # new window
0 # window 0
, # rename window
d # detach

# in shell
exit # close pane
```

## networking

### local info

```bash
ifconfig # ipconfig on windows
ipconfig /all

ip addr show

# my ip

dig +short myip.opendns.com @resolver1.opendns.com
dig TXT +short o-o.myaddr.l.google.com @ns1.google.com

# or

nslookup [myip.opendns.com](http://myip.opendns.com/) [resolver1.opendns.com](http://resolver1.opendns.com/)
```

### whois & dns info

```bash
whois <url>

nslookup <ip/url>

host <url> # all
host -t a <url> # ip
host -t ns <url> # name server
host -t mx <url> # mail server

dig <url> # ipv4 address
dig -t ns <url> # name server
dig axfr <url> @<name server> # lots inc subdomains

dsenum <url> # like dig and host but more

fierce -dns <url> # like dig and host
```

### arp - physical devices

```bash
arp -a

netdiscover
```

### netstat - ports, routing table

```bash
netstat
-a # all ports
-n # ip not name
-o # owning process ID
-p # owning process name

-t # tcp
-u # udp

# -ao takes a lot longer than -#ano?

-r # routing table

-tnlp # listening ports

-tulpn # most things

# add number for interval
netstat -ano 1 | find "<pid>"

```

### scp

```bash
ssh remote_user@ip # connect to computer with file
scp <file> <user>@<ip>:<remote_dir> # local or remote or other
```

### sftp

```bash
sftp remote_user@ip

(l)pwd # (local) pwd
(!)dir # (remote) dir
(l)cd # (local) cd
put <file> # transfer
```

### openvpn

```bash
sudo openvpn <file>.ovpn
```

### wget

```bash
wget -r -l 1 https://www.howtostudykorean.com/other-stuff/lesson-list/ --no-check-certificate -k -p
-c -nc
wget --mirror --convert-links (-k) --adjust-extension (-E) --page-requisites (-p) http://example.org
-D http://howtostudykorean.com/
wget --no-check-certificate -mpEk
wget http://traffic.libsyn.com/talktomeinkorean/ttmikdi-l{3..10}l{1..30}.mp3
wget -A pdf,jpg -m -p -E -k -K -np -nd http://site/path/
```

## other

### monit

email alerts if http/mysql/... change

can also make [localhost](http://localhost) gui