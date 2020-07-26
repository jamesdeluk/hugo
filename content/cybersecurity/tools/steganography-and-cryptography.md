---
title: 'Steganography and Cryptography'
---

- [Stegcracker](#stegcracker)
- [steghide](#steghide)
- [binwalk](#binwalk)
- [pngcheck](#pngcheck)
- [Other](#other)

## Stegcracker

```bash
$ stegcracker <image.jpg>
```

## steghide

```bash
$ steghide extract -sf <image.jpg> -p <password>
```

## binwalk

```bash
$ binwalk <image.jpg>
-e # extract known file types
# --dd=<type:ext:cmd> extract <type> signatures, give the files an extension of <ext>, and execute <cmd> e.g. =".*"
```

## pngcheck

```bash
$ pngcheck -v <image.png>
```

## Other

```bash
file <image.jpg>
strings <image.jpg>
```