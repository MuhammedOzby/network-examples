! R1
conf t
inter fa0/0
  no shut
  ip address 10.10.10.1 255.255.255.0
  end
wr
! R2
conf t
inter fa0/0
  no shut
  ip address 10.10.10.2 255.255.255.0
  end
wr
! R3
conf t
inter fa0/0
  no shut
  ip address 10.10.10.3 255.255.255.0
  end
wr
! R4
conf t
inter fa0/0
  no shut
  ip address 10.10.10.4 255.255.255.0
  end
wr
! R5
conf t
inter fa0/0
  no shut
  ip address 10.10.10.5 255.255.255.0
  end
wr