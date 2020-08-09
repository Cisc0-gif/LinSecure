#! /bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

wait_func() {
read -p "PRESS ENTER TO CONTINUE" wait
}

printf "${BLUE}[*] Running LinSecure Baseline Template...\n"
printf "=================================================================================\n"
printf "${NC}    [1] Install necessary packages...\n"
printf "    [2] Run HTTPSecure (HTTPS configuration for Apache2)\n"
printf "    [3] Run SysIntegrity (Configure UFW, File, User, and Group Integrity, etc.)\n"
printf "    [4] Install & Configure ProtonVPN\n"
printf "    [5] Configure SSH Server\n"
printf "    [6] Generate SSH RSA Keys\n"
printf "    [7] Create SSH User: 'user1'\n"
printf "${BLUE}=================================================================================\n"

#0
printf "${BLUE}[*] Installing necessary packages...${NC}\n"
sudo apt-get install git apache2 openssl python3 python3-pip-y

#1
printf "${BLUE}[*] Running HTTPSecure...${NC}\n"
sudo git clone https://github.com/Cisc0-gif/HTTPSecure.git
cd HTTPSecure
sudo ./httpsecure.sh
cd ..

#2
printf "${BLUE}[*] Running SysIntegrity...${NC}\n"
sudo git clone https://github.com/Cisc0-gif/SysIntegrity.git
cd SysIntegrity
./main.sh
cd ..

#3
printf "${BLUE}[*] Installing ProtonVPN...${NC}\n"
sudo python3 -m pip install protonvpn-cli
sudo protonvpn init
sudo crontab -l | { cat; echo "@reboot sudo protonvpn c -f"; } | sudo crontab -
sudo protonvpn c -f

#7
printf "${BLUE}[*] Creating User 'sshlogin', don't leave password blank!${NC}\n"
sudo useradd sshlogin
printf "${GREEN}[+] User 'sshlogin' added!${NC}\n"

#4
sudo curl https://pastebin.com/raw/cpvnkCp4 > /etc/ssh/sshd_config
printf "${GREEN}[+] ListenAddress set to '127.0.0.1'${NC}\n"
printf "${GREEN}[+] Port set to '43594'!${NC}\n"
printf "${GREEN}[+] PasswordAuthentication Disabled!"
printf "${GREEN}[+] RootLogin Disabled!"
printf "${GREEN}[+] BlankPasswords Disabled!"
printf "${GREEN}[+] Login to sshlogin with the password you set..."
wait_func

#5
su sshlogin
ssh-keygen
printf "${GREEN}[+] SSH RSA Keys Generated!"
printf "${BLUE}[*] Copy key without .pub extension to remote systems and use to login with user name 'sshlogin' at port '43594'${NC}\n"
printf "${BLUE}[*] Ex: ssh -i fp/to/id_rsa sshlogin@IP/HOSTNAME -p 43595"
printf "${GREEN}[+] SSH Encryption & Authentication Setup Complete!"
wait_func

printf "${GREEN}[+] LinSecure Baseline Integrated!"
