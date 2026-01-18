sudo dnf install pip
python3 -m pip install --upgrade pip
python3 -m pip install paramiko ansible-pylibssh
  
cat > enpoint-interface-set.yaml 
ansible-galaxy collection install cisco.ios
ansible-playbook -i hosts.ini enpoint-interface-set.yaml 