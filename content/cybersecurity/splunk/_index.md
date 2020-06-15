---
title: splunk
---

### Search notes

- != and NOT can be different
- Should add index=main to all searches?

### table - module 8

```
index=main host="web_application" action=purchase status=200 file="success.do"
| table JSESSIONID
| dedup JSESSIONID
| rename JSESSIONID as UserSessions
| sort UserSessions limit=20
```

### top, rare, stats, sort - module 9

```
sourcetype="access_combined_wcookie" action=purchase file=success.do
| top productId limit=5 showperc=f
# WC-SHG04

sourcetype="access_combined_wcookie" status=200
| rare file by date_month

sourcetype="access_combined_wcookie" AND (file=cart.do OR file=success.do)
| stats count as Transactions by file
| rename file as Function

sourcetype="access_combined_wcookie"
| stats dc(JSESSIONID) as Logins by clientip
| sort -Logins
# 87.194.216.51

status=200
| stats sum(bytes) as TotalBytes by file
| sort file
# api

sourcetype="db_audit"
| stats avg(Duration) as "time to complete" by Command
| sort -"time to complete" 

index=main sourcetype=access_combined_wcookie
| stats values(useragent) as "Agents used" count as "Times used" by useragent
| table "Agents used", "Times used"
```

### module 10

```
sourcetype="access_combined_wcookie" status=403
| stats count as attempts by clientip
| sort -attempts
# 73.202.92.7

sourcetype="access_combined_wcookie" action=purchase file=success.do status=200
| stats count by productId
```

### module 12

```
| inputlookup products_lookup

index=main sourcetype="access_combined_wcookie" status=200 file=success.do
| lookup products_lookup productId as productId OUTPUT product_name as ProductName
| stats count by ProductName

index=main sourcetype="access_combined_wcookie" status=200 file=success.do
| stats sum(Price) as Revenue by ProductName
| sort -Revenue
# Dream Crusher
```

### useful search

```
index=_audit action="login attempt" info=failed user=admin #module 13
```

### size

```
# per host:

index="_internal" source="*metrics.log" group="per_host_thruput" | chart sum(kb) by series | sort - sum(kb)

# per source:

index="_internal" source="*metrics.log" group="per_source_thruput" | chart sum(kb) by series | sort - sum(kb)

# per sourcetype:

index="_internal" source="*metrics.log" group="per_sourcetype_thruput" | chart sum(kb) by series | sort - sum(kb)
```

### delete

```bash
splunk stop
splunk clean eventdata -index <index>
splunk start
```