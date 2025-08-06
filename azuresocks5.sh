#!/bin/bash

# Update and install required packages
apt update && apt install -y build-essential git wget curl net-tools

# Clone and build 3proxy
cd /opt
rm -rf 3proxy
git clone https://github.com/z3APA3A/3proxy.git
cd 3proxy
make -f Makefile.Linux
mkdir -p /usr/local/3proxy/bin /usr/local/3proxy/logs
cp src/3proxy /usr/local/3proxy/bin/

# Create user and password
USERNAME="adminuser"
PASSWORD="Khonglolo123@@"
echo "$USERNAME:CL:$PASSWORD" > /usr/local/3proxy/bin/passwd

# Create config file
cat <<EOF > /usr/local/3proxy/bin/3proxy.cfg
daemon
maxconn 1000
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
users $USERNAME:CL:$PASSWORD
auth strong
EOF

# Detect all public IPs assigned to the system, skip main one
IPS=$(ip -o addr show scope global | grep -v ' lo ' | grep inet | awk '{print $4}' | cut -d/ -f1)
PORT=1080

for IP in $IPS; do
    echo "socks -p$PORT -i$IP -e$IP" >> /usr/local/3proxy/bin/3proxy.cfg
    PORT=$((PORT+1))
done

# Create systemd service
cat <<EOF > /etc/systemd/system/3proxy.service
[Unit]
Description=3Proxy Proxy Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/3proxy/bin/3proxy /usr/local/3proxy/bin/3proxy.cfg
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start 3proxy
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable 3proxy
systemctl start 3proxy

# Done
echo "3proxy installed and running. Proxies start from port 1080."
