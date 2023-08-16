---
title: "The Planet's Prestige (Email and Attachment Analysis)"
categories: ["IT and Cyber Security"]
tags: ['Blue Team Labs Online']
date: 2021-06-20
---

[https://blueteamlabs.online/home/challenge/10](https://blueteamlabs.online/home/challenge/10)

<br>

- [What is the email service used by the malicious actor?](#what-is-the-email-service-used-by-the-malicious-actor)
- [What is the Reply-To email address?](#what-is-the-reply-to-email-address)
- [What is the filetype of the received attachment which helped to continue the investigation](#what-is-the-filetype-of-the-received-attachment-which-helped-to-continue-the-investigation)
- [What is the name of the malicious actor?](#what-is-the-name-of-the-malicious-actor)
- [What is the location of the attacker in this Universe?](#what-is-the-location-of-the-attacker-in-this-universe)
- [What could be the probable C2 domain to control the attacker’s autonomous bots?](#what-could-be-the-probable-cc-domain-to-control-the-attackers-autonomous-bots)

## What is the email service used by the malicious actor?

Open the email in your favourite text editor (VSCode). The `Received` field tells you which server an email came from.

`Received: from localhost ([emkei.cz](http://emkei.cz/). [93.99.104.210])`

## What is the Reply-To email address?

Even easier. Look for the `Reply-To` field.

`Reply-To: [negeja3921@pashter.com](mailto:negeja3921@pashter.com)`

## What is the filetype of the received attachment which helped to continue the investigation

At the bottom of the email we have some base64 encoded files. These are the attachments. Sure, I could open it with an email program, but that's too much hassle!

The first one (I've cropped the code to keep this article short):

```bash
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

SGkgV[...]J+SsA==
```

```bash
$ echo SGkgV[...]J+SsA== | base64 -d
Hi TheMajorOnEarth,

The abducted CoCanDians are with me including the President’s daughter. Dont worry. They are safe in a secret location.
Send me 1 Billion CoCanDs🤑 in cash💸 with a spaceship🚀 and my autonomous bots will safely bring back your citizens.

I heard that CoCanDians have the best brains in the Universe. Solve the puzzle I sent as an attachment for the next steps.

I’m approximately 12.8 light minutes away from the sun and my advice for the puzzle is

“Don't Trust Your Eyes”

Lol😂

See you Major. Waiting for the Cassshhhh💰
```

12.8 light minutes is 230,000,000km. Mars is about 228,000,000km. So they're likely on Mars.

Next one:

```bash
Content-Type: application/pdf; name="PuzzleToCoCanDa.pdf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="PuzzleToCoCanDa.pdf"

UEsDB[...]AAAAA=
```

```bash
$ echo UEsDB[...]AAAAA= | base64 -d > PuzzleToCoCanDa.pdf
```

Except if you try to open it with a PDF viewer, it fails. So what is it, really?

```bash
$ file PuzzleToCoCanDa.pdf
PuzzleToCoCanDa.pdf: Zip archive data, at least v2.0 to extract
```

It's a .zip! And that's our answer. But while we're here:

```bash
$ mv PuzzleToCoCanDa.pdf PuzzleToCoCanDa.zip
$ unzip PuzzleToCoCanDa.zip
Archive:  PuzzleToCoCanDa.zip
  inflating: PuzzleToCoCanDa/DaughtersCrown
  inflating: PuzzleToCoCanDa/GoodJobMajor
  inflating: PuzzleToCoCanDa/Money.xlsx

$ cd PuzzleToCoCanDa/

$ find . -exec file {} \;
./DaughtersCrown: JPEG image data, JFIF standard 1.01, resolution (DPI), density 120x120, segment length 16, baseline, precision 8, 822x435, components 3
./GoodJobMajor: PDF document, version 1.5
./Money.xlsx: Microsoft Excel 2007+
$ mv DaughtersCrown DaughtersCrown.jpg
$ mv GoodJobMajor GoodJobMajor.pdf
```

## What is the name of the malicious actor?

DaughtersCrown didn't seem to contain any hidden information.

However, if we check the metadata for the PDF:

```bash
$ exiftool GoodJobMajor.pdf
[...]
Author                          : Pestero Negeja
[...]
```

## What is the location of the attacker in this Universe?

Now for the Excel. Nothing useful on Sheet2. Sheet3 appears to be empty, but what if we check for any hidden text? Select it all and change the font colour... Aha! A hidden base64-encoded string.

```bash
$ echo VGhlIE1hcnRpYW4gQ29sb255LCBCZXNpZGUgSW50ZXJwbGFuZXRhcnkgU3BhY2Vwb3J0Lg== | base64 -d
The Martian Colony, Beside Interplanetary Spaceport.
```

That confirms our Mars suspicion, based on 12.8 light seconds.

## What could be the probable C&C domain to control the attacker’s autonomous bots?

The same server the email came from makes sense (i.e. `Received`) - pashter[.]com