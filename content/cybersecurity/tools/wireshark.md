---
title: 'Wireshark'
---

- [capture filter](#capture-filter)
- [filter](#filter)

## capture filter

```
dst 192.168.1.8 and port 443
src 192.168.1.1 and not port 80
host wireshark.org
```

## filter

```
# ips
ip.addr == 192.168.1.1
ip.src == 192.168.1.1 and ip.dst == 192.168.1.8

# ports
tcp.port == 443
tcp.srcport == 443

# protocols
http
http.requests.get == 'post'
tcp
tcp.flags.syn==1 # handshakes
arp
dns
ssh

# not, these are different
!ip.addr == 192.168.1.1
ip.addr != 192.168.1.1

# frame
frame contains “(attachment|tar|exe|zip|pdf)”

# keywords
tcp contains facebook
frame contains facebook

# syn floods
tcp.flags.syn == 1 and tcp.flags.ack == 0
```