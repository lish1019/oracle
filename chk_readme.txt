数据库名	select NAME from v$database;
数据库实例名	select INSTANCE_NAME from  v$instance;
是否RAC集群	select * from v$option where PARAMETER like '%Real%'
RDBMS 版本	Select * from v$version;
数据文件所占磁盘空间（G）	select sum(BYTES/1024/1024/1024) "BYTES_G" from dba_data_files
DB_BLOCK Size (K)	show parameter db_block_size
字符集	select userenv('language') from dual;
表空间个数	select count(*) from dba_tablespaces;
数据文件个数	Select count(*) from v$datafile;
控制文件个数	Select count(*) from  v$controlfile;
日志文件大小	Select bytes/1024/1024 from v$log;
日志组数目	Select count(group#) from v$log;
每组日志文件成员数量	select group#,count(member) from v$logfile group by group#;
归档模式	Archive log list;

2、	系统配置分析
3.1	磁盘空间检查
硬盘可用情况如下所示：
Linux:  df  –h
Aix:    df  -g
HP UNIX: df -v
3.2	CPU使用情况
CPU使用情况如下所示：
vmstat 1 5

HP UNIX : top
3.3	内存使用情况     
内存使用情况如下所示：
Linux: free –m
Aix: topas  或者 nmon  按m 或者 svmon
HPUNIX: top
3.4	IO使用情况
IO使用情况如下所示：
Linux: iostat 1 5(没有iostat 使用vmstat或者top)
Aix/HP UNIX:iostat 1 5
3.5	优化建议
分析项目	优化建议
	
	
	
3、	数据库配置分析
4.1	数据库补丁和版本
select comp_name,status,version from dba_server_registry;
4.2	Oracle Cluster配置

ocrcheck
查看CRS状态
crsctl check crs

查看rac状态
crs_stat –t

查看ASM使用情况
[grid@cxq ~]$ asmcmd
ASMCMD> lsdg


4.3	初始化参数文件
数据库的部分参数具体如下所示：
Show parameter
4.4	控制文件
控制文件路径
select name from v$controlfile;
4.5	Redo log信息
重做日志文件路径
select   a.MEMBER,
         b.GROUP#,
         b.THREAD#,
         b.SEQUENCE#,
         b.BYTES,
         b.MEMBERS,
         b.ARCHIVED,
         b.STATUS,
         b.FIRST_CHANGE#,
         b.FIRST_TIME
from     sys.v_$logfile a, sys.v_$log b
where    a.GROUP# = b.GROUP#
order by a.group#;

4.6	数据文件
数据库数据文件信息
select file#,name,status from v$datafile;

select file_id,FILE_NAME,TABLESPACE_NAME,BYTES/1024/1024/1024 byte_g ,MAXBYTES/1024/1024/1024 from  dba_data_files order by file_id;

SQL> select a.TABLESPACE_NAME,a.data_g,b.file_g,b.max_file_g  from 
(
  select sum(bytes/1024/1024/1024) data_g ,TABLESPACE_NAME from dba_segments group by TABLESPACE_NAME
) a ,
(
  select TABLESPACE_NAME ,sum(BYTES/1024/1024/1024) file_g ,sum(MAXBYTES/1024/1024/1024) max_file_g  from  dba_data_files group by tablespace_name
) b
where a.tablespace_name=b.tablespace_name;

SQL> select a.TABLESPACE_NAME,a.data_g,b.file_g,b.max_file_g ,TO_CHAR(ROUND(a.data_g /b.file_g * 100,2),'990.99') || '%' "data_used_in_file",
TO_CHAR(ROUND(b.file_g /b.max_file_g * 100,2),'990.99') || '%' "file_used_in_maxextent" from 
(
  select sum(bytes/1024/1024/1024) data_g ,TABLESPACE_NAME from dba_segments group by TABLESPACE_NAME
) a ,
(
  select TABLESPACE_NAME ,sum(BYTES/1024/1024/1024) file_g ,sum(MAXBYTES/1024/1024/1024) max_file_g  from  dba_data_files group by tablespace_name
) b
where a.tablespace_name=b.tablespace_name;

4.7	表空间管理
表空间使用率
SELECT D.TABLESPACE_NAME,SPACE "SUM_SPACE(M)",BLOCKS SUM_BLOCKS,SPACE-NVL(FREE_SPACE,0) "USED_SPACE(M)", 
ROUND((1-NVL(FREE_SPACE,0)/SPACE)*100,2) "USED_RATE(%)",FREE_SPACE "FREE_SPACE(M)" 
FROM  
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) SPACE,SUM(BLOCKS) BLOCKS 
FROM DBA_DATA_FILES 
GROUP BY TABLESPACE_NAME) D, 
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) FREE_SPACE 
FROM DBA_FREE_SPACE 
GROUP BY TABLESPACE_NAME) F 
WHERE  D.TABLESPACE_NAME = F.TABLESPACE_NAME(+) 
UNION ALL  --if have tempfile  
SELECT D.TABLESPACE_NAME,SPACE "SUM_SPACE(M)",BLOCKS SUM_BLOCKS,  
USED_SPACE "USED_SPACE(M)",ROUND(NVL(USED_SPACE,0)/SPACE*100,2) "USED_RATE(%)", 
NVL(FREE_SPACE,0) "FREE_SPACE(M)" 
FROM  
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) SPACE,SUM(BLOCKS) BLOCKS 
FROM DBA_TEMP_FILES 
GROUP BY TABLESPACE_NAME) D, 
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES_USED)/(1024*1024),2) USED_SPACE, 
ROUND(SUM(BYTES_FREE)/(1024*1024),2) FREE_SPACE 
FROM V$TEMP_SPACE_HEADER 
GROUP BY TABLESPACE_NAME) F 
WHERE  D.TABLESPACE_NAME = F.TABLESPACE_NAME(+);

