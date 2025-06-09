package lib

import (
	"log"

	"github.com/gosnmp/gosnmp"
)

func SNMPConTest(params gosnmp.GoSNMP) {
	err := params.Connect()
	if err != nil {
		log.Fatalf("Connect() err: %v", err)
	}
	defer params.Conn.Close()
}
