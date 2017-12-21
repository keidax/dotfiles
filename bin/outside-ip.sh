#!/bin/sh

# Use OpenDNS service to resolve public IP
public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
printf "%s" "$public_ip"

unset public_ip