4.8	失效对象及索引检查
失效对象
select OWNER,OBJECT_NAME,OBJECT_TYPE from dba_objects where status='INVALID';

失效索引
select INDEX_NAME,STATUS from  dba_indexes where STATUS ='INVALID';

4.9	索引层数分析
数据库中超过3层的索引
select index_name,table_name,owner,blevel from dba_indexes where blevel>3

4.10	查看使用DBA角色的用户
select * from sys.dba_role_privs where granted_role='DBA';

4.11	数据库告警日志分析 *
或者通过 show parameter dump 查看
Oracle 10g;
tail –f 1000 $ORACLE_BASE/admin/sid/bdump/alert_sid.log |more
oracle11g;
tail –f 1000 $ORACLE_BASE/diag/rdbms/db_name/sid/trace/alert_sid.log |more

查看dataguard状态：
select process,status ,thread#,sequence# from v$managed_standby;

4.12	Dataguard使用情况

4.14	备份情况
RMAN> crosscheck backup;
RMAN> delete expired backup;
RMAN> list backup of database;

RMAN> crosscheck archivelog all;
RMAN> delete expired archivelog all;
RMAN> list backup of archivelog all;


4.13	优化建议
分析项目	优化建议



80081037777
	
	
	
	
	
 @ D:\app\Administrator\product\11.2.0\dbhome_1\RDBMS\ADMIN\awrrpt.sql	
	
	
	

4、	数据库性能分析
收集高峰期1小时区间的AWR报告分析填写以下信息：
（个别sql性能较差只对sql收集AWR报告）
@?/rdbms/admin/awrrpt.sql
@$ORACLE_HOME/rdbms/admin/ashrpt.sql
awrsqrpt.sql
5.1	Redolog切换次数
5.2	Top5等待事件 

5.3	数据库负荷分析 
节点1

节点2

5.4	数据库内存命中率 

5.5	表空间IO性能分析 *

5.6	Top SQL语句 
SQL ordered by Elapsed Time

SQL ordered by CPU Time

SQL ordered by Gets

SQL ordered by Reads
5.7	优化建议
分析项目	优化建议
	
	
	
	
	
	
	
select sql_id,sql_text from v$sql
where sql_id in
(
   select sql_id from v$session where paddr in (select addr from v$process where spid='&pid')
);	
	

