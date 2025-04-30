# 1. hafta network sorusu

![soru](<attachments/Pasted image 20250430071627.png>)

## Sorular

1. Böyle bir şeye ihtiyaç var mı ? Adamlar neden böyle bir şeye ihtiyaç duymuşlar.

2. Artısı nedir ?

3. Eksisi nedir ?

## Cevaplar

1. Böyle bir yapı STP protokolünün hem yedekli çalışması hem de yükün dağıtılması için gerekmektedir.

2. Artıları

a. SW1 ve SW2 üzerindeki STP protokolü VLAN içerisinde yedekli bir şekilde çalışacaktır.

b. STP paketleri VLAN içinde dengeli bir şekilde dağılacaktır.

c. Yapılan ölçeklendirme bizlere STP pakelterinin iletilmesinde yönetim kolaylığı sağlar.

3. Eksileri

a. Ölçekleme yönetimi artırmasına karşın. Artan karmaşıklık sebebiyle yönetmesi ve yapılandırılması zorlaşır.

b. STP üzerinde VLAN öncelikleri elle ayarlanmaktadır. Hata yapma potansiyeli artar.

c. Fiziksel katmandaki değişimlere uyum sağlaması zaman almaktadır.

## Bonus soru

**Diyelim ki bir switch'te access portlara portfast komutu giriyoruz. Bunu bütün portlara tek tek yazmasak da , global de bişey yazsak da bu iş olsa mesela.**

Bunun bir çözümü default tanım girmektir. `spanning-tree portfast edge default` ile cihaz geneli bir ayar yapılabilir. Bu komutu kullanırken dikkatli olunmalı. Kullanmadan önce dökümandan nasıl çalıştığı ve etkileri incelenmelidir.

## LAB çıktısı

![LAB](<attachments/Pasted image 20250430071521.png>)

```IOS
! R1 Router:
conf t
  hostname R1
  inter FastEthernet0/0
    no shut
  inter FastEthernet0/0.10
    encapsulation dot1Q 10
    ip address 192.168.10.1 255.255.255.0
    no shut
  inter FastEthernet0/0.20
    encapsulation dot1Q 20
    ip address 192.168.20.1 255.255.255.0
    no shut
  inter FastEthernet0/0.30
    encapsulation dot1Q 30
    ip address 192.168.30.1 255.255.255.0
    no shut
  inter FastEthernet0/0.40
    encapsulation dot1Q 40
    ip address 192.168.40.1 255.255.255.0
    no shut
! SW1 Switch
enable
conf t
  hostname SW1
  spanning-tree mode rapid-pvst
  spanning-tree portfast edge default
  spanning-tree vlan 10,20 priority 4096
  spanning-tree vlan 30,40 priority 8192
  inter Gi3/0
    switchport trunk encapsulation dot1q
    switchport mode trunk
  inter Gi3/1
    switchport trunk encapsulation dot1q
    switchport mode trunk
  inter Gi3/3 ! router Bacağı
    switchport trunk encapsulation dot1q
    switchport mode trunk
  vlan 10
    name vlan10
  vlan 20
    name vlan20
  vlan 30
    name vlan30
  vlan 40
    name vlan40
  inter Gi0/0
    switchport mode access
    switchport access vlan 10
! SW2 Switch
enable
conf t
  hostname SW2
  spanning-tree mode rapid-pvst
  spanning-tree portfast edge default
  spanning-tree vlan 10,20 priority 8192
  spanning-tree vlan 30,40 priority 4096
  inter Gi3/0
    switchport trunk encapsulation dot1q
    switchport mode trunk
  inter Gi3/1
    spanning-tree guard loop
    switchport trunk encapsulation dot1q
    switchport mode trunk
  vlan 10
    name vlan10
  vlan 20
    name vlan20
  vlan 30
    name vlan30
  vlan 40
    name vlan40
  inter Gi0/0
    switchport mode access
    switchport access vlan 30
! SW3 Switch
enable
conf t
  hostname SW3
  spanning-tree mode rapid-pvst
  spanning-tree portfast edge default
  inter Gi3/0
    switchport trunk encapsulation dot1q
    switchport mode trunk
  inter Gi3/1
    switchport trunk encapsulation dot1q
    switchport mode trunk
  vlan 10
    name vlan10
  vlan 20
    name vlan20
  vlan 30
    name vlan30
  vlan 40
    name vlan40
  inter Gi0/0
    switchport mode access
    switchport access vlan 40
```
