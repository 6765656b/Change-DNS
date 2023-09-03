#!/bin/bash

# Define the DNS providers
declare -A dns_providers=(
  ["ISP Default DNS"]="192.168.1.1"
  ["Shecan"]="178.22.122.100 185.51.200.2"
  ["403.online"]="10.202.10.202 10.202.10.102"
  ["radar.game"]="10.202.10.10 10.202.10.11"
  ["Electrotm"]="78.157.42.101 78.157.42.100"
  ["Begzar"]="185.55.226.26 185.55.225.25"
  ["Quad9 DNS"]="9.9.9.9"
  ["OpenDNS"]="208.67.222.222 208.67.220.220"
  ["Cloudflare DNS"]="1.1.1.1 1.0.0.1"
  ["Google DNS"]="8.8.8.8 8.8.4.4"
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

