#!/bin/bash
# shell by Wigiesen
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
echo "
+----------------------------------------------------------------------
| TLBB Service for CentOS 7.x install shell
+----------------------------------------------------------------------
| Copyright © 2020-2099 Wigiesen All rights reserved.
+----------------------------------------------------------------------
| Author: Wigiesen(xyns) QQ:437723442
+----------------------------------------------------------------------
"
GetSysInfo(){
	if [ -s "/etc/redhat-release" ];then
		SYS_VERSION=$(cat /etc/redhat-release)
	elif [ -s "/etc/issue" ]; then
		SYS_VERSION=$(cat /etc/issue)
	fi

    is64bit=$(getconf LONG_BIT)
    if [ "${is64bit}" != '64' ];then
        echo "Error message: This shell can only be run on CentOS 7.x 64bit and above"
        exit;
    fi
    isPy26=$(python -V 2>&1|grep '2.6.')
    if [ "${isPy26}" ];then
        echo "Error message: This shell can only be run on CentOS 7.x and above"
        exit;
    fi
}

GetSysInfo

while [ "$go" != 'y' ] && [ "$go" != 'n' ]
do
	read -p "Do you want to install TLBB Service for CentOS 7.x to your Server now?(y/n): " go;
done

if [ "$go" == 'n' ];then
	exit;
fi

Select_Install_Version(){
    version_arr=(7.2 7.3 7.6 7.7)
    echo "---------Please select version ------"
    for i in ${version_arr[@]}
    do
        echo "--------------   $i   --------------"
    done
    echo "-------------------------------------"
    read -p "Select CentOS version: " version;

    while [[ $version < 7.2 ]] || [[ $version > 7.7 ]]
    do
        read -p "Please enter the correct CentOS 7.x version: " version;
    done
}

downloadPack(){
    if [ ! -f "/opt/tlbbfor7x.tar.gz" ];then
        wget -P /opt http://tlbblib.xintlbb.com/tlbbfor7x.tar.gz
    fi
    tar zxvf /opt/tlbbfor7x.tar.gz -C /opt
}

installTlbbService(){
    # 设置数据库密码
    read -p "Please enter mysql password for root: " dbpass;
    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [[ "${#dbpass}" -ge 8 ]];then
            LimitIsTure=1
        else
            read -p "Password must be longer than 8 characters, Please re-enter : " dbpass;
        fi
    done

    # 进入安装目录
    cd /opt

    # 数据库安装
    yum -y remove mysql-libs
    tar zxvf MySQL.tar.gz
    rpm -ivh mysql-client.rpm
    rpm -ivh mysql-server.rpm

    # 数据库权限相关操作
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'root' with grant option;";
    mysql -e "use mysql;update user set password=password('${dbpass}') where user='root';";
    mysql -e "create database tlbbdb;";
    mysql -e "create database web;";
    mysql -e "flush privileges;";
    # 导入纯净数据库
    mysql -uroot -p${dbpass} tlbbdb < tlbbdb.sql
    mysql -uroot -p${dbpass} web < web.sql

    # 安装依赖组件
    yum -y install glibc.i686 libstdc++-4.4.7-4.el6.i686 libstdc++.so.6

    # 安装ODBC与ODBC相关依赖组件
    tar zxvf lib.tar.gz
    rpm -ivh unixODBC-libs.rpm
    rpm -ivh unixODBC-2.2.11.rpm
    rpm -ivh libtool-ltdl.rpm
    rpm -ivh unixODBC-devel.rpm --nodeps --force

    # 安装MYSQL ODBC驱动
    tar zxvf ODBC.tar.gz
    ln -s /usr/lib64/libz.so.1 /usr/lib/lib
    rpm -ivh mysql-odbc.rpm --nodeps

    # ODBC配置
    tar zvxf Config.tar.gz -C /etc
    chmod 644 /etc/my.cnf
    sed -i "s/^\(Password        = \).*/\1${dbpass}/" /etc/odbc.ini

    # 解压ODBC支持库到use/lib目录
    tar zvxf odbc.tar.gz -C /usr/lib
}

claerSetupLib(){
    rm -rvf *
    echo "
    +----------------------------------------------------------------------
    | TLBB Service for CentOS 7.x installed successfully !!!
    +----------------------------------------------------------------------
    | Please save your MySQL database password: ${dbpass}
    +----------------------------------------------------------------------
    | Author: Wigiesen(xyns) QQ:437723442
    +----------------------------------------------------------------------
    "
}

# 选择系统版本
Select_Install_Version
# 下载Lib
downloadPack
# 安装TLBB Service
installTlbbService
# 清理安装包
claerSetupLib