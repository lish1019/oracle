#!/bin/bash
>/tmp/.mcalert.log
# 检查挂载点使用情况
echo "磁盘使用情况";df -hP
df -hP | awk '{print $5 " " $6}' | while read output;
do
  usage=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
  mount_point=$(echo $output | awk '{print $2}')
  if [[ $usage -ge 80 ]]; then
    echo "!!!!!!!挂载点 $mount_point 使用率超过80%!!!!!!!" |tee /tmp/.mcalert.log
  fi
done


# 检查oracle日志
grep -vE '^#|^$|+ASM' /etc/oratab|awk -F":" '{print $1}'|while read output;
do
oranode=`olsnodes -n|grep ${HOSTNAME}|awk '{print $2}'`
oracle_diag=`su - oracle -c "
export ORACLE_SID=$(echo $output)${oranode}
sqlplus -s / as sysdba<<EOF
set trimspool ON;
set feedback OFF;
set heading OFF;
select value from "v\\\'$'parameter" where name ='user_dump_dest';
exit;
EOF
"`
if [[ $oracle_diag = *ORA* ]];then
                echo $(echo $output)>>/tmp/.mcalert.log
        echo "!!!!!!!获取数据库日志路径失败,请检查数据库状态!!!!!!!" |tee -a /tmp/.mcalert.log
else
        size=$(du -sm ${oracle_diag%/*} | awk '{print $1}' | sed 's/M//')
        echo "数据库日志大小";du -shP ${oracle_diag%/*}
        if [[ $size -ge 3000 ]]; then
                echo $(echo $output)>>/tmp/.mcalert.log
                echo "!!!!!!!Oracle日志路径 $(echo ${oracle_diag%/*}) 使用量超过3GB!!!!!!!" |tee -a /tmp/.mcalert.log
                echo "find $(echo ${oracle_diag%/*}) -type f -mtime +15 -exec rm -rf {} \;" |tee -a /tmp/.mcalert.log
        fi
                if [[ `tail -2000 $oracle_diag/alert*log |grep ORA-|wc -l` -ge 0 ]];then
                        echo $(echo $output)>>/tmp/.mcalert.log
                        tail -2000 $oracle_diag/alert*log |grep ORA- |tee -a /tmp/.mcalert.log
                fi
fi
done

# 检查监听日志大小
listener_log=`su - oracle -c "lsnrctl status |grep "Log File""|awk '{print $NF}'|awk -F"/" 'OFS="/"{$NF="";print}'`
size=$(du -sm ${listener_log%/*} | awk '{print $1}' | sed 's/M//')
echo "监听日志大小";du -shP ${listener_log%/*}
if [[ $size -ge 3000 ]]; then
  echo "!!!!!!!监听日志 ${listener_log%/*} 使用量超过3GB!!!!!!!" |tee -a /tmp/.mcalert.log
  echo "find ${listener_log%/*} -type f -mtime +15 -exec rm -rf {} \;" |tee -a /tmp/.mcalert.log
fi

#检查表空间使用情况
grep -vE '^#|^$|+ASM' /etc/oratab|awk -F":" '{print $1}'|while read output;
do
oranode=`olsnodes -n|grep ${HOSTNAME}|awk '{print $2}'`
su - oracle -c "
echo "数据库$(echo $output)"
export ORACLE_SID=$(echo $output)${oranode}
sqlplus -S / as sysdba<<EOF
set trimspool ON
set feedback OFF
set pagesize 999
select TABLESPACE_NAME,ceil(TABLESPACE_SIZE*8/1024/1024) total_g,USED_SPACE*8/1024/1024 use_g,ceil(USED_PERCENT) use_per from dba_tablespace_usage_metrics  order by 4;
select ceil(sum(bytes)/1024/1024/1024) from dba_data_files;
select ceil(sum(bytes)/1024/1024/1024) from dba_segments;
select event,count(*) from gv"\\\$"session where wait_class<>'Idle' group by event order by 2;
exit;
EOF
"
su - oracle -c "
export ORACLE_SID=$(echo $output)${oranode}
sqlplus -S / as sysdba<<EOF
set trimspool ON
set feedback OFF
set heading OFF;
set pagesize 999
select TABLESPACE_NAME,ceil(TABLESPACE_SIZE*8/1024/1024) total_g,USED_SPACE*8/1024/1024 use_g,ceil(USED_PERCENT) use_per from dba_tablespace_usage_metrics  order by 4;
exit;
EOF
"| while read output;
do
  usage=$(echo $output | awk '{print $NF}' | cut -d'%' -f1)
  tablespace=$(echo $output|awk '{print $1}')
  if [[ $usage -ge 80 ]]; then
        echo $(echo $output)>>/tmp/.mcalert.log
    echo "!!!!!!!表空间 $tablespace 使用率超过80%       %!!!!!!!" |tee -a /tmp/.mcalert.log
  fi
done
done

is_cluster=`ps -ef|grep ohasd|wc -l`
if [[ $is_cluster -ge 2 ]]; then
#获取集群用户
griduser=`ps -ef|grep ocssd.bin|grep -v grep|awk '{print $1}'`
#集群状态查看
su - $griduser -c "echo 集群状态;crsctl stat res -t;echo 磁盘组使用情况;asmcmd lsdg"

#asm磁盘组使用率查看
su - $griduser -c "
asmcmd lsdg
"|grep -v 'Block'| while read output;
do
        name=$(echo $output | awk '{print $NF}')
        total=$(echo $output | awk '{print $7}')
        free=$(echo $output | awk '{print $10}')
        usage=`echo "sclae=0; $free*100/$total" | bc`
        if [[ $usage -lt 20 ]]; then
        echo "!!!!!!!磁盘组 ${name%/*} 使用率超过80%!!!!!!!" |tee -a /tmp/.mcalert.log
        fi;
done

#集群日志
if [[ $griduser = "oracle" ]];then
        var_crs_home=ORA_CRS_HOME
else
        var_crs_home=ORACLE_HOME
fi
gridhome=`su - $griduser -c "env |grep $var_crs_home"|awk -F"=" '{print $2}'`
gridbase=`su - $griduser -c "env |grep ORACLE_BASE"|awk -F"=" '{print $2}'`
homelogsize=$(du -sm ${gridhome}/log | awk '{print $1}' | sed 's/M//')
diagsize=$(du -sm ${gridbase}/diag | awk '{print $1}' | sed 's/M//')
echo "集群日志大小";du -shP ${gridhome}/log
if [[ $homelogsize -ge 3000 ]]; then
  echo "!!!!!!!集群日志 ${gridhome}/log 使用量超过3GB!!!!!!!" |tee -a /tmp/.mcalert.log
  echo "find ${gridhome}/log -type f -mtime +15 -exec rm -rf {} \;" |tee -a /tmp/.mcalert.log
fi
if [[ $diagsize -ge 3000 ]]; then
  echo "!!!!!!!集群日志 ${diagsize}/diag 使用量超过3GB!!!!!!!" |tee -a /tmp/.mcalert.log
  echo "find ${diagsize}/diag -type f -mtime +15 -exec rm -rf {} \;" |tee -a /tmp/.mcalert.log
fi
fi
echo " "
echo !!!!!!!!!!!
cat /tmp/.mcalert.log
