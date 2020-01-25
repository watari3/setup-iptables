# 日本国内IPアドレス限定設定

## 日本国内のIPアドレス資料

https://ipv4.fetus.jp/jp.txt

## administration tool for kernel IP sets

```
sudo apt install ipset
```

## ipsetでホワイトリスト作成しiptableに設定する

```
sudo ipset destory white_list_japan
sudo ipset create white_list_japan hash:net
curl https://ipv4.fetus.jp/jp.txt | grep -v '^#' | xargs -I@ -P 0 sudo ipset add white_list_japan @
sudo ipset add white_list_japan 192.168.0.0/16
sudo ipset add white_list_japan 10.0.0.0/8
sudo ipset add white_list_japan 172.16.0.0/12
sudo ipset list white_list_japan
sudo ipset save white_list_japan > white_list_japan.txt
sudo iptables -I INPUT -m state --state NEW -p tcp --dport 22 -m set --match-set white_list_japan src -j ACCEPT
sudo sh -c 'ipset save > /etc/ipset.conf'
```

再起動後に実行されるように下記を設定

```
sudo vi /etc/network/if-pre-up.d/iptables-with-ipset
sudo chmod ug+x /etc/network/if-pre-up.d/iptables-with-ipset
```

```
#!/bin/sh
### 
### /etc/network/if-pre-up.d/iptables-with-ipset
### 

### read data from file list
ipset restore < /etc/ipset.conf
### 
iptables-restore < /etc/iptales.up.rules
```

## sshdのポート追加

```/etc/ssh/sshd_config```

```
Port 22
Port 2222
```

