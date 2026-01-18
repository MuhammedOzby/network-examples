# Ansible Device - eth0
nmcli connection modify eth0 ipv4.addresses 192.168.156.100/28
nmcli connection modify eth0 ipv4.gateway 192.168.156.1
nmcli connection modify eth0 ipv4.dns "8.8.8.8, 1.1.1.1"
nmcli connection modify eth0 ipv4.method manual
nmcli connection modify eth0 ipv4.route-metric 100
nmcli connection up eth0
# Ansible Device - eth1 - alias: Wired connection 1
nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.156.200/28
nmcli connection modify "Wired connection 1" ipv4.gateway 192.168.156.129
nmcli connection modify "Wired connection 1" ipv4.dns "8.8.8.8, 1.1.1.1"
nmcli connection modify "Wired connection 1" ipv4.method manual
nmcli connection modify "Wired connection 1" ipv4.route-metric 200
nmcli connection up "Wired connection 1"

