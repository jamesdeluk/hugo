---
title: Passwords & Brute Forcing
---

- [John](#john)
- [Hashcat](#hashcat)
- [fcrackzip](#fcrackzip)
- [Hydra](#hydra)
- [Patador](#patador)

## John

```bash
sudo
zip2john file.zip > hash.txt
john --format=zip hash.txt
#same for rar

john <file>
john --show <file>

john /etc/shadow #users of unix machine

rm ./root/.john/john.pot
```

## Hashcat

## fcrackzip

```bash
$ fcrackzip -b --method 2 -D  -p /usr/share/wordlists/rockyou.txt -v ./file.zip
# -b = brute force
# --mehod 2 = zip
# -D = dictionary
# -v = verify
```

## Hydra

```bash
hydra

-l <usename> # single username
-L <usenames.txt> # file of usernames
-p <password> # single password
-P <passwords.txt> # file of passwords

<ip>

http-post-form "/login:username=^USER^&password=^PASS^:invalid" # or :F= ; info from browser/network/post request/headers/edit
ssh

-V # -v is different, -V shows username/password

-t 4 # 4 threads, recommended 1/core
```

![Passwords%20Brute%20Forcing%2068ad44bad0e049078035648edec4ea21/Untitled.png](Passwords%20Brute%20Forcing%2068ad44bad0e049078035648edec4ea21/Untitled.png)

## Patador