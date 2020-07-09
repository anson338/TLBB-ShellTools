###### stop Server ######
# 删除已有的计划任务
sed -i '/listenServer.sh/d' /var/spool/cron/root
# 删除目前自动备份的计划任务
sed -i '/AutoBackup-Server.sh/d' /var/spool/cron/root
sed -i '/AutoBackup-Db.sh/d' /var/spool/cron/root
cd /home/tlbb/Server && touch quitserver.cmd
# echo " stopping billing ......"
# ./billing stop
echo " stopping Server ......"

until
[ "$?" = "1" ]
do
  if [ ! -f "ServerTest" ];then
    ps aux | grep -w "./Server " | grep -v grep >/dev/null 2>&1
  else
    ps aux | grep -w "./ServerTest " | grep -v grep >/dev/null 2>&1
  fi
done
echo " Server stoped completely !!!!!!"

###### stop Login ######
LOGINPID=`ps aux | grep -w "./Login" | grep -v grep | awk '{print $2}'`
kill -9 $LOGINPID
echo " Login is stopping ......"

until
[ "$?" = "1" ]
do
  ps aux | grep -w "./Login" | grep -v grep >/dev/null 2>&1
done
echo " Login stoped completely !!!!!!"

###### stop World ######
WORLDPID=`ps aux | grep -w "./World" | grep -v grep | awk '{print $2}'`
kill -9 $WORLDPID
echo " World is stopping ......"

until
[ "$?" = "1" ]
do
  ps aux | grep -w "./World" | grep -v grep >/dev/null 2>&1
done
echo " World stoped completely !!!!!!"

###### stop ShareMemory ######
cd /home/tlbb/Server/ && touch exit.cmd
echo " ShareMemroy is saving data ......"

until
[ "$?" = "1" ]
do
  ps aux | grep -w "./ShareMemory" | grep -v grep >/dev/null 2>&1 
done
echo " ShareMemory stoped completely !!!!!!"
