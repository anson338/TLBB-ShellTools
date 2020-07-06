#!/bin/bash
# shell by 心语难诉
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
echo "
+----------------------------------------------------------------------
| CentOS 7.x 天龙服务端环境 安装脚本
+----------------------------------------------------------------------
| Copyright © 2020-2099 心语难诉 版权所有.
+----------------------------------------------------------------------
| 作者: 心语难诉 QQ:437723442
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
        echo "错误提示: 当前脚本只能在 CentOS 7.x 64位系列版本上运行"
        exit;
    fi
    isPy26=$(python -V 2>&1|grep '2.6.')
    if [ "${isPy26}" ];then
        echo "错误提示: 当前脚本只能在 CentOS 7.x 系列版本上运行"
        exit;
    fi
}

GetSysInfo

while [ "$go" != 'y' ] && [ "$go" != 'n' ]
do
	read -p "你确定要安装天龙服务端到本系统吗？请选择Y(确定)N(取消): " go;
done

if [ "$go" == 'n' ];then
	exit;
fi

Select_Install_Version(){
    version_arr=(7.2 7.3 7.6 7.7)
    echo "------选择你要安装的系统版本(输入版本号,如:7.3)------"
    for i in ${version_arr[@]}
    do
        echo "--------------   $i   --------------"
    done
    echo "-------------------------------------"
    read -p "输入版本号 CentOS 版本号: " version;

    while [[ $version < 7.2 ]] || [[ $version > 7.7 ]]
    do
        read -p "版本号不正确,请重新输入: " version;
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
    read -p "请输入您需要设置的MySQL数据库密码: " dbpass;
    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [[ "${#dbpass}" -ge 8 ]];then
            LimitIsTure=1
        else
            read -p "密码必须大于等于8位,请重新输入 : " dbpass;
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
    | 天龙服务端架设成功 !!!
    +----------------------------------------------------------------------
    | 请保存您的MySQL密码: ${dbpass}
    +----------------------------------------------------------------------
    | 作者: 心语难诉 QQ:437723442
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