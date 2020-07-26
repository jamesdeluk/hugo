---
title: 'Subdomains and Directories'
---

- [Gobuster](#gobuster)
- [Sublist3r](#sublist3r)
- [dirb](#dirb)
- [dirsearch](#dirsearch)
- [dirbuster](#dirbuster)
- [LinkFinder](#linkfinder)
- [nmap](#nmap)
- [Aquatone](#aquatone)
- [subfinder](#subfinder)
- [Knockpy](#knockpy)
- [also](#also)

also amass, knock, fierce

## Gobuster

```bash
# directories and files
gobuster dir -u <url> -w <wordlist>
-q -n -e # for grep
-x "<filetype" # to include files

# subdomains, with ips
gobuster dns -d <url> -w <wordlist> -i
```

## Sublist3r

```bash
python Sublist3r.py -d <url>
```

## dirb

```bash
# directories and fiels
dirb <url> <wordlist>
```

## dirsearch

```bash
# directories and files
python dirsearch.py -u <url> -e <exts>
# exts e.g. php,html,png,js,jpg - or -E for common
```

## dirbuster

GUI

## LinkFinder

javascript endpoints

```bash
python linkfinder.py -i <url> -d # entire domain
```

## nmap

```bash
nmap -p 80 --script dns-brute.nse <url>
```

## Aquatone

## subfinder

## Knockpy

## also

[OSINT & Enumeration](OSINT%20&%20Enumeration%20586f6428169e42db91939f312aa62c67.md)

[Subdomains Enumeration Cheat Sheet](Subdomains%20and%20Directories%2020f4d61832414a39a9948ee0aec0bbbd/Subdomains%20Enumeration%20Cheat%20Sheet%200e7c469d40a143fc9f04d5936bfb4643.md)