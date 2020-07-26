---
title: 'Hacker101 CTF'
---

- [Micro-CMS v1 (4/4)](#micro-cms-v1-44)
- [Micro-CMS v2 (0/3)](#micro-cms-v2-03)
- [Postbook (4/7)](#postbook-47)
- [Petshop Pro (3/3)](#petshop-pro-33)
- [Cody's First Blog (0/3)](#cody's-first-blog-03)

opinion: feels faker than tryhackme or overthewire - try random things and the flag appears even though it doesn't really give you access to anything useful in real life

## Micro-CMS v1 (4/4)

**Flag 1**

/page/4 was 403...

something hidden there?

how can i access?

how else can i access page content?

edit page...

/page/edit/4

success

**#### Flag 2**

sql path injection...

/page/1'

success

**### Flag 3**

phinjection...

in input box for page name...

success

**Flag 4**

scripts not allowed...

how else can a script run?

what's built in to html?

onclick event to button...

can't create new button...

page 2 has button, add to that...

check button attribute

success

## Micro-CMS v2 (0/3)

- username = ', following error:

```sql
Traceback (most recent call last):
  File "./main.py", line 145, in do_login
    if cur.execute('SELECT password FROM admins WHERE username=\'%s\'' % request.form['username'].replace('%', '%%')) == 0:
  File "/usr/local/lib/python2.7/site-packages/MySQLdb/cursors.py", line 255, in execute
    self.errorhandler(self, exc, value)
  File "/usr/local/lib/python2.7/site-packages/MySQLdb/connections.py", line 50, in defaulterrorhandler
    raise errorvalue
ProgrammingError: (1064, "You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near ''''' at line 1")
```

- 

## Postbook (4/7)

1. create user, find posts by user and admin, try to log in with defaults, user:password → ^FLAG^91203a121ac4dc017908e35ca29470671276ec73a528f0aacc10519e260a195f$FLAG$
2. [http://35.190.155.168/904ff2a500/index.php?page=profile.php&id=](http://35.190.155.168/904ff2a500/index.php?page=profile.php&id=a)c for user, try others, b is admin, secret post → ^FLAG^ea3172917a4d5c5d738fdb02c13a4690bd4f64e12c7cbbcee15acd6ab0848b2c$FLAG$
3. new post form, inspect, hidden field, unhide and change → ^FLAG^a2e8967905cf5c1c3b18613d219ac226b723c7d3535b6609d156a4dd2eb0ff45$FLAG$
4. edit page, change id to admin's hidden one, change to not secret → ^FLAG^d42873c00bccbbc6a20e46ff4e5e7fa398c84035fc335e09792ac7750f84348d$FLAG$

- posts are [http://35.190.155.168/904ff2a500/index.php?page=view.php&id=2](http://35.190.155.168/904ff2a500/index.php?page=view.php&id=2), even hidden → as before
- use change password form to edit admin password also

## Petshop Pro (3/3)

1. Cart page, hidden field, change value (to 0) → ^FLAG^d811c5ce023d835c29928baafe08ef0c8a36a0eed4dad90cf1de6b8374a6b032$FLAG$
2. /login, brute force with hydra
    1. hydra -L /home/kali/SecLists/Usernames/Names/names.txt -P password.txt 34.74.105.127 http-post-form "/e6a100659b/login:username=^USER^&password=^PASS^:Invalid username"
    2. [80][http-post-form] host: 34.74.105.127 login: querida password: password
    3. hydra -L user -P ~/SecLists/Passwords/xato-[].txt 34.74.105.127 http-post-form "/e6a100659b/login:username=^USER^&password=^PASS^:Invalid password"
    4. [80][http-post-form] host: 34.74.105.127 login: querida password: support
3. edit, change description, go to cart

## Cody's First Blog (0/3)

1. course code has <!--<a href="?page=admin.auth.inc">Admin login</a>-→
    1. log in page with comment box
    2. std injection doesn't work
2. talks about include - include injection?
3. [http://34.74.105.127/1b19a75cf7/?page=admin](http://34.74.105.127/1b19a75cf7/?page=admin)
    1. Notice: Undefined variable: title in /app/index.php on line 30

        Warning: include(admin.php): failed to open stream: No such file or directory in /app/index.php on line 21

        Warning: include(): Failed opening 'admin.php' for inclusion (include_path='.:/usr/share/php:/usr/share/pear') in /app/index.php on line 21