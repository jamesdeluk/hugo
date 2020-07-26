---
title: 'Hack This Site!'
---

- [Realistic](#realistic)
	- [1](#1)
	- [2](#2)
	- [3](#3)
	- [4](#4)

## Realistic

[https://www.hackthissite.org/playlevel/](https://www.hackthissite.org/playlevel/1/)

### 1

- how does the voting submit the vote?
    - check source: v.php
- what is the php request?
    - check network settings: [https://www.hackthissite.org/missions/realistic/1/v.php?PHPSESSID=abcaeadfc31a5c43b2534bf995c0553f&id=3&vote=1](https://www.hackthissite.org/missions/realistic/1/v.php?PHPSESSID=abcaeadfc31a5c43b2534bf995c0553f&id=3&vote=1)
- can the value of the vote be changed?
    - [https://www.hackthissite.org/missions/realistic/1/v.php?PHPSESSID=abcaeadfc31a5c43b2534bf995c0553f&id=3&vote=1000](https://www.hackthissite.org/missions/realistic/1/v.php?PHPSESSID=abcaeadfc31a5c43b2534bf995c0553f&id=3&vote=1)
- success

### 2

- find links
- gif: [http://www.americannaziparty.com/support/gifs/wigger.gif](http://www.americannaziparty.com/support/gifs/wigger.gif)
- [http://www.americannaziparty.com/support/gifs/](http://www.americannaziparty.com/support/gifs/wigger.gif) → many images → oh shit it's real
- source: /missions/realistic/2/update.php → login page
- login action to update2.php → invalid
- sql injection ' or 1=1 -- → success

### 3

- no links
- source comment: oldindex.html is original
- pages:
    - [https://www.hackthissite.org/missions/realistic/3/readpoems.php](https://www.hackthissite.org/missions/realistic/3/readpoems.php)
    - [https://www.hackthissite.org/missions/realistic/3/readpoem.php](https://www.hackthissite.org/missions/realistic/3/readpoems.php)?name=
    - [https://www.hackthissite.org/missions/realistic/3/submitpoems.php](https://www.hackthissite.org/missions/realistic/3/submitpoems2.php)
    - [https://www.hackthissite.org/missions/realistic/3/submitpoems2.php](https://www.hackthissite.org/missions/realistic/3/submitpoems2.php) → doesn't add to list
- gobuster - nothing
- TO FINISH

### 4

- [https://www.hackthissite.org/missions/realistic/4/addemail.php](https://www.hackthissite.org/missions/realistic/4/addemail.php)
- [https://www.hackthissite.org/missions/realistic/4/products.php?category=1](https://www.hackthissite.org/missions/realistic/4/products.php?category=1)
- [test@test.com](mailto:test@test.com)' or 1=1 -- → error inserting into table email
- TO FINISH