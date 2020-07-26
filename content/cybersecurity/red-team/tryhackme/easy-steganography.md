---
title: 'Easy steganography'
---

- [Flag 1](#flag-1)
- [Flag 2](#flag-2)
- [Flag 3](#flag-3)
- [Flag 4](#flag-4)

[https://tryhackme.com/room/easysteganography](https://tryhackme.com/room/easysteganography)

## Flag 1

TinEye reverse image lookup, download that looks the same, same dimensions, etc

```bash
$ diff -a flag1.jpeg downloaded-image.jpeg | hexdump -C

# -a: treat all files as text
# -C: canonical hex+ASCII display

St3g4n0
```

## Flag 2

```bash
$ binwalk flag2.jpeg
0             0x0             JPEG image data, EXIF standard
12            0xC             TIFF image data, little-endian offset of first image directory: 8
78447         0x1326F         JPEG image data, JFIF standard 1.01

$ binwalk -e flag2.jpeg # doesn't work
$ binwalk -dd=".*" flag2.jpeg

$ cd _flag2.jpeg.extracted/
$ file 1326F
1326F: JPEG image data, JFIF standard 1.01, aspect ratio, density 1x1, segment length 16, progressive, precision 8, 620x372, components 3
$ xdg-open 1326F

algorithm
```

## Flag 3

```bash
$ strings flag3.jpeg
```

## Flag 4

```bash
$ strings flag4.jpeg

# or

$ binwalk flag4.jpeg 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, EXIF standard
12            0xC             TIFF image data, little-endian offset of first image directory: 8
78447         0x1326F         XML document, version: "1.0"

$ binwalk -dd=".*" flag4.jpeg

$ cd _flag4.jpeg.extracted/
$ file 1326F
1326F: XML 1.0 document, UTF-8 Unicode text, with very long lines
$ xdg-open 1326F

TryHardered
```