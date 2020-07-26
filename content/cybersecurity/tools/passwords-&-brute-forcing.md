---
title: 'Passwords & Brute Forcing'
---

- [John](#john)
- [hashcat](#hashcat)
- [fcrackzip](#fcrackzip)
- [hydra](#hydra)
- [Patador](#patador)

## John

```bash
sudo
zip2john file.zip > hash.txt
john --format=zip hash.txt
#same for rar

john <file>
john --show <file>

--format=
# raw-md5
# raw-sha1

john /etc/shadow #users of unix machine

rm ./root/.john/john.pot

ssh2john
```

## hashcat

```bash
$ hashcat <options> <hashes_file> <wordlist> 

# attack modes
-a0 # with wordlist
-a3 # brute force
-a3 ?a?a?a?a # four chars long, any char
# ?l, u, d, h, H, s, a, b

# hash type
-m3200 # bcrypt
-m1800 # sha512crypt ($6$)
-m0 # md5
-m100 # sha1
https://hashcat.net/wiki/doku.php?id=example_hashes
```

## fcrackzip

```bash
$ fcrackzip -b --method 2 -D  -p /usr/share/wordlists/rockyou.txt -v ./file.zip
# -b = brute force
# --mehod 2 = zip
# -D = dictionary
# -v = verify
```

## hydra

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

![passwords-&-brute-forcing_img1](../img/passwords-&-brute-forcing_img1.png)

## Patador