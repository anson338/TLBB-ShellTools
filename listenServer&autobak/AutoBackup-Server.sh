#!/bin/sh
# 天龙服务端自动打包备份脚本
# shell by 心语难诉
# 2020-7-6 15:47:24
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
echo "
+----------------------------------------------------------------------
| TLBB Server Auto Backup
+----------------------------------------------------------------------
| Copyright © 2020-2099 Wigiesen
+----------------------------------------------------------------------
| Author: Wigieen QQ:437723442
+----------------------------------------------------------------------
"
AddCrontab(){
    # 查询是否已经写入过计划任务
    crontabCount=`crontab -l|grep AutoBackup-Server.sh |grep -v grep|wc -l`
    if [ $crontabCount = 0 ];then
        (echo "0 */1 * * * sh /home/tlbb/AutoBackup-Server.sh > /dev/null 2>&1 &"; crontab -l) | crontab
    fi
}

AddCrontab

# 判断是否存在备份目录，如果没有就创建

if [ ! -d "/opt/server_bak" ]; then
    mkdir /opt/server_bak
fi

echo "In the process of packing, please wait a minute...."
# 开始打包
packName="tlbb-"`date +"%Y-%m-%d:%H"`".tar.gz"
nohup tar zcf /opt/server_bak/${packName} /home/tlbb & 
# 记录打包完成时间
echo `date +"%Y-%m-%d %H:%M:%S"`  >> /home/tlbb/Server_AutoBackup.log
echo "${packName} packaging is complete!!!" >> /home/tlbb/Server_AutoBackup.log