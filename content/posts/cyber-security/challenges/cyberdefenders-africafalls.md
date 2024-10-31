---
title: "AfricaFalls (Disk Image Forensics)"
tags: ['CyberDefenders']
date: 2021-07-18
---

[https://cyberdefenders.org/labs/66](https://cyberdefenders.org/labs/66)

## Contents

- [Introduction](#introduction)
  * [Tools](#tools)
- [Preparation](#preparation)
- [Questions](#questions)
  * [#1: What is the MD5 hash value of the suspect disk?](#1-what-is-the-md5-hash-value-of-the-suspect-disk)
  * [#2: What phrase did the suspect search for on 2021-04-29 18:17:38 UTC?](#2-what-phrase-did-the-suspect-search-for-on-2021-04-29-181738-utc)
  * [#3: What is the IPv4 address of the FTP server the suspect connected to?](#3-what-is-the-ipv4-address-of-the-ftp-server-the-suspect-connected-to)
  * [#4: What date and time was a password list deleted in UTC?](#4-what-date-and-time-was-a-password-list-deleted-in-utc)
  * [#5: How many times was Tor Browser ran on the suspects computer?](#5-how-many-times-was-tor-browser-ran-on-the-suspects-computer)
  * [#6: What is the suspects email address?](#6-what-is-the-suspects-email-address)
  * [#7: What is the FQDN did the suspect port scan?](#7-what-is-the-fqdn-did-the-suspect-port-scan)
  * [#8: What country was picture 20210429_152043.jpg allegedly taken in?](#8-what-country-was-picture-20210429_152043jpg-allegedly-taken-in)
  * [#9: What is the parent folder name picture 20210429_151535.jpg was in before the suspect copy it to contact folder on his desktop?](#9-what-is-the-parent-folder-name-picture-20210429_151535jpg-was-in-before-the-suspect-copy-it-to-contact-folder-on-his-desktop)
  * [#10: A Windows password hashes for an account are below. What is the users password](#10-a-windows-password-hashes-for-an-account-are-below-what-is-the-users-password)
  * [#11: What is the user John Does Windows login password?](#11-what-is-the-user-john-does-windows-login-password)
- [Comments](#comments)

## Introduction

> John Doe was accused of doing illegal activities. A disk image of his laptop was taken. Your task is to analyze the image and understand what happened under the hood.

### Tools

- [FTK Imager](https://accessdata.com/product-download/ftk-imager-version-4-5)
- [Autopsy](https://www.autopsy.com/download/)
- [rifiuti2](https://abelcheung.github.io/rifiuti2/)
- [Browsing History View](https://www.nirsoft.net/utils/browsing_history_view.html)
- [WinPrefetchView](https://www.nirsoft.net/utils/win_prefetch_view.html)
- [ShellBagsExplorer](https://f001.backblazeb2.com/file/EricZimmermanTools/ShellBagsExplorer.zip)
- [mimikatz](https://github.com/gentilkiwi/mimikatz/wiki)

## Preparation

For this challenge I'll use FireEye's FLARE VM, available here: [https://github.com/fireeye/flare-vm](https://github.com/fireeye/flare-vm)

It doesn't include all the above tools on it by default (e.g. FTK Imager), so I installed them manually.

The file provided is a .zip containing two files: the image (`DiskDrigger.ad1`) and a text file.

FTK Imager can open the `.ad1` file, but Autopsy cannot (nor can any of the other tools mentioned above). However, FTK has an export function, so I was able to import the `.ad1` into FTK Imager then Export it as files (as it's not possible to export it as another disk image that Autopsy can open). This file directory can be imported into Autopsy (and most of the other tools above), allowing for analysis. FTK Imager only allows viewing the files in the image, similar to a file explorer.

## Questions

### #1: What is the MD5 hash value of the suspect disk?

The text file appears to be a summary of what's contained within the disk image, including files, dates, and hashes.

> 9471e69c95d8909ae60ddff30d50ffa1

### #2: What phrase did the suspect search for on 2021-04-29 18:17:38 UTC?

Autopsy's Web Search section will help here. The searches have dates but they all appear to be in PDT. A quick Google tells us that PDT is UTC-7, though - meaning we need to look for searches taking place at 11:17:38 on the 29th.

> password cracking lists

### #3: What is the IPv4 address of the FTP server the suspect connected to?

This one came from FTK Imager. I was just browsing the files, seeing what there was. I saw we have the AppData folder for the user, which is where application settings etc are kept. This led me to a FileZilla configuration folder `001Win10.e01_Partition 2 [50647MB]_NONAME [NTFS]\[root]\Users\John Doe\AppData\Roaming\FileZilla\` - FileZilla being a common FTP server. In that folder was a file `recentservers.xml`

> 192.168.1.20

### #4: What date and time was a password list deleted in UTC?

Autopsy has a Recycle Bin section with a single file in it. The source file name is `$RW9BJ2Z.txt`, but the original path was `C:\Users\John Doe\Downloads\10-million-password-list-top-100.txt`. - so we know it's this file in question. Autopsy also gives us the Time Deleted - again in PDT, so we need to add seven for the answer.

> 2021-04-29 18:22:17 UTC

### #5: How many times was Tor Browser ran on the suspect's computer?

This was a bit of a sneaky one, and took me a while. Hunting around, there's not many references to Tor Browser at all! In Autopsy's Run Programs section there is a mention of `TORBROWSER-INSTALL-WIN64-10.0`, but in Installed Programs there's no mention of Tor being installed. And then I realised. If there's no logs of something happening... Maybe it didn't?

> 0

### #6: What is the suspect's email address?

Autopsy has this build in search for email addresses, and it found several unique ones. Only one is a ProtonMail address.

> dreammaker82@protonmail.com

### #7: What is the FQDN did the suspect port scan?

Autopsy does provide a list of URLs detected by regex, but there is over 47,000. I'm not going to look through all of them! There must be another way.

Port scan immediately screams nmap to me, so I'll do a keyword search for that. It returns 63 results - a lot more manageable. One of the files is promising: `/Users/John Doe/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt`. This is the PowerShell history file. If we can see the command used to run nmap, we can see the FQDN.

And we can.

> dfir.science

### #8: What country was picture "20210429_152043.jpg" allegedly taken in?

Autopsy has a Geolocation tool. Clicking it brings us a map, with two pins. One is the photo in the question.

> Zambia

### #9: What is the parent folder name picture "20210429_151535.jpg" was in before the suspect copy it to "contact" folder on his desktop?

Looking at the file metadata in Autopsy, we can see it was taken by an LG Electronics LM-Q725K, which is a smartphone. If we look in USB Device Attached, we can see it there too: LG Electronics, Inc. LM-X420xxx/G2/G3 Android Phone (MTP/download mode).

Background knowledge time, many cameras store photos in a DCIM, or a subfolder of this folder.

If we search for DCIM, we get a Shell Bags Artifact relating to this photo: `My Computer\LG Q7\Internal storage\DCIM\Camera`

> Camera

### #10: A Windows password hashes for an account are below. What is the user's password

**Anon:1001:aad3b435b51404eeaad3b435b51404ee:3DE1A36F6DDB8E036DFD75E8E20C4AF4:::**

This is a pwdump hash. `aad3b435b51404eeaad3b435b51404ee` is the LM hash, and `3DE1A36F6DDB8E036DFD75E8E20C4AF4` is the NT one.

I put the NT hash into an online cracker, onlinehashcrack.com, and it gave us the answer.

Alternatively, you could use Hashcat to do it yourself:

`hashcat.exe -m1000 -a3 "3DE1A36F6DDB8E036DFD75E8E20C4AF4"`

`-m1000` tells the tool it's an NTLM hash; `-a3` means brute force (i.e. try every possible combination).

To view it, once it's finished, you need to run:

`hashcat.exe -m1000 -a3 "3DE1A36F6DDB8E036DFD75E8E20C4AF4" --show`

I did this on my actual laptop (not the FLARE VM), as it uses GPUs to speed up the process, and VirtualBox doesn't have access to the host GPUs.

> AFR1CA!

### #11: What is the user "John Doe's" Windows login password?

Autopsy has a section for Operating System User Accounts, where we can see John Doe. Unfortunately it's not as simple as reading his password from here! However, we can see the data it's found is from the SAM file, `/Windows/System32/config/SAM`.

Now it's time for Mimikatz. The command we need is `mimikatz # lsadump::sam /system:"C:\[...]\Windows\System32\config\SYSTEM" /sam:"C:\[...]\Windows\System32\config\SAM"`, replacing [...] with wherever the file is on your system (remember we exported the image files using FTK Imager before we began).

Scrolling down, we see `User : John Doe` then `Hash NTLM: ecf53750b76cc9a62057ca85ff4c850e`.

Put this into Hashcat: `hashcat.exe -m1000 -a3 "ecf53750b76cc9a62057ca85ff4c850e"` then again with `--show` and this challenge is complete!

> ctf2021

(onlinehashcrack.com did also find it)

## Comments?

Feel free to comment on my [LinkedIn post](https://www.linkedin.com/posts/jamgib_cyberdefenders-africafalls-disk-image-activity-6822885676925759489-GPOw)