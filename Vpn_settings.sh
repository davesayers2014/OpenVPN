#!/bin/sh

wget "https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/resolv.conf" -O /etc/resolv.conf

sysctl -w net.ipv6.conf.all.disable_ipv6=1

sysctl -w net.ipv6.conf.default.disable_ipv6=1
