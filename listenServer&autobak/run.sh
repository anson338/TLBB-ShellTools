ulimit -n 65535
# 删除已有的计划任务
sed -i '/listenServer.sh/d' /var/spool/cron/root
# 删除目前自动备份的计划任务
sed -i '/AutoBackup-Server.sh/d' /var/spool/cron/root
sed -i '/AutoBackup-Db.sh/d' /var/spool/cron/root
if ps aux | grep -w "./ShareMemory" | grep -v grep >/dev/null 2>&1;then
  echo " ShareMemory  is running !!!!!!"
else
  ###### start ShareMemory ######
  cd /home/tlbb/Server/ 
  ./shm clear >/dev/null 2>&1
  rm -rf exit.cmd quitserver.cmd
  ./shm start >/dev/null 2>&1
  echo " start ShareMemory ......"

  sleep 30
  echo " ShareMemory started completely !!!!!!"

  ###### start World ######
  cd /home/tlbb/Server/ 
  ./World >/dev/null 2>&1 &
  echo " start World ......"
  sleep 5
  echo " World started completely !!!!!!"

  ###### start Login ######
  ./Login >/dev/null 2>&1 &
  echo " start Login ......"
  sleep 1
  echo " Login started completely !!!!!!"

  ###### start Server ######
  cd /home/tlbb/Server/
  if [ ! -f "ServerTest" ];then
    ./Server >/dev/null 2>&1 &
  else
    ./ServerTest >/dev/null 2>&1 &
  fi

  echo " start Server ......"

  sleep 60
  echo " Server started completely !!!!!!"

  # ./billing &
  # echo " ------------billing started------------"

  # 创建监听计划任务
  sh /home/tlbb/listenServer.sh
  echo " ------------listenServer started------------"
  # 创建自动备份服务端计划任务
  sh /home/tlbb/AutoBackup-Server.sh
  echo " ------------AutoBackup-Server started------------"
  # 创建自动备份数据库计划任务
  sh /home/tlbb/AutoBackup-Db.sh
  echo " ------------AutoBackup-Db started------------"
fi
