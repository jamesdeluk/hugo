---
title: 'Shell'
---

	- [basic operations](#basic-operations)
- [connecting commands](#connecting-commands)
- [system and filesystem](#system-and-filesystem)
- [grep](#grep)
- [tasks and open files](#tasks-and-open-files)
- [users and permissions](#users-and-permissions)
- [hashes](#hashes)
- [scheduling](#scheduling)
- [help](#help)
- [change prompt](#change-prompt)
- [path](#path)
- [text-related](#text-related)
- [video-related](#video-related)
- [compression](#compression)
- [script](#script)
- [loop](#loop)
- [shell control](#shell-control)
	- [commands](#commands)
	- [keyboard shortcuts](#keyboard-shortcuts)
	- [tmux](#tmux)
- [other](#other)
	- [monit](#monit)

mainly linux

[macOS-specific](Shell%20d063e08d5d504ca689f1449db50a1523/macOS-specific%20a577274835454e0498f24eff787d9ce4.md)

### basic operations

```bash
sudo rm -frv ~/.Trash

del /s /q /f /a .DS_STORE
del /s /q /f /a ._.*

touch
mkdir
mv # can rename
rm (-r)
cp

# windows
Xcopy /E /I SourceFolder DestinationFolder # copies all files/folders in SF to DF

type nul > <file.txt>
echo.> <tile.txt>

echo
cat
less
tail
head

<command> | xclip -sel c # to clipboard, inc pwd

sudo <user>
sudo -l # current user privileges
```

## connecting commands

```bash
<command> > file.txt
<command> 2> file.txt # error code
<command> >> file.txt # append to file
<command> < file.txt # use file as input for command
file.txt | <command> # same as <

<command> | tee (-a) file.txt # show and add (append)

<command1> && <command2> # first then if successful second
<command1> || <command2> # second if first fails
<command1> ; <command2> # do both commands even if first fails

<command1> | <command2> # pass output of first to second
<command> | cut -d: -f2 # take input, cut lines by ':', take '2'th part
<command> | sort
<command> | uniq # unique lines

<command> -- <input> # -- signifies end of options/parameters
# e.g. rm -f -- -f # force remove a file called -f
```

## system and filesystem

```bash
# linux system information
uname -a

which <binary>

# file type
file <file>

# open with defauly program
xdg-open <file>

# mounting
mount # list currently mounted
mount /dev/<addr> /mnt

# disk free
df -ah # all, human-readable

# disk usage
du # -s for whole folder, -h for MB/GB not B

# explains linux filesystem (hierarchy)
man hier

# services
service <name> status/start/stop # 'old' style
systemctl status/start/stop/enable/disable/reload/restart <service> # 'new' style
journalctl

# see users/passwords
/etc/passwd # users
/etc/shadow # hashes

# windows, recursive search for file
dir /s <file>
dir /a /r .DS_STORE

# linux, recursive search for file
find . -name "<filename>" # / for root, . for current
find . -maxdepth 2 -perm /111 # search max 2 levels deep for minimum 111 (also -111 for minimum)

# find line # of file
sed '#q;d' <file>.txt

# linux, make link
ln (-s) <file> <link>
```

## grep

```bash
# search file for search_term
grep "search_term" <file/directory>

*.* # search all files in directory
./* -R # search all files in directory and subdirectories

-- -n # search for -n
-i # ignore case
-w # full words
-R # recursive
-n # which line of file it is

grep "^......$" rockyou.txt > rockyou6letters.txt

<command> | grep <search_term>
```

## tasks and open files

```bash
tasklist | find "<search_term>"

ps (-ef) # ef includes system
ps aux
ps aux | grep <process_name> # find pid
top # bit like task manager
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

## users and permissions

```bash
w
who

chmod (-R) <num><num><num>
# owner group all
# binary-coded decimal; 4 read 2 write 2 execute
chmod +x <file>
chown <user> <file>
chown <user>:<group> <file>

adduser
addgroup
deluser
# less preferable: userdel, useradd
passwd <user> <new_password>
usermod -L/U <user> # un/lock
usermod -a -G <group-to-add-user-to> <user>
```

## hashes

```bash
# powershell
PS> Get-Filehash <file>
-algorithm [md5/sha1]

# linux
$ sha256sum <file>
$ sha1sum <file>
$ md5sum <file>
```

## scheduling

```bash
# *nix

/etc/chron.d/ # user
/etc/crontab # global

crontab -e # edit, init
crontab -l # list

/etc/cron.allow
/etc/cron.deny # to block

# windows

schtasks /create /SC hourly /TN <name> /TR <path-to-python path-to-file>
/ST 15:00 # start time at 3pm
/SC MINUTE/HOURLY/DAILY/WEEKLY/MONTHLY # frequency

schtasks /query /TN <name>
schtasks /delete /TN <name>

# https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks
```

## help

```bash
man <command>
whatis <command>
apropos <command> # search manual page names

# windows
<command> /?
```

## change prompt

```bash
# cmd
$ PROMPT $G # >
$ export PROMPT_COMMAND="echo -n \[\$(date +%F-%T)\]\ " # date and time
```

## path

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

## text-related

```bash
# Bulk replace text in .txt/.html
perl -pi -w -e 's/SEARCH_FOR/REPLACE_WITH/g;' *.txt

# Files to text
ls -lhR > list.txt

wc (-l) # word (line) count
pdftotext myfile.pdf - | wc -w # PDF word count
```

## video-related

```bash
echo 'filename'{01..71}.ts | tr " " "\n" > tslist
while read line; do cat $line >> your_new_video.ts; done < tslist
```

## compression

```bash
unzip <file>.zip -d <dir>
unzip -l <file>.zip # show contents

gzip -d <file>.gz

tar -<> <filename>.tar.gz <directory/>
-zxf # unzip
-xcf # zip
-v # verbose
```

*avoid tarbombs → best to do from outside directory*

## script

```bash
script <filename.log> # default is 'typescript'
# other commands
exit # or ctrl-c

script -c '<command>' <filename.log> # output of single command to log

less <filename.log> # to view
scriptreplay -s <filename.log> --timing=time.log # real time replay
```

## loop

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

## other

### monit

email alerts if http/mysql/... change

can also make [localhost](http://localhost) gui