#!/bin/sh
# 天龙服务端监听Server运行状态
# shell by 心语难诉
# 2020-6-30 17:25:04

AddCrontab(){
    # 查询是否已经写入过计划任务
    crontabCount=`crontab -l|grep listenServer.sh |grep -v grep|wc -l`
    if [ $crontabCount = 0 ];then
        (echo "* * * * * sleep 5;sh /home/tlbb/listenServer.sh > /dev/null 2>&1 &"; crontab -l) | crontab
    fi
}
AddCrontab


# 记录日志时间
echo `date +"%Y-%m-%d %H:%M:%S"`  >> /home/tlbb/listenServer.log

# 查询Login与World是否正常
LoginCount=`ps -fe|grep Login |grep -v grep|wc -l`
WorldCount=`ps -fe|grep World |grep -v grep|wc -l`

# 查询Server是否正常
ServerCount=`ps -fe|grep ServerTest |grep -v grep|wc -l`

# 查询Login和World是否存在，如果存在说明天龙服务正在
# 运行,并往下继续执行.否则的话直接退出脚本等待下次监听
if [ "$LoginCount" = 0 ] || [ "$WorldCount" = 0 ];then
    echo "TLBB Service is not running...." >> /home/tlbb/listenServer.log
    exit;
fi

# 如果 Server 不存在，就重启Server
if [ $ServerCount = 0 ];then
    #写入日志
    echo "restart TLBB Server....." >> /home/tlbb/listenServer.log
    cd /home/tlbb && ./stop.sh && ./run.sh
    # cd /home/tlbb/Server/
    # ./ServerTest >/dev/null 2>&1 &
    sleep 60
    echo "Server started completely !!!!!!" >> /home/tlbb/listenServer.log 
else
    #写入日志
    echo "TLBB Server is runing....."  >> /home/tlbb/listenServer.log
fi
