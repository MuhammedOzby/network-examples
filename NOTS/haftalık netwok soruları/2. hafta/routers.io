! R1
en
conf t
hostname R1
inter Eth0/0
  no shut
  ip address 10.10.10.1 255.255.255.0
  end
wr
! R2
en
conf t
hostname R2
inter Eth0/0
  no shut
  ip address 10.10.10.2 255.255.255.0
  end
wr
! R3
en
conf t
hostname R3
inter Eth0/0
  no shut
  ip address 10.10.10.3 255.255.255.0
  end
wr
! R4
en
conf t
hostname R4
inter Eth0/0
  no shut
  ip address 10.10.10.4 255.255.255.0
  end
wr
! R5
en
conf t
hostname R5
inter Eth0/0
  no shut
  ip address 10.10.10.5 255.255.255.0
  end
wr