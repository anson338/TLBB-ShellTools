#!/bin/sh
# 天龙服务端自动打包备份脚本
# shell by 心语难诉
# 2020-7-6 15:47:24
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
echo "
+----------------------------------------------------------------------
| TLBB Database Auto Backup
+----------------------------------------------------------------------
| Copyright © 2020-2099 Wigiesen
+----------------------------------------------------------------------
| Author: Wigieen QQ:437723442
+----------------------------------------------------------------------
"
AddCrontab(){
    # 查询是否已经写入过计划任务
    crontabCount=`crontab -l|grep AutoBackup-Db.sh |grep -v grep|wc -l`
    if [ $crontabCount = 0 ];then
        (echo "*/10 * * * * sh /home/tlbb/AutoBackup-Db.sh > /dev/null 2>&1 &"; crontab -l) | crontab
    fi
}

AddCrontab

# 判断是否存在备份目录，如果没有就创建
if [ ! -d "/opt/db_bak" ]; then
    mkdir /opt/db_bak
fi

tlbbDbName="tlbbdb-"`date +"%Y-%m-%d-%H:%M"`".sql"
webDbName="web-"`date +"%Y-%m-%d-%H:%M"`".sql"

echo "Automatic backup in progress, please wait a minute...."
# 开始备份
mysqldump -uroot -pYOURPASSWORD tlbbdb > /opt/db_bak/${tlbbDbName}
mysqldump -uroot -pYOURPASSWORD web > /opt/db_bak/${webDbName}
echo `date +"%Y-%m-%d %H:%M:%S"`  >> /home/tlbb/Db_AutoBackup.log
echo "tlbbdb.sql is complete!!!"  >> /home/tlbb/Db_AutoBackup.log
echo "web.sql is complete!!!"  >> /home/tlbb/Db_AutoBackup.log
# 记录完成时间
echo "Database auto backup is complete!!!" >> /home/tlbb/Db_AutoBackup.log