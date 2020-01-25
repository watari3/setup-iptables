#!/bin/sh

### ホワイトリスト作成
sudo ipset destroy white_list_japan
sudo ipset create white_list_japan hash:net
curl https://ipv4.fetus.jp/jp.txt | grep -v '^#' | xargs -I@ -P 0 sudo ipset add white_list_japan @
sudo ipset add white_list_japan 192.168.0.0/16
sudo ipset add white_list_japan 10.0.0.0/8
sudo ipset add white_list_japan 172.16.0.0/12
sudo ipset list white_list_japan
sudo ipset save white_list_japan > white_list_japan.txt
sudo iptables -I INPUT -m state --state NEW -p tcp --dport 22 -m set --match-set white_list_japan src -j ACCEPT
sudo sh -c 'ipset save > /etc/ipset.conf'
### ファイル作成
sudo cat <<EOF > /etc/network/if-pre-up.d/iptables-with-ipset
#!/bin/sh
### 
### /etc/network/if-pre-up.d/iptables-with-ipset
### 

### read data from file list
ipset restore < /etc/ipset.conf
### 
iptables-restore < /etc/iptales.up.rules" >> /etc/network/if-pre-up.d/iptables-with-ipset
EOF
### 実行属性追加
sudo chmod ug+x /etc/network/if-pre-up.d/iptables-with-ipset
