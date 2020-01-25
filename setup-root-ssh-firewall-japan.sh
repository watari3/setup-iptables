#!/bin/sh

### ホワイトリスト作成
ipset destroy white_list_japan
ipset create white_list_japan hash:net
cp -p jp.txt jp.txt.bkup
curl https://ipv4.fetus.jp/jp.txt > jp.txt
curl https://ipv4.fetus.jp/jp.txt | grep -v '^#' | xargs -I@ -P 0  ipset add white_list_japan @
ipset add white_list_japan 192.168.0.0/16
ipset add white_list_japan 10.0.0.0/8
ipset add white_list_japan 172.16.0.0/12
ipset list white_list_japan
ipset save white_list_japan > white_list_japan.txt
iptables -I INPUT -m state --state NEW -p tcp --dport 22 -m set --match-set white_list_japan src -j ACCEPT
###
cat << EOF > /etc/ipset.conf
ipset destroy white_list_japan
EOF
###
ipset save >> /etc/ipset.conf
iptables-save > /etc/iptables.up.rules
### ファイル作成
cat <<EOF > /etc/network/if-pre-up.d/iptables-with-ipset
#!/bin/sh
### 
### /etc/network/if-pre-up.d/iptables-with-ipset
### 

### read data from file list
ipset restore < /etc/ipset.conf
### 
iptables-restore < /etc/iptables.up.rules
EOF
### 実行属性追加
chmod ug+x /etc/network/if-pre-up.d/iptables-with-ipset
