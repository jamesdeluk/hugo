---
title: 'SMB'
---

- [SMBMap](#smbmap)
- [smbclient](#smbclient)

## SMBMap

```bash
$ smbmap

-u # username
-p # password
-H # host IP
-s # share
-d # domain
-x # execute command
--download
--upload
```

## smbclient

```bash
$ smbclient

-W # domain/workgroup
-I # IP
-c <command>
-u # username
-p # password
-N # no password

# in prompt
get <file>
put <location>
```