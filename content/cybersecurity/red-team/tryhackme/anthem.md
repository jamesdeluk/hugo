---
title: 'Anthem'
---

	- [flags](#flags)
	- [final stage](#final-stage)

# Tools & Commands

- nmap
- Google
- View source
- Remmina

```php
$ nmap
[...]
80/tcp   open  http
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
3389/tcp open  ms-wbt-server
```

[http://10.10.244.242/robots.txt](http://10.10.244.242/robots.txt)

UmbracoIsTheBest!

# Use for all search robots
User-agent: *

# Define the directories not to crawl
Disallow: /bin/
Disallow: /config/
Disallow: /umbraco/
Disallow: /umbraco_client/

[http://10.10.244.242/archive/a-cheers-to-our-it-department/](http://10.10.244.242/archive/a-cheers-to-our-it-department/)

→ what's the poem?

[http://10.10.244.242/archive/we-are-hiring/](http://10.10.244.242/archive/we-are-hiring/)

→ what's the email format?

### flags

1. view source (single page)
2. view source (of most pages)
3. /authors/jane-doe/
4. view source (single page)

### final stage

1. use Remmina for RDP: sg:UmbracoIsTheBest!
2. user.txt → flag
3. show hidden files, C:\backup\restore, edit permissions → flag
4. root.txt → flag