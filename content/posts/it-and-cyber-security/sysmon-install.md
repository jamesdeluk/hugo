---
title: "Sysmon: How to install, upgrade, and uninstall"
categories: ["IT and Cyber Security"]
tags: ['Security Monitoring']
date: 2021-06-02
---

<br>

- [Introduction](#introduction)
- [Helpful Links](#helpful-links)
- [Install](#install)
- [Upgrade](#upgrade)
- [Uninstall](#uninstall)
  * [The Problem](#the-problem)
  * [The Investigation](#the-investigation)
  * [The Solution](#the-solution)

## Introduction

If you're on this page you probably don't need me to explain much about what Sysmon is or why it is an excellent tool for security monitoring. In short:

- It's part of Microsoft's Sysinternals Suite
    - So it should play nice with Windows
- It can monitor almost anything that happens on a Windows host
    - So it can detect all the most common MITRE ATT&CKs
- It logs using Windows Event Logs
    - So it's easy to export to a SIEM etc for analysis

However, if you've tried rolling Sysmon out to a large number of machines, and then removing or updating it, you may have experienced some issues. At least, I did. So I've collated some of my findings.

At the time of writing Sysmon is on version 13.20.

## Helpful Links

Main website: [https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)

Sysmon guide: [https://github.com/trustedsec/SysmonCommunityGuide/blob/master/install-and-configuration.md](https://github.com/trustedsec/SysmonCommunityGuide/blob/master/install-and-configuration.md)

Sysmon support: [https://docs.microsoft.com/en-us/answers/topics/windows-sysinternals-sysmon.html](https://docs.microsoft.com/en-us/answers/topics/windows-sysinternals-sysmon.html)

## Install

This is the easy bit. Download `Sysmon.zip` from the main website, extract, then run:

`Sysmon64.exe -i`

If you have a config file you want to use:

`Sysmon64.exe -i <path-to-config.xml>`

Done.

## Upgrade

This is where it gets more complicated. You can't upgrade:

`The service Sysmon64 is already registered. Uninstall Sysmon before reinstalling.`

## Uninstall

And even this isn't simply. While Sysmon has a built-in uninstall action:

`Sysmon64.exe -u`

### The Problem

Except, sometimes it fails. And when it does, you're kind of stuck. You can't reinstall Sysmon, as it claims Sysmon is already installed, but you also can't uninstall it by rerunning the command, as it says it's not installed. Catch 22!

There is another option:

`Sysmon64.exe -u force`

Although there is no documentation on exactly what it forces. See my forum post: [https://docs.microsoft.com/en-us/answers/questions/404683/sysmon-u-vs-u-force.html](https://docs.microsoft.com/en-us/answers/questions/404683/sysmon-u-vs-u-force.html)

And it doesn't seem to make much difference anyway.

### The Investigation

This led me to further investigation. I ran several installs and uninstalls and took snapshots using [Regshot](https://sourceforge.net/projects/regshot/), an awesome tool that lets you do before-and-afters for the filesystem and registry.

From this, I found Sysmon affects the following:

- `C:\Windows\Sysmon64.exe`
- `C:\Windows\SysmonDrv.sys`
- `HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64`
- `HKLM:\SYSTEM\CurrentControlSet\Services\SysmonDrv`
- `HKLM:\SYSTEM\ControlSet001\Services\Sysmon64`
- `HKLM:\SYSTEM\ControlSet001\Services\SysmonDrv`
- `HKLM:\SYSTEM\ControlSet002\Services\Sysmon64`
- `HKLM:\SYSTEM\ControlSet002\Services\SysmonDrv`
- `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational`
- `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{5770385f-c22a-43e0-bf4c-06f5698ffbd9}`
- `HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Microsoft-Windows-Sysmon-Operational`

Other findings:

1. Even though it says `Sysmon64 removed.`, uninstalling Sysmon does *not* remove the `Sysmon64.exe` file itself. This needs to be done manually.
2. If it fails, often even a machine reboot won't fix it. This is because the `Services\SysmonDrv` registry keys, and `SysmonDrv.sys`, still exist. When the machine restarts, the service will start (note it's not visible in Task Manager or the Services manager). If you try to uninstall or reinstall, you get the above "already exists" issue.

This means, if the `Sysmon64.exe -u` fails, you'll need to do some manual intervention. This is the best I've found.

### The Solution

First, I wrote a script to check the above files, to see what exists and what doesn't. In production I used a more complex one that feeds into our SIEM, but this is the core of it:

{{< gist jamesdeluk 39e0825067c51ea9684143cfd50caf53 >}}

I like to use `O` for success and `X` for fail, from my teaching in Korea days.

For a fresh install, the output is something like this:

```powershell
O : C:\Windows\Sysmon64.exe
O : C:\Windows\SysmonDrv.sys
O : HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64
O : HKLM:\SYSTEM\CurrentControlSet\Services\SysmonDrv
O : HKLM:\SYSTEM\ControlSet001\Services\Sysmon64
O : HKLM:\SYSTEM\ControlSet001\Services\SysmonDrv
X : HKLM:\SYSTEM\ControlSet002\Services\Sysmon64
X : HKLM:\SYSTEM\ControlSet002\Services\SysmonDrv
O : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational
O : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{5770385f-c22a-43e0-bf4c-06f5698ffbd9}
O : HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Microsoft-Windows-Sysmon-Operational
Running : Sysmon64
Running : SysmonDrv
```

However, a failed uninstall might look something like this:

```powershell
O : C:\Windows\Sysmon64.exe
O : C:\Windows\SysmonDrv.sys
X : HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64
O : HKLM:\SYSTEM\CurrentControlSet\Services\SysmonDrv
X : HKLM:\SYSTEM\ControlSet001\Services\Sysmon64
O : HKLM:\SYSTEM\ControlSet001\Services\SysmonDrv
X : HKLM:\SYSTEM\ControlSet002\Services\Sysmon64
O : HKLM:\SYSTEM\ControlSet002\Services\SysmonDrv
X : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational
X : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{5770385f-c22a-43e0-bf4c-06f5698ffbd9}
X : HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Microsoft-Windows-Sysmon-Operational
: Sysmon64
Running : SysmonDrv
```

The executable is there, but the service relating to it doesn't exist. Yet the driver is still up and running. If you try to stop the driver manually after a failed `-u` uninstall, it often doesn't - you get a `Stopping the service failed` error, or it just hangs at `Stopping`.

There is a solution, however. If the registry keys relating to the service don't exist, then, on the next reboot, the service doesn't exist either. Hence, it doesn't start (and therefore doesn't need stopping), so you can delete `SysmonSys.Drv` and you're good to go!

To make this easier - yeah, another PowerShell script, with error logging:

{{< gist jamesdeluk 48f1c5b545a1cd10832e25b677f0e758 >}}

The output from my clean install above was (note `O` means successfully deleted):

```powershell
O : HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64
O : HKLM:\SYSTEM\CurrentControlSet\Services\SysmonDrv
Cannot find path 'HKLM:\SYSTEM\ControlSet001\Services\Sysmon64' because it does not exist.
Cannot find path 'HKLM:\SYSTEM\ControlSet001\Services\SysmonDrv' because it does not exist.
Cannot find path 'HKLM:\SYSTEM\ControlSet002\Services\Sysmon64' because it does not exist.
Cannot find path 'HKLM:\SYSTEM\ControlSet002\Services\SysmonDrv' because it does not exist.
O : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational
O : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{5770385f-c22a-43e0-bf4c-06f5698ffbd9}
O : HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Microsoft-Windows-Sysmon-Operational
```

Then, after a reboot, you can delete `C:\Windows\SysmonDrv.sys` (and `C:\Windows\Sysmon64.exe` if you haven't already). If you run `sysmon-checks.ps1` again you'll get this:

```powershell
X : C:\Windows\Sysmon64.exe
X : C:\Windows\SysmonDrv.sys
X : HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64
X : HKLM:\SYSTEM\CurrentControlSet\Services\SysmonDrv
X : HKLM:\SYSTEM\ControlSet001\Services\Sysmon64
X : HKLM:\SYSTEM\ControlSet001\Services\SysmonDrv
X : HKLM:\SYSTEM\ControlSet002\Services\Sysmon64
X : HKLM:\SYSTEM\ControlSet002\Services\SysmonDrv
X : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational
X : HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Publishers\{5770385f-c22a-43e0-bf4c-06f5698ffbd9}
X : HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Microsoft-Windows-Sysmon-Operational
: Sysmon64
: SysmonDrv
```

And then you can install as normal!