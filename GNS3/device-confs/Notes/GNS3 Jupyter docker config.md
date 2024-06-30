# Jupyter node pre-ready requarest

## First network connection for pip connection out network

![network an internet connection](./static-files/network%20an%20internet%20connection%20jupyter%20docker%20node.png)

Network Config files:
![network config area](./static-files/network%20conf%20gns3%20for%20jupyter.png)

```shell
#
# This is a jupyter network connection example
#

# Uncomment this line to load custom interface files
# source /etc/network/interfaces.d/*

# Static config for eth0 (SW1 Static IP address)
auto eth0
iface eth0 inet static
	address 192.168.0.3
	netmask 255.255.255.0
	gateway 192.168.0.1
#	up echo nameserver 192.168.0.1 > /etc/resolv.conf

# DHCP config for Internet conn (Cloud)
auto eth1
iface eth1 inet dhcp
	hostname Jupyter-1
```

IP route problems:

```shell
ip route list
  default via 192.168.0.1 dev eth0 # Not have internet
  default via 192.168.88.1 dev eth1  metric 207
  192.168.0.0/24 dev eth0 scope link  src 192.168.0.3
  192.168.88.0/24 dev eth1 scope link  src 192.168.88.22
```

IP route for internet:

```shell
ip route del via 192.168.0.1 dev eth0
ip route del 192.168.0.0/24 dev eth0 scope link  src 192.168.0.3
ip route add 192.168.0.0/24 dev eth0 scope link  src 192.168.0.3
```
