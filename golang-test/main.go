package main

import (
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/gosnmp/gosnmp"
)

// Her bir interface'in tüm bilgilerini tutacak bir struct tanımlayalım
type InterfaceInfo struct {
	Index       string
	Description string
	OperStatus  string
	Mode        string // ACCESS, TRUNK, veya OTHER olabilir
	VlanID      int    // Sadece access modundaysa bir değeri olacak
}

func main_get_interface_status() {
	// --- AYARLAR ---
	targetIP := "10.10.0.50"
	community := "GUVENLI-COMMUNITY" // Burayı kendi community string'in ile değiştir!

	// Kullanacağımız OID'ler
	ifDescrOID := "1.3.6.1.2.1.2.2.1.2"               // Interface Adı
	ifOperStatusOID := "1.3.6.1.2.1.2.2.1.8"          // Interface Durumu (UP/DOWN)
	ciscoVlanID_OID := "1.3.6.1.4.1.9.9.68.1.2.2.1.2" // Access Port'un VLAN ID'si (Cisco'ya özel)
	// --- BİTTİ ---

	// SNMP bağlantı parametreleri
	params := &gosnmp.GoSNMP{
		Target:    targetIP,
		Port:      161,
		Community: community,
		Version:   gosnmp.Version2c,
		Timeout:   time.Duration(2) * time.Second,
	}

	// Bağlantıyı kur
	err := params.Connect()
	if err != nil {
		log.Fatalf("Connect() err: %v", err)
	}
	defer params.Conn.Close()

	// Tüm interface bilgilerini saklayacağımız map
	// Anahtar: interface index, Değer: InterfaceInfo struct'ı
	interfaces := make(map[string]*InterfaceInfo)

	fmt.Printf("Switch'ten (%s) detaylı interface bilgileri çekiliyor...\n\n", targetIP)

	// 1. ADIM: Temel bilgileri (İsim ve Durum) çek ve struct'ları oluştur
	err = params.Walk(ifDescrOID, func(pdu gosnmp.SnmpPDU) error {
		ifIndex := strings.TrimPrefix(pdu.Name, "."+ifDescrOID+".")
		interfaces[ifIndex] = &InterfaceInfo{
			Index:       ifIndex,
			Description: string(pdu.Value.([]byte)),
			Mode:        "OTHER", // Varsayılan olarak "OTHER" atayalım
		}
		return nil
	})
	if err != nil {
		log.Fatalf("Walk() err for descriptions: %v", err)
	}

	err = params.Walk(ifOperStatusOID, func(pdu gosnmp.SnmpPDU) error {
		ifIndex := strings.TrimPrefix(pdu.Name, "."+ifOperStatusOID+".")
		if info, ok := interfaces[ifIndex]; ok {
			status := pdu.Value.(int)
			if status == 1 {
				info.OperStatus = "UP"
			} else {
				info.OperStatus = "DOWN"
			}
		}
		return nil
	})

	// 2. ADIM: VLAN ID bilgilerini çek ve modu "ACCESS" olarak güncelle
	err = params.Walk(ciscoVlanID_OID, func(pdu gosnmp.SnmpPDU) error {
		ifIndex := strings.TrimPrefix(pdu.Name, "."+ciscoVlanID_OID+".")
		// Bu OID sadece access portlar için cevap döner.
		// Cevap alıyorsak, bu port access modundadır.
		if info, ok := interfaces[ifIndex]; ok {
			info.Mode = "ACCESS"
			info.VlanID = pdu.Value.(int)
		}
		return nil
	})
	if err != nil {
		log.Fatalf("Walk() err for VLAN IDs: %v", err)
	}

	// Not: Bu basit örnekte, VLAN ID'si olmayan portları "TRUNK" veya "OTHER" olarak kabul ediyoruz.
	// Daha kesin bir trunk tespiti için ek Cisco OID'leri (vlanTrunkPortTable gibi) sorgulanabilir.

	// 3. ADIM: Sonuçları ekrana yazdır
	fmt.Printf("%-20s | %-8s | %-8s | %s\n", "INTERFACE", "DURUM", "MOD", "VLAN ID")
	fmt.Println(strings.Repeat("-", 55))

	for _, info := range interfaces {
		vlanStr := ""
		if info.Mode == "ACCESS" {
			vlanStr = fmt.Sprintf("%d", info.VlanID)
		}
		fmt.Printf("%-20s | %-8s | %-8s | %s\n", info.Description, info.OperStatus, info.Mode, vlanStr)
	}
}

func main() {
	main_get_interface_status()
}
