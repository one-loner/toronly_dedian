#!/bin/sh

### set variables

#destinations you don't want routed through Tor

_non_tor="192.168.1.0/24 192.168.0.0/16"

#the UID that Tor runs as (varies from system to system)

_tor_uid="135" # XYZ меняем на UID пользователя TOR (!)

### flush iptables

iptables -F

iptables -t nat -F

### set iptables *nat

iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN

iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53

#allow clearnet access for hosts in $_non_tor

for _clearnet in $_non_tor 127.0.0.0/9 127.128.0.0/10; do

iptables -t nat -A OUTPUT -d $_clearnet -j RETURN

done


### set iptables *filter

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#allow clearnet access for hosts in $_non_tor

for _clearnet in $_non_tor 127.0.0.0/8; do

iptables -A OUTPUT -d $_clearnet -j ACCEPT

done

#allow only Tor output

iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT

iptables -A OUTPUT -j REJECT

#Deny ipv6
ip6tables -P OUTPUT DROP
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP


apt-get install iptables-persistent
