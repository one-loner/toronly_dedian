#!/bin/bash
apt-get install tor privoxy proxychains nmap
mv /etc/privoxy/config /etc/privoxy/config.backup
cp config /etc/privoxy/config
systemctl restart privoxy


