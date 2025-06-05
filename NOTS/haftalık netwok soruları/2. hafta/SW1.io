hostname SW1
! 1. Ana (Primary) VLAN oluştur
vlan 100
  private-vlan primary
  name PVLAN_PRIMARY
  exit

! 2. İkincil (Secondary) İzole VLAN oluştur (R1 ve R2 için)
vlan 101
  private-vlan isolated
  name PVLAN_ISOLATED_R1R2
  exit

! 3. İkincil (Secondary) Ortak VLAN oluştur (R3 ve R4 için)
vlan 102
  private-vlan community
  name PVLAN_COMMUNITY_R3R4
  exit

! 4. İkincil VLAN'ları Ana VLAN ile ilişkilendir
vlan 100
  private-vlan association 101,102
  exit

! 5. R1 ve R2'nin bağlı olduğu portları İzole olarak ayarla
interface Eth0/0
  desc R1
  switchport mode private-vlan host
  switchport private-vlan host-association 100 101
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

interface Eth0/1
  desc R2
  switchport mode private-vlan host
  switchport private-vlan host-association 100 101
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

! 6. R3 ve R4'ün bağlı olduğu portları Ortak olarak ayarla
interface Eth0/2
  desc R3
  switchport mode private-vlan host
  switchport private-vlan host-association 100 102
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

interface Eth0/3
  desc R4
  switchport mode private-vlan host
  switchport private-vlan host-association 100 102
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

! 7. R5 (Gateway)'in bağlı olduğu portu Karma (Promiscuous) olarak ayarla
interface Eth1/0
  desc R5
  switchport mode private-vlan promiscuous
  switchport private-vlan mapping 100 101,102
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

end

! Yapılandırmayı kaydet
write memory