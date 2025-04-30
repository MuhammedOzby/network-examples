# VLAN40
ip link set eth0 up
ip link set eth0 promisc on
ip link set eth0 mtu 1500
ip addr flush dev eth0
ip addr add 192.168.40.2/24 dev eth0
ip route add default via 192.168.40.1 dev eth0
ping 192.168.40.1
# VLAN30
ip link set eth0 up
ip link set eth0 promisc on
ip link set eth0 mtu 1500
ip addr flush dev eth0
ip addr add 192.168.30.2/24 dev eth0
ip route add default via 192.168.30.1 dev eth0
ping 192.168.30.1
# VLAN10
ip link set eth0 up
ip link set eth0 promisc on
ip link set eth0 mtu 1500
ip addr flush dev eth0
ip addr add 192.168.10.2/24 dev eth0
ip route add default via 192.168.10.1 dev eth0
ping 192.168.10.1