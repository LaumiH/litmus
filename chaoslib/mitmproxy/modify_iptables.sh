#!/bin/bash

set -x  #make executable
set -eo pipefail    

export POD_IP=$(hostname -i)    # get ip of target pod, must be obtained from somewhere else
export POD_NAME=$(hostname)     # get hostname of pod, must be obtained directly from target pod

# dns allow
[[ -n "${ALLOW_DNS}" ]] && iptables -w -t filter -A OUTPUT -p tcp -m tcp --dport 53 --destination ${ALLOW_DNS} -j ACCEPT    # is true when string is not empty, so if ALLOW_DNS is not empty
[[ -n "${ALLOW_DNS}" ]] && iptables -w -t filter -A OUTPUT -p udp -m udp --dport 53 --destination ${ALLOW_DNS} -j ACCEPT

# service network deny
[[ -n "${BLOCK_SVC_CIDR}" ]] && iptables -w -t filter -A OUTPUT --destination ${BLOCK_SVC_CIDR} -j REJECT

# pod egress deny
iptables -w -t filter -A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT      -w wait for xlock, -t only filter table, append OUTPUT, -p protocol, -m match, 
iptables -w -t filter -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -w -t filter -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -w -t filter -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT

if [[ -n "${NODE_NAME}" ]]; then
  HOST_IP=$(getent hosts ${NODE_NAME} | awk '{print $1}')
  [[ ! "${HOST_IP}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && echo "ERROR: Could not get IP from node name" && exit 1
  iptables -w -t filter -I OUTPUT -p tcp -m tcp --dport 1080 --destination ${HOST_IP} -j ACCEPT
fi

iptables -w -t filter -A OUTPUT -j REJECT

# kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}'
