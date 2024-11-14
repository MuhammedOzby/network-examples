ip link set ens4 up
ip link set ens4 promisc on
ip link set ens4 mtu 1500
ip addr flush dev ens4
ip addr add 192.168.10.2/24 dev ens4
ip route add default via 192.168.10.1 dev ens4