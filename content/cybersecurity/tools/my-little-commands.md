---
title: My little commands
---


```bash
# find available domain names
nslookup < urls.txt | grep "server can't find" | cut -d " " -f5
```