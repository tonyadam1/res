sudo apt update -y
sudo apt install ufw -y
sudo ufw allow 22/tcp
sudo ufw --force enable
wget https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid3-install.sh -O squid3-install.sh
sudo bash squid3-install.sh
sudo /usr/bin/htpasswd -b -c /etc/squid/passwd admin Khonglolo123
sudo apt-get install apache2-utils -y
sudo apt install net-tools
sudo systemctl enable squid
wget https://raw.githubusercontent.com/tonyadam1/res/refs/heads/main/squid.conf -O ~/squid.conf
sudo cp ~/squid.conf /etc/squid/squid.conf
sudo systemctl restart squid
for p in $(seq 10000 10127); do sudo ufw allow ${p}/tcp; done
sudo ufw reload
sudo systemctl enable squid

# bật auto restart và auto start squid
sudo bash -c 'cat > /etc/systemd/system/squid.service <<EOF
[Unit]
Description=Squid Proxy Server
After=network.target

[Service]
ExecStart=/usr/sbin/squid -N
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable squid
sudo systemctl restart squid

# đảm bảo start lại khi reboot
(crontab -l 2>/dev/null; echo "@reboot /usr/bin/nohup /usr/sbin/squid -N > /root/squid.log 2>&1 &") | crontab -

nohup sudo squid -N > squid.log 2>&1 &




