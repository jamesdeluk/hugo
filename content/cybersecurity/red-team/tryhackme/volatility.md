---
title: 'Volatility'
date: 2020-07-28
---


testing RAM

```bash
$ sudo apt-get install volatility -y

# which profile to use
$ volatility -f cridex.vmem imageinfo
Volatility Foundation Volatility Framework 2.6
INFO    : volatility.debug    : Determining profile based on KDBG search...
          Suggested Profile(s) : WinXPSP2x86, WinXPSP3x86 (Instantiated with WinXPSP2x86)
# output continues

# list of processes
$ volatility -f cridex.vmem --profile=WinXPSP2x86 pslist

# active network connections
$ volatility -f cridex.vmem --profile=WinXPSP2x86 netscan
# XP too old, no output

 # hidden processes (display false)
$ volatility -f cridex.vmem --profile=WinXPSP2x86 psxview
0x024a0598 csrss.exe               584 True   True   True     True   False True    True
# output also shows trues

# injected processes (display false)
$ volatility -f cridex.vmem --profile=WinXPSP2x86 ldrmodules
584 csrss.exe            0x00460000 False  False  False \WINDOWS\Fonts\vgasys.fon
# output also shows trues

# patches to system dlls (<unknown> is bad)
$ volatility -f cridex.vmem --profile=WinXPSP2x86 apihooks
# slowwwww

# find malware, dump to directory
$ mkdir badshit
$ volatility -f cridex.vmem --profile=WinXPSP2x86 malfind -D badshit

# dlls loaded into memory
$ volatility -f cridex.vmem --profile=WinXPSP2x86 dlllist
# long output

# dumps dlls from infected process to directory
$ mkdir badshitdll
$ volatility -f cridex.vmem --profile=WinXPSP2x86 --pid=584 dlldump -D badshitdll

# upload dumps to virustotal, matches cridex
```