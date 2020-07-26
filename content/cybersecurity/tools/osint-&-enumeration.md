---
title: 'OSINT & Enumeration'
---

- [OSR Framework](#osr-framework)
- [theHarvester](#theharvester)
- [Recon-ng](#recon-ng)
- [Maltego](#maltego)

## OSR Framework

```bash
domainfy --whois -n <search_term> # does <search_term>.*... exist and WHOIS
mailfy -n <email> # check all common mail providers for <search_term>@
phonefy -m <phone_number>
searchfy -q <search_term>
usufy -n <username>
```

## theHarvester

```bash
theHarvester -d <domain> -b <search_engine> -l <number_of_searches>

# find IPs, emails, hosts
```

## Recon-ng

## Maltego