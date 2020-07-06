ulimit -n 65535
# 删除已有的计划任务
sed -i '/listenServer.sh/d' /var/spool/cron/root
# 删除目前自动备份的计划任务
sed -i '/autoBak.sh/d' /var/spool/cron/root
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
    ./ServerTest >/dev/null 2>&1 &
  echo " start Server ......"

  sleep 60
  echo " Server started completely !!!!!!"
  # 创建监听计划任务
  sh /home/tlbb/listenServer.sh
  # 创建自动备份计划任务
  sh /home/tlbb/autoBak.sh
  echo " ------------listenServer started------------"
fi
