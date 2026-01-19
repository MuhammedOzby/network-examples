# Ansible ile Network Otomasyonuna Giriş: İlk Adımlar 🚀

Bu proje, network otomasyonu dünyasına adım atmak amacıyla hazırlanmış bir başlangıç çalışmasıdır. Geleneksel yöntemlerle (Day-0) yapılandırılmış bir ağ ortamının, Ansible kullanılarak nasıl daha dinamik ve yönetilebilir hale getirilebileceğini temel seviyede örneklemektedir.

## 🛠️ Proje Kapsamı ve Mimari
Proje, Cisco IOS tabanlı bir laboratuvar ortamında; yedekli bir ağ altyapısı kurmayı ve bu altyapı üzerindeki uç cihazların (endpoint) konfigürasyonunu otomatize etmeyi hedefler.

### Teknik Özellikler:
- **Day-0 Hazırlıkları:** Router ve Switch'ler üzerinde VRRP yedekliliği, VLAN segmentasyonu (Management, Production, Dev) ve NAT konfigürasyonları.
- **Envanter Yönetimi:** `hosts.ini` üzerinden merkezi cihaz yönetimi.
- **Otomasyon:** Ansible Playbook'ları ile VLAN atamaları ve port konfigürasyonları.
- **Doğrulama:** Otomatik komutlar (`ios_command`) ile yapılandırma kontrolü.

## 📁 Proje Yapısı
```text
.
├── Day-0 configs/          # Manuel uygulanan temel cihaz yapılandırmaları
├── playbooks/              # Ansible otomasyon dosyaları (YAML)
├── hosts.ini               # Cihaz envanteri ve bağlantı değişkenleri
├── ansible.cfg             # Ansible çalışma ayarları
└── command-ref.sh          # Kurulum ve çalıştırma için komut referansları

```

## 🚀 Başlangıç

### Gereksinimler

Projenin çalışması için sisteminizde aşağıdaki bileşenlerin yüklü olması gerekir:

* Python 3.x
* Ansible
* Cisco.IOS Collection

### Kurulum

Gerekli bağımlılıkları yüklemek için:

```bash
python3 -m pip install paramiko ansible-pylibssh
ansible-galaxy collection install cisco.ios

```

### Playbook'u Çalıştırma

Uç cihazların port yapılandırmasını başlatmak için aşağıdaki komutu kullanabilirsiniz:

```bash
ansible-playbook -i hosts.ini playbooks/endpoint-interface-set.yaml

```

## 📈 Öğrenme Notları

Bu proje, manuel konfigürasyonun karmaşıklığını ve otomasyonun sağladığı standartlaşmayı anlamak için geliştirilmiştir.

* **Endpoint Yapılandırması:** `ios_l2_interfaces` modülü ile port bazlı ayarların nasıl yönetildiği tecrübe edilmiştir.
* **Bağlantı Ayarları:** Eski nesil cihazlarla uyumluluk için özel SSH anahtarları ve algoritmaları (`ssh_config`) projeye dahil edilmiştir.

## ⚠️ Not

Bu bir eğitim/öğrenme projesidir. Gerçek (Production) ortamlar için ek güvenlik önlemleri (Ansible Vault vb.) alınması önerilir.

