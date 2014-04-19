#! /bin/sh
####################
####IPTABLES SCRIPT####
####################

# Clear all settings
iptables -F
iptables -F INPUT
iptables -t nat -F
iptables -t mangle -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

############
####Rules####
############

#Enable forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

#Enable NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

#Set INPUT policy to DROP
iptables -P INPUT DROP

#SSH Access
iptables -A INPUT -p tcp --dport 22 -i eth0 -j ACCEPT #SSH

#Accept icmp:
iptables -A INPUT -p icmp -j ACCEPT #Ping

#Accept web:
iptables -A INPUT -p tcp --dport 80 -i eth0 -j ACCEPT #WEB

#Deny deltager to access ssh on the server
iptables -A  INPUT -p tcp --dport 22 -i eth2 -j DROP


#Accept outgoing connections from LAN
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT

#Accept established connections, and those who doesnt originate from the outside
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state NEW ! -i eth0 -j ACCEPT #All NICs who isnt eth0
