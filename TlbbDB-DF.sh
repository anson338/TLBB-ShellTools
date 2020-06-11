#!/bin/bash
# shell by Wigiesen
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
echo "
+----------------------------------------------------------------------
| Clean Data for TLBB Database 
+----------------------------------------------------------------------
| Copyright © 2020-2099 Wigiesen All rights reserved.
+----------------------------------------------------------------------
| Author: Wigiesen(xyns) QQ:437723442
+----------------------------------------------------------------------
"
checkMySQLStatus(){
    port=`netstat -nlt|grep 3306|wc -l`
    if [ $port -ne 1 ];then
        echo "Error Message: MySQL Service is not running!"
        exit;
    fi
}
checkMySQLStatus

downloadTlbbDbSql(){
    wget -P /opt http://qbkcj22g7.bkt.clouddn.com/tlbbdb.sql
    wget -P /opt http://qbkcj22g7.bkt.clouddn.com/web.sql
}

cleanDatabase(){
    downloadTlbbDbSql
    read -p "Please enter mysql password for root: " dbpass;
    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [ ! -n "${dbpass}" ];then
            read -p "Password must be input, Please re-enter : " dbpass;
        else
            LimitIsTure=1
        fi
    done
    echo "Please wait....."
    mysql -uroot -p${dbpass} -e "drop database if exists tlbbdb; drop database if exists web;";
    mysql -uroot -p${dbpass} -e "create database tlbbdb; create database web;";
    mysql -uroot -p${dbpass} tlbbdb < tlbbdb.sql
    mysql -uroot -p${dbpass} web < web.sql
    rm -rf tlbbdb.sql
    rm -rf web.sql
    echo "
    +----------------------------------------------------------------------
    | TLBB Database is cleaned successfully !!!
    +----------------------------------------------------------------------
    | Injoy it!
    +----------------------------------------------------------------------
    | Author: Wigiesen(xyns) QQ:437723442
    +----------------------------------------------------------------------
    "
}
cleanDatabase