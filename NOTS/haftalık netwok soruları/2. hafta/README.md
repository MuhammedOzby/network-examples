# 2. hafta network sorusu

![soru resmi](attachments/image1.jpeg)

1. Tüm router'lara aynı blok IP verilecek , ve hepsi birbirine ping atabiliyor olduktan sonra ; Aşağıdaki işlemler uygulanacak.

2. R1 ve R2 aynı vlan'da olsun , fakat birbirleri ile haberleşemesin. R1 ve R2 R3,R4 ile de haberleşemesin ( ACL Olmadan Yapılacak )

3. R1 ve R2 R5 ile haberleşsin ( Çünkü R5 beni internete çıkaracak bir gateway olsun ) ( ACL Olmadan Yapılacak )

4. R3 ve R4 aynı vlanda olsun , birbileri ile haberleşsin , çünkü yedekli dns olsun bunlar , ama R1 ve R2 ile haberleşemesin. ( ACL Olmadan Yapılacak )

5. R3 ve R4 R5 ile haberleşsin ( Çünkü R5 beni internete çıkaracak bir gateway olsun ) ( ACL Olmadan Yapılacak )

6. Sadece R5 kaldı , anlaşılacağı üzere R5 Gateway olduğu için herkes ile haberleşsin.

> Haberleşsin = Ping Atabilsin
> Haberleşmesin = Ping Atamasın

---

Bonus Sorusu 1 ;
BPDU Filter'ı interface içine yazmak ile , global modda yazmak arasındaki fark nedir ? :) :)

---

Bonus Sorusu 2 ;

Switch üzerinde Vl 1006 oluşturulacak , isim verilecek. Sh vl çıktısında vl 1006 görülecek.
no vl 1006 yazılıp vl silinecek. sh vl çıktısında vl 1006 nın olmadığı görülecek.

Switch üzerinde herhangi bir porta no switchport yazılacak, port up duruma gelecek.
vl 1006 oluşturulacak.

Günün sonunda görmek istediğimiz tablo şu olacak ;
Herhangi bir interface no switchport durumdayken
vl 1006 oluşturulması.

---

Çözüm ;

1. Arp çıktısı R5 üzerinden (diğerleride aynı durumdadır. GW olduğu için sadece bunun çıktıyı ekledim.):

> Tüm cihazlara birbirlerine ping atmak yerine cihazda sadece `ping 10.10.10.255 repeat 1` ile yapılan broadcast ile hepsi alındı.

```
R5#show arp
Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  10.10.10.1              0   c001.1e9a.0000  ARPA   FastEthernet0/0
Internet  10.10.10.2              0   c002.1eec.0000  ARPA   FastEthernet0/0
Internet  10.10.10.3              0   c003.1f0a.0000  ARPA   FastEthernet0/0
Internet  10.10.10.4              0   c004.1f28.0000  ARPA   FastEthernet0/0
Internet  10.10.10.5              -   c005.1f4a.0000  ARPA   FastEthernet0/0
```

Router ayarları:

```
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
```

Switch ayarları

Vlanların oluşması:

```
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
```

NIC ayarları:

```
! 5. R1 ve R2'nin bağlı olduğu portları İzole olarak ayarla
interface Fa0/1
  desc R1
  switchport mode private-vlan host
  switchport private-vlan host-association 100 101
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

interface Fa0/2
  desc R2
  switchport mode private-vlan host
  switchport private-vlan host-association 100 101
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

! 6. R3 ve R4'ün bağlı olduğu portları Ortak olarak ayarla
interface Fa0/3
  desc R3
  switchport mode private-vlan host
  switchport private-vlan host-association 100 102
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

interface Fa0/4
  desc R4
  switchport mode private-vlan host
  switchport private-vlan host-association 100 102
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit

! 7. R5 (Gateway)'in bağlı olduğu portu Karma (Promiscuous) olarak ayarla
interface Fa0/5
  desc R5
  switchport mode private-vlan promiscuous
  switchport private-vlan mapping 100 101,102
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
  exit
```

![alt text](./attachments/cikti.png)

---

Bonus Sorusu 1;
Global modda kullanıldığında port-fast olan arayüzlerde etkinleşir. Daha az kontrol imkanı verirken port fast ayarına ihtiyaç duyar.

Bonus Sorusu 2;

