#!/bin/bash

# Define the DNS providers
declare -A dns_providers=(
  ["ISP Default DNS"]="192.168.1.1"
  ["Shecan"]="178.22.122.100 185.51.200.2"
  ["403.online"]="10.202.10.202 10.202.10.102"
  ["radar.game"]="10.202.10.10 10.202.10.11"
  ["Electrotm"]="78.157.42.101 78.157.42.100"
  ["Begzar"]="185.55.226.26 185.55.225.25"
  ["Google DNS"]="8.8.8.8 8.8.4.4"
  ["CleanBrowsing"]="185.228.168.9 185.228.169.9"
  ["Alternate DNS"]="76.76.19.19 76.223.122.150"
  ["AdGuard DNS"]="94.140.14.14 94.140.15.15"
  ["Comodo DNS"]="8.26.56.26 8.20.247.20"
  ["Quad9 DNS"]="9.9.9.9 149.112.112.112"
  ["OpenDNS"]="208.67.222.222 208.67.220.220"
  ["Cloudflare DNS"]="1.1.1.1 1.0.0.1"
  ["Cloudflare DNS (Block Malware)"]="1.1.1.2 1.0.0.2"
  ["Cloudflare DNS (Block Malware & Adult Content)"]="1.1.1.3 1.0.0.3"
)

# Find current DNS provider
current_dns_ips=$(resolvectl status | grep wlp4s0 --after-context=4 | grep DNS\ Servers | awk '{print $3,$4}' | xargs)

for current_dns_provider in "${!dns_providers[@]}"; do
   if [[ ${dns_providers[$current_dns_provider]} == $current_dns_ips ]]; then
	current_dns_name=$current_dns_provider
	break
   fi
done
echo "Current DNS: $current_dns_name ($current_dns_ips)"
echo "-------------------------------------------------"

# Display the select menu
echo "Select a DNS provider:"
select provider in "${!dns_providers[@]}"; do
  if [ -n "$provider" ]; then
    dns_ips=${dns_providers[$provider]}
    break
  else
    echo "Invalid selection. Please try again."
  fi
done
echo "-------------------------------------------------"

# Update DNS settings using resolvectl
echo "Updating DNS to $provider..."
sudo resolvectl dns wlp4s0 $dns_ips
echo "DNS updated successfully."

# Flush the DNS cache
sudo resolvectl flush-caches

# Display DNS Servers
echo $(resolvectl status | grep wlp4s0 --after-context=4 | grep DNS\ Servers)

