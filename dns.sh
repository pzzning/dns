#!/bin/bash
#date:20170527
#zhengning
#用途：url域名 解析出所有IP,并根据ip获取ip归属地
#DNS列表

Shell_name=$0
DNS_list="
    114.114.114.114
    223.5.5.5
    1.2.4.8
    112.124.47.27
    8.8.8.8
    208.67.222.222
    61.132.163.68
    219.141.136.10
    61.128.192.68
    218.85.152.99
    202.100.64.68
    202.96.128.86
    202.103.225.68
    202.98.192.67
    222.88.88.88
    219.147.198.230
    202.103.24.68
    222.246.129.80
    218.2.2.2
    202.101.224.69
    219.148.162.31
    219.146.0.130
    218.30.19.40
    202.96.209.133
    61.139.2.69
    219.150.32.132
    222.172.200.68
    202.101.172.35
    202.106.196.115
    221.5.203.98
    210.21.196.6
    202.99.160.68
    202.102.224.68
    202.97.224.69
    202.98.0.68
    221.6.4.66
    202.99.224.68
    202.102.128.68
    202.99.192.66
    221.11.1.67
    210.22.70.3
    119.6.6.6
    202.99.104.68
    221.12.1.227"

#URL传参正确性判断：从URL中提取域名，且域名正确性判断
function Fun_url_check(){
    if [ `echo $1 |egrep '^http://|^https://' -c` == 1 ]; then
        URL=`echo $1 |awk -F\/ '{print $3}'`
    elif [ `echo $1 |awk -F\/ '{print $1}'|grep '\.' -c` == 1 ]; then
        URL=`echo $1 |awk -F\/ '{print $1}'`
    else
        echo -e "\e[31m$1 URL格式错误！\e[0m"
        exit;
    fi
    num=`echo $URL|wc -c`
    if [ `echo $URL |tr 'a-zA-Z0-9-'  '.'|grep -o '\.'|wc -l` != `echo $(($num-1))` ];then
        echo -e "\e[31m$1 URL格式错误！\e[0m"
        exit;
    fi
    echo -e "\e[31m域名:\e[32m$URL    \e[31mURL:\e[32m$1\e[0m"
}

#nslookup解析域名对应IP列表
function Fun_ip_list(){
for Dns in $DNS_list
do
    timeout 10 nslookup $1 $Dns|grep -v $Dns |awk -F\: '/Address/{print$2}'&
done
}

#获取IP归属地
function Fun_ip_local(){
    IP=$1
    address=`curl -s "http://ip138.com/ips138.asp?ip=${IP}&action=2"| iconv -f gb2312 -t utf-8|grep '' |grep '本站数据' |awk -F '[<>]' '{print$7}'|awk '{print $1"\t"$NF}'`
    printf "%-16s %-s\n" "$IP" "$address"
}

#URL传参正确性判断; 获取域名对应IP列表 及 IP归属地地址
function Fun_main(){
    URL=$1
    Fun_url_check $URL
    for IP in `Fun_ip_list $URL |sort -u |sort -t'.' -k1n,1 -k2n,2 -k3n,3 -k4n,4`
    do
        Fun_ip_local $IP
    done
}

if [ $1 == '-h' ];then
cat <<EOF
--------------------------------------------------------------------------------
Version: v1.0
auth:zn
Date：20170614

用途：
    DNS,根据URL，nslookup获取域名对应IP列表 及 IP归属地地址。

参数解释：
    不加参数；
            查询单个url归属地。
        eg.
            sh $Shell_name www.baidu.com
            sh $Shell_name www.baidu.com/ning.html
            sh $Shell_name http://www.baidu.com
            sh $Shell_name https://www.baidu.com/
            sh $Shell_name http://www.baidu.com/ning.html

    -f  file
            指定URL列表文件，解析文件中所有URL归属地
        eg.
            sh $Shell_name -f url_list.txt

    -h  help
            帮助参数
        eg.
            sh $Shell_name -h

    -ip ip地址
            查询IP地址归属地
        eg.
            sh $Shell_name -ip 114.114.114.114

    -l  list
            列出在用的DNS列表
        eg.
            sh $Shell_name -l

--------------------------------------------------------------------------------
EOF
exit
fi


if [ $1 == '-f' ];then
    URL_file=$2
    cat $URL_file |while read URL ;do
        Fun_main $URL
    done
elif [ $1 == '-ip' ];then
    IP=$2
    Fun_ip_local $IP
elif [ $1 == '-l' ];then
    echo $DNS_list|sed 's/ /\n/g'|sort -t'.' -k1n,1 -k2n,2 -k3n,3 -k4n,4
else
    URL=$1
    Fun_main $URL
fi

