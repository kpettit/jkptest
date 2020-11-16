while [[ "mysql1" != $(mysql -B -N  -uroot -pmypass -e"select @@hostname" -hmysql1) ]]; do
    sleep 1
done
mysql -uroot -pmypass -hmysql1 \
  -e "RESET SLAVE ALL;" \
  -e "RESET MASTER;" \
  -e "SET @@GLOBAL.group_replication_bootstrap_group=1;" \
  -e "create user 'repl'@'%';" \
  -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%';" \
  -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'mypass'  WITH GRANT OPTION;" \
  -e "GRANT ALL PRIVILEGES ON *.* TO 'proxysql'@'%' identified by 'pass'  WITH GRANT OPTION;" \
  -e "flush privileges;" \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;" \
  -e "SET @@GLOBAL.group_replication_bootstrap_group=0;" \
  -e "SELECT * FROM performance_schema.replication_group_members;"


while [[ "mysql2" != $(mysql -B -N  -uroot -pmypass -e"select @@hostname" -hmysql2) ]]; do
    sleep 1
done
mysql -uroot -pmypass  -hmysql2  \
  -e "RESET SLAVE ALL;" \
  -e "RESET MASTER;" \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;"


while [[ "mysql3" != $(mysql -B -N  -uroot -pmypass -e"select @@hostname" -hmysql3) ]]; do
    sleep 1
done
mysql -uroot -pmypass  -hmysql3  \
  -e "RESET SLAVE ALL;" \
  -e "RESET MASTER;" \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;"

sleep 1

mysql -uroot -pmypass  -hmysql1 \
  -e "SELECT * FROM performance_schema.replication_group_members;"

mysql -uroot -pmypass  -hmysql2 \
  -e "SELECT * FROM performance_schema.replication_group_members;"

mysql -uroot -pmypass  -hmysql3 \
  -e "SELECT * FROM performance_schema.replication_group_members;"

