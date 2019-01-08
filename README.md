# dns
### [root@evercloud-25 dns]# sh dns.sh -h
### --------------------------------------------------------------------------------
### Version: v1.0
### auth:zn
### Date：20170614
### 
### 用途：
###     DNS,根据URL，nslookup获取域名对应IP列表 及 IP归属地地址。
### 
### 参数解释：
###     不加参数；
###             查询单个url归属地。
###         eg.
###             sh dns.sh www.baidu.com
###             sh dns.sh www.baidu.com/ning.html
###             sh dns.sh http://www.baidu.com
###             sh dns.sh https://www.baidu.com/
###             sh dns.sh http://www.baidu.com/ning.html
### 
###     -f  file
###             指定URL列表文件，解析文件中所有URL归属地
###         eg.
###             sh dns.sh -f url_list.txt
### 
###     -h  help
###             帮助参数
###         eg.
###             sh dns.sh -h
### 
###     -ip ip地址
###             查询IP地址归属地
###         eg.
###             sh dns.sh -ip 114.114.114.114
### 
###     -l  list
###             列出在用的DNS列表
###         eg.
###             sh dns.sh -l
### 
### --------------------------------------------------------------------------------
