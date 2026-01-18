# Alt routerın nat üzerinden çıkışına izin vermek için.
# Bu sayede NAT üzerinden cihazların internet çıkışı olur.
# Masquerade (NAT) özelliğinin açık olduğundan emin ol
sudo firewall-cmd --zone=public --add-masquerade --permanent

# virbr0'dan gelen trafiğe izin ver (Forwarding)
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i virbr0 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Ayarları uygula
sudo firewall-cmd --reload