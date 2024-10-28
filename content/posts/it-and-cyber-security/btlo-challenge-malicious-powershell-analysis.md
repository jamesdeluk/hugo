---
title: "Malicious PowerShell Analysis"
categories: ["IT and Cyber Security"]
tags: ['Blue Team Labs Online']
date: 2021-05-16
---

[https://blueteamlabs.online/home/challenge/7](https://blueteamlabs.online/home/challenge/7)

<br>

- [Open the file](#open-the-file)
- [Decode the file](#decode-the-file)
- [Deobfuscating the script](#deobfuscating-the-script)
  * [Spacing](#spacing)
  * [Fillers](#fillers)
  * [Chars](#chars)
  * [Variables](#variables)
  * [Format Strings](#format-strings)
  * [Replaces](#replaces)
  * [Splits](#splits)
- [Questions](#questions)
  * [What security protocol is being used for the communication with a malicious domain?](#what-security-protocol-is-being-used-for-the-communication-with-a-malicious-domain-)
  * [What directory does the obfuscated PowerShell create? (Starting from \HOME\)](#what-directory-does-the-obfuscated-powershell-create---starting-from--home--)
  * [What file is being downloaded (full name)?](#what-file-is-being-downloaded--full-name--)
  * [What is used to execute the downloaded file?](#what-is-used-to-execute-the-downloaded-file-)
  * [What is the domain name of the URI ending in ‘/6F2gd/’](#what-is-the-domain-name-of-the-uri-ending-in---6f2gd--)
  * [Based on the analysis of the obfuscated code, what is the name of the malware?](#based-on-the-analysis-of-the-obfuscated-code--what-is-the-name-of-the-malware-)

## Open the file

Let's open the text file in a text editor (I like VSCodium) and see what we're dealing with.

![btlo_challenge_malicious_powershell_analysis-0](/img/btlo_challenge_malicious_powershell_analysis-0.png)

An encoded PowerShell script.

## Decode the file

CyberChef is an excellent tool for decoding it. Note PoweShell uses an uncommon encoding (UTF-16LE), so we also need to decode the text as well as convert it from Base64.

![btlo_challenge_malicious_powershell_analysis-1](/img/btlo_challenge_malicious_powershell_analysis-1.png)

Now we have a decoded, but obfuscated, PowerShell script. Let's copy that into our text editor and start deobfuscating.

## Deobfuscating the script

I tried a few automated scripts and tools, but none worked that well. So I'll do it manually.

To make things easier, you can set PowerShell syntax highlighting in VSCodium so, as you progress, more colour will appear.

I also save as a new file after each step in case I need to revert, as some of this might break the actual script. However, it's malicious anyway, so if we make it unrunnable, that's not necessarily a bad thing!

### Spacing

The semicolon splits commands in PowerShell, so for readability, we can replace `;` with two new lines (`\n\n` in regex).

### Fillers

Delete all `'+'` and backticks ```, as they just seem to be filler.

We see quite a few parts split with various combinations of parenthesis, addition signs, and quotes/apostrophes. For example: `$Swrp6tc = (('A69')+'S')`

We can replace these using regex:

`\(\('(.*?)'\)\+'(.*?)'\)` → `$1$2`

`\('(.*?)'\+\('(.*?)'\)\)` → `$1$2`

It also looks okay to delete all `')+('`, `'+('`, and `')+'` in this script. As mentioned above, if it breaks the script (as it probably will), it doesn't matter - it's safer, and we have a backup anyway.

There are a couple others which I did manually, by sight.

### Chars

There are a few `[char](##)` values. For example, `[char](64)` is `@` according to the ASCII table.

### Variables

PowerShell variables begin with `$`. We can see this script has several variables, such as `$J16J=N_0P`. However, if you search the script for the variable e.g. `J16J`, you see it's not in the script. It's purely filler. We can delete all like this, especially given early in the script we see `$ErrorActionPreference = SilentlyContine`, meaning any missing variables will simply be ignored.

In other places, where the variable is only mentioned in two places, we can substitute the variable into where it is called e.g. `$Swrp6tc`.

*Side note*: NOP is a "no operation" instruction in assembly language, and is often used in malware for buffer overflows.

### Format Strings

The format operator `-f` is used to split and reorder strings. You simply need to rearrange them in order of the numbers (note it starts with 0). This can be done using a tool, although in this case I did it manually as it's not too complex (and, as mentioned above, the automated tools I tried failed).

`[TYPe]("{0}{1}{2}{4}{3}" -F 'SYsT','eM.','io.DI','ORY','rECt')` = `SYsteM.io.DIrECtORY` → `System.IO.Directory`

`[TYPe]("{6}{8}{0}{3}{4}{5}{2}{7}{1}" -f'SteM','Ger','Ma','.n','et.seRVIcepOi','nt','s','NA','Y')` = `sYSteM.net.seRVIcepOintMaNAGer` → `System.Net.ServicePointManager`

`($HOME + (('{0}Db_bh30{0}Yf5be5g{0}') -F \))` = `($HOME + ('\Db_bh30\Yf5be5g\')`

### Replaces

There are some `.Replace` commands, which, as the name suggests, replace one thing with another thing. Note for both the below I've already replaced variables and chars and some fillers seen above.

The first one is easier:

`$Imd1yck=$HOME+((('UOHDb_bh30UOHYf5be5gUOH'))."RePlACe"(('UOH'),[StrInG]\))+A69S+(.dll`

If we replace `UOH` with `\`, and get rid of some more filler, we get:

`$Imd1yck=$HOME+('\Db_bh30\Yf5be5g\A69S.dll')`

The second is a bit more complicated:

`$B9fhbyv=]anw[3s://admintk.com/wp-admin/L/@]anw[3s://mikegeerinck.com/c/YYsa/@]anw[3://freelancerwebdesignerhyderabad.com/cgi-bin/S/@]anw[3://etdog.com/wp-content/nu/@]anw[3s://www.hintup.com.br/wp-content/dE/@]anw[3://www.stmarouns.nsw.edu.au/paypal/b8G/@]anw[3://wm.mcdevelop.net/content/6F2gd/."REplACe"(]anw[3,(('sd','sw'),(('http,'3d')[1])`

Fortunately with a bit of common sense we can see `]anw[3` is being replaced with `http`.

`$B9fhbyv=https://admintk.com/wp-admin/L/@https://mikegeerinck.com/c/YYsa/@http://freelancerwebdesignerhyderabad.com/cgi-bin/S/@http://etdog.com/wp-content/nu/@https://www.hintup.com.br/wp-content/dE/@http://www.stmarouns.nsw.edu.au/paypal/b8G/@http://wm.mcdevelop.net/content/6F2gd/`

### Splits

Leading on nicely from the previous result, as it is followed by a split:

`$B9fhbyv=https://admintk.com/wp-admin/L/@https://mikegeerinck.com/c/YYsa/@http://freelancerwebdesignerhyderabad.com/cgi-bin/S/@http://etdog.com/wp-content/nu/@https://www.hintup.com.br/wp-content/dE/@http://www.stmarouns.nsw.edu.au/paypal/b8G/@http://wm.mcdevelop.net/content/6F2gd/."sPLIT"(@)`

Split on `@` - in other words, replace `@` with `,` and wrap the whole statement in `@()` - gives us an array of URLs:

`$B9fhbyv=@(https://admintk.com/wp-admin/L/,https://mikegeerinck.com/c/YYsa/,http://freelancerwebdesignerhyderabad.com/cgi-bin/S/,http://etdog.com/wp-content/nu/,https://www.hintup.com.br/wp-content/dE/,http://www.stmarouns.nsw.edu.au/paypal/b8G/,http://wm.mcdevelop.net/content/6F2gd/)`

By now we should have enough to answer all the questions!

## Questions

### What security protocol is being used for the communication with a malicious domain?

`"sEcuRITYproTocol" = Tls12`

### What directory does the obfuscated PowerShell create? (Starting from \HOME\)

`\HOME\Db_bh30\Yf5be5g\`

### What file is being downloaded (full name)?

`A69S.dll`

### What is used to execute the downloaded file?

`rundll32`

### What is the domain name of the URI ending in ‘/6F2gd/’

`wm.mcdevelop.net`

### Based on the analysis of the obfuscated code, what is the name of the malware?

The script itself doesn't give us this answer. However, if we Google for some of the artifact names, e.g. `A69S.dll` or `wm.mcdevelop.net`, we get our answer:

[MalwareBazaar | SHA256 23be1cb22c94fe77cea5f8e7fef6710eeef5a23e7e7eb9b9dd53f56d1b954269 (Heodo)](https://bazaar.abuse.ch/sample/23be1cb22c94fe77cea5f8e7fef6710eeef5a23e7e7eb9b9dd53f56d1b954269/)

[URLhaus | http://wm.mcdevelop.net/content/6F2gd/](https://urlhaus.abuse.ch/url/948889/)