#!/bin/bash
my_user="$1"
my_password="$2"
my_host="$3"
my_conn="-u $my_user -p$my_password -h $my_host"
my_db="$4"
bak_way="$5"
cd $5
bf_cmd="/usr/bin/mysqldump"
bf_time=`date +%Y%m%d-%H%M`
$bf_cmd $my_conn --databases $my_db > ${my_db}_${bf_time}
/bin/tar zcf ${my_db}_${bf_time}.tar.gz ${my_db}_${bf_time} --remove &> /dev/nul

