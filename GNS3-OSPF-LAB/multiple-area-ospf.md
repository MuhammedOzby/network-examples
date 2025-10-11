# Çok Alanlı (Multi-Area) OSPF Yapılandırması

Bu doküman, `multiple-area-ospf.ios` dosyasında yer alan ve OSPF'in birden çok alana bölündüğü bir ağ yapılandırmasını açıklar. Bu topoloji, bir omurga alanı (Area 0) ve bu omurgaya bağlı dört farklı alanı (IT, SALES, MGMT, DC) içerir.

## Topoloji ve Alan Yapısı

Yapılandırma, bir merkez (CORE-RTR) yönlendiricinin omurga alanını (Area 0) oluşturduğu ve diğer alanların bu merkeze "Area Border Router" (ABR) adı verilen sınır yönlendiricileri üzerinden bağlandığı bir yıldız topolojisine dayanır.

*   **Area 0 (Backbone Area):** Ağın merkezidir. Tüm diğer alanlar bu alana bağlanmak zorundadır. `CORE-RTR` bu alanın merkezindedir.
*   **Area 1 (IT Area):** IT departmanının ağını içerir. `IT-RTR` bu alan ile Area 0 arasında ABR olarak görev yapar.
*   **Area 2 (SALES Area):** Satış departmanının ağını içerir. `SALES-RTR1` bu alan ile Area 0 arasında ABR'dır.
*   **Area 3 (MANAGEMENT Area):** Yönetim ağını içerir. `MGMT-RTR` bu alan ile Area 0 arasında ABR'dır.
*   **Area 4 (DC Area):** Veri merkezi ağını içerir. `DC1-RTR` bu alan ile Area 0 arasında ABR'dır.

```mermaid
graph TD
    subgraph Area 0 (Backbone)
        direction LR
        CORE_RTR[CORE-RTR]
        ABR1(IT-RTR)
        ABR2(SALES-RTR1)
        ABR3(MGMT-RTR)
        ABR4(DC1-RTR)

        CORE_RTR --- ABR1
        CORE_RTR --- ABR2
        CORE_RTR --- ABR3
        CORE_RTR --- ABR4
    end

    subgraph Area 1 (IT)
        ABR1 --- IT_Clients[fa:fa-desktop IT Clients]
    end

    subgraph Area 2 (SALES)
        ABR2 --- SALES_RTR2[SALES-RTR2] --- SALES_Clients[fa:fa-users Sales Clients]
    end

    subgraph Area 3 (MANAGEMENT)
        ABR3 --- MGMT_Clients[fa:fa-user-tie Management]
    end

    subgraph Area 4 (DC)
        ABR4 --- DC2_RTR[DC2-RTR] --- DC3_RTR[DC3-RTR] --- Servers[fa:fa-server Servers]
    end
```

---

## Yönlendirici (Router) Yapılandırmaları

### Omurga Yönlendiricisi (Backbone Router)

#### CORE-RTR

Tüm ABR'lerin bağlandığı merkez yönlendiricidir ve sadece Area 0 içindedir.

```ios
configure terminal
    interface Eth0/0
        ip address 10.0.0.0 255.255.255.254
    interface Eth0/1
        ip address 10.0.0.2 255.255.255.254
    interface Eth0/2
        ip address 10.0.0.4 255.255.255.254
    interface Eth0/3
        ip address 10.0.0.6 255.255.255.254
    ! Tüm arayüzler Area 0'da çalışacak şekilde ayarlanır.
    router ospf 1
        network 10.0.0.0 0.0.0.15 area 0
```

### Sınır Yönlendiricileri (Area Border Routers - ABRs)

Bu yönlendiriciler hem Area 0'a hem de kendi yerel alanlarına bağlıdır.

#### DC1-RTR (Area 0 ve Area 4)

```ios
configure terminal
    interface Eth0/0 ! Area 0'a bakan arayüz
        ip address 10.0.0.1 255.255.255.254
    interface Eth0/1 ! Area 4'e bakan arayüz
        ip address 10.0.0.16 255.255.255.254
    router ospf 1
        network 10.0.0.0 0.0.0.15 area 0   ! Backbone bağlantısı
        network 10.0.0.16 0.0.0.15 area 4 ! DC alanı içi yönlendirici bağlantıları
        network 172.16.1.0 0.0.15.255 area 4 ! DC sunucu alt ağları
```

#### SALES-RTR1 (Area 0 ve Area 2)

```ios
configure terminal
    interface Eth0/0 ! Area 0'a bakan arayüz
        ip address 10.0.0.3 255.255.255.254
    interface Eth0/1 ! Area 2'ye bakan arayüz
        ip address 10.0.0.32 255.255.255.254
    router ospf 1
        network 10.0.0.0 0.0.0.15 area 0   ! Backbone bağlantısı
        network 10.0.0.32 0.0.0.15 area 2 ! Satış alanı içi yönlendirici bağlantıları
        network 192.168.2.0 0.0.1.255 area 2 ! Satış departmanı istemci alt ağları
```

#### IT-RTR (Area 0 ve Area 1)

**Not:** Bu yapılandırmada `Eth0/0` arayüzü için `/28` maskesi (`255.255.255.240`) kullanılmıştır. Noktadan noktaya bağlantı olduğu için `/31` (`255.255.255.254`) kullanılması daha verimli olurdu.

```ios
configure terminal
    interface Eth0/0 ! Area 0'a bakan arayüz
        ip address 10.0.0.5 255.255.255.240
    router ospf 1
        network 10.0.0.0 0.0.0.15 area 0   ! Backbone bağlantısı
        network 192.168.3.0 0.0.0.255 area 1 ! IT departmanı istemci alt ağı
```

#### MGMT-RTR (Area 0 ve Area 3)

```ios
configure terminal
    interface Eth0/0 ! Area 0'a bakan arayüz
        ip address 10.0.0.7 255.255.255.240
    router ospf 1
        network 10.0.0.0 0.0.0.15 area 0   ! Backbone bağlantısı
        network 192.168.4.0 0.0.0.255 area 3 ! Yönetim istemci alt ağı
```

### Alan İçi Yönlendiriciler (Internal Routers)

Bu yönlendiriciler sadece kendi alanları içinde çalışır ve Area 0'a doğrudan bağlı değildir.

#### SALES-RTR2 (Sadece Area 2)

```ios
configure terminal
    interface Eth0/0
        ip address 10.0.0.33 255.255.255.254
    router ospf 1
        network 10.0.0.32 0.0.0.15 area 2 ! SALES alanı içi yönlendirici bağlantıları
        network 192.168.2.0 0.0.1.255 area 2 ! Satış departmanı istemci alt ağları
```

#### DC2-RTR ve DC3-RTR (Sadece Area 4)

Bu yönlendiriciler de veri merkezi alanı içindedir ve sadece Area 4'e ait ağları OSPF ile duyurur.

```ios
! DC2-RTR
router ospf 1
    network 10.0.0.16 0.0.0.15 area 4
    network 172.16.1.0 0.0.15.255 area 4

! DC3-RTR
router ospf 1
    network 10.0.0.16 0.0.0.15 area 4
    network 172.16.1.0 0.0.15.255 area 4
```
