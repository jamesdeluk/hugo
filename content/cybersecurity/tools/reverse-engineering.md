---
title: 'Reverse Engineering'
---

- [Radare2](#radare2)
- [Ghidra](#ghidra)

## Radare2

```bash
$ r2 -d <file>

[0x00400a30]> aaa

[0x00400a30]> afl

[0x00400a30]> pdf @main

[0x00400a30]> db 0x00400b6b
```

## Ghidra