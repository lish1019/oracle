���ݿ���	select NAME from v$database;
���ݿ�ʵ����	select INSTANCE_NAME from  v$instance;
�Ƿ�RAC��Ⱥ	select * from v$option where PARAMETER like '%Real%'
RDBMS �汾	Select * from v$version;
�����ļ���ռ���̿ռ䣨G��	select sum(BYTES/1024/1024/1024) "BYTES_G" from dba_data_files
DB_BLOCK Size (K)	show parameter db_block_size
�ַ���	select userenv('language') from dual;
��ռ����	select count(*) from dba_tablespaces;
�����ļ�����	Select count(*) from v$datafile;
�����ļ�����	Select count(*) from  v$controlfile;
��־�ļ���С	Select bytes/1024/1024 from v$log;
��־����Ŀ	Select count(group#) from v$log;
ÿ����־�ļ���Ա����	select group#,count(member) from v$logfile group by group#;
�鵵ģʽ	Archive log list;

2��	ϵͳ���÷���
3.1	���̿ռ���
Ӳ�̿������������ʾ��
Linux:  df  �Ch
Aix:    df  -g
HP UNIX: df -v
3.2	CPUʹ�����
CPUʹ�����������ʾ��
vmstat 1 5

HP UNIX : top
3.3	�ڴ�ʹ�����     
�ڴ�ʹ�����������ʾ��
Linux: free �Cm
Aix: topas  ���� nmon  ��m ���� svmon
HPUNIX: top
3.4	IOʹ�����
IOʹ�����������ʾ��
Linux: iostat 1 5(û��iostat ʹ��vmstat����top)
Aix/HP UNIX:iostat 1 5
3.5	�Ż�����
������Ŀ	�Ż�����
	
	
	
3��	���ݿ����÷���
4.1	���ݿⲹ���Ͱ汾
select comp_name,status,version from dba_server_registry;
4.2	Oracle Cluster����

ocrcheck
�鿴CRS״̬
crsctl check crs

�鿴rac״̬
crs_stat �Ct

�鿴ASMʹ�����
[grid@cxq ~]$ asmcmd
ASMCMD> lsdg


4.3	��ʼ�������ļ�
���ݿ�Ĳ��ֲ�������������ʾ��
Show parameter
4.4	�����ļ�
�����ļ�·��
select name from v$controlfile;
4.5	Redo log��Ϣ
������־�ļ�·��
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

4.6	�����ļ�
���ݿ������ļ���Ϣ
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

4.7	��ռ����
��ռ�ʹ����
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

4.8	ʧЧ�����������
ʧЧ����
select OWNER,OBJECT_NAME,OBJECT_TYPE from dba_objects where status='INVALID';

ʧЧ����
select INDEX_NAME,STATUS from  dba_indexes where STATUS ='INVALID';

4.9	������������
���ݿ��г���3�������
select index_name,table_name,owner,blevel from dba_indexes where blevel>3

4.10	�鿴ʹ��DBA��ɫ���û�
select * from sys.dba_role_privs where granted_role='DBA';

4.11	���ݿ�澯��־���� *
����ͨ�� show parameter dump �鿴
Oracle 10g;
tail �Cf 1000 $ORACLE_BASE/admin/sid/bdump/alert_sid.log |more
oracle11g;
tail �Cf 1000 $ORACLE_BASE/diag/rdbms/db_name/sid/trace/alert_sid.log |more

�鿴dataguard״̬��
select process,status ,thread#,sequence# from v$managed_standby;

4.12	Dataguardʹ�����

4.14	�������
RMAN> crosscheck backup;
RMAN> delete expired backup;
RMAN> list backup of database;

RMAN> crosscheck archivelog all;
RMAN> delete expired archivelog all;
RMAN> list backup of archivelog all;


4.13	�Ż�����
������Ŀ	�Ż�����



80081037777
	
	
	
	
	
 @ D:\app\Administrator\product\11.2.0\dbhome_1\RDBMS\ADMIN\awrrpt.sql	
	
	
	

4��	���ݿ����ܷ���
�ռ��߷���1Сʱ�����AWR���������д������Ϣ��
������sql���ܽϲ�ֻ��sql�ռ�AWR���棩
@?/rdbms/admin/awrrpt.sql
@$ORACLE_HOME/rdbms/admin/ashrpt.sql
awrsqrpt.sql
5.1	Redolog�л�����
5.2	Top5�ȴ��¼� 

5.3	���ݿ⸺�ɷ��� 
�ڵ�1

�ڵ�2

5.4	���ݿ��ڴ������� 

5.5	��ռ�IO���ܷ��� *

5.6	Top SQL��� 
SQL ordered by Elapsed Time

SQL ordered by CPU Time

SQL ordered by Gets

SQL ordered by Reads
5.7	�Ż�����
������Ŀ	�Ż�����
	
	
	
	
	
	
	
select sql_id,sql_text from v$sql
where sql_id in
(
   select sql_id from v$session where paddr in (select addr from v$process where spid='&pid')
);	
	

