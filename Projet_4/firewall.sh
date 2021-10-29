#!bin/sh
# Reset Iptables règles
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
# Bloquer toute les connexions entrantes, sortantes, redirections
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# Autoriser connexions établies
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Autoriser SSH Depuis Reseau Interne
iptables -A INPUT -p tcp -i enp0s3 --dport 22 -j ACCEPT
# Autorisation DNS Depuis Reseau Interne
iptables -A FORWARD -p tcp -s 192.168.1.1 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -s 192.168.1.1 --dport 53 -j ACCEPT
# Ajout MASQUERADE
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
# Autorisation accès Internet depuis Proxy
iptables -A FORWARD -s 192.168.1.1 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.1.1 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.1.1 --dport 443 -j ACCEPT
# Autorisation ping entrant, sortant, mais non traversant pour plus de sécurité
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
#iptables -A FORWARD -p icmp -j ACCEPT
# Autorisation accès DMZ depuis réseau interne
iptables -A FORWARD -s 192.168.1.0/25 -d 192.168.1.232/29 -j ACCEPT
iptables -A FORWARD -s 192.168.1.128/26 -d 192.168.1.232/29 -j ACCEPT
iptables -A FORWARD -s 192.168.1.192/28 -d 192.168.1.232/29 -j ACCEPT
iptables -A FORWARD -s 192.168.1.208/29 -d 192.168.1.232/29 -j ACCEPT
iptables -A FORWARD -s 192.168.1.224/29 -d 192.168.1.232/29 -j ACCEPT
# Autoriser le serveur proxy aller sur internet
iptables -A FORWARD -s 192.168.1.1 -j ACCEPT
