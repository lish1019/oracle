set echo off
set termout off
set pagesize 9999
set linesize 999	
set long 9999
prompt set feedback off

alter session set nls_language=american;
alter session set nls_date_format='yyyymmdd hh24:mi:ss';

COLUMN instance_name NEW_VALUE _instancename NOPRINT
SELECT instance_name instance_name FROM v$instance;
COLUMN spool_time NEW_VALUE _spooltime NOPRINT
SELECT TO_CHAR(SYSDATE,'YYYYMMDDHH24MI') spool_time FROM dual;

spool orachk_&_instancename._&_spooltime..txt

prompt *********
prompt *********DB INFO
prompt *********
select status,instance_name,startup_time,sysdate,PARALLEL as rac from gv$instance;
select open_mode,name from v$database;

prompt *********
prompt *********1.version and comp:
prompt *********
set linesize 180 pagesize 1000
col comp_name for a40
col status for a15
col version for a15
select comp_name,status,version from dba_server_registry;

set linesize 200
col VERSION for a15
col ACTION for a15
col NAMESPACE for a15
col COMMENTS for a30
col ACTION_TIME for a30
select action_time,action,id,version,comments from dba_registry_history;

prompt *********
prompt *********2.spfile:
prompt *********
set pagesize 180 linesize 180
col name  for a35
col value for a50
col sid for a10
select sid, name,value  from v$spparameter where value is not null order by 1;

prompt *********
prompt *********3.controlfile status:
prompt *********
col name for a50
select name,IS_RECOVERY_DEST_FILE,BLOCK_SIZE*FILE_SIZE_BLKS/1024/1024 mb from v$controlfile;

prompt *********
prompt *********4.redo log  status and archivelog switch Info:
prompt *********
set pagesize 180 linesize 180
col member for a50
col status for a10
col mb for 99999
col group# for 999999
col SEQUENCE# for 9999999
col thread# for 99
select a.status,a.thread#,a.group#,b.member,a.BYTES/1024/1024 mb,a.SEQUENCE#,a.ARCHIVED from v$log a,v$logfile b 
where a.group#=b.group# order by group#;

col name for a10
select NAME,DATABASE_ROLE ,log_mode from v$database;

set linesize 300  pagesize 500
col THREAD for a10
col date for a20
col thread for a6
select to_char(first_time,'yyyy/mm/dd:hh24') "Date",to_char(thread#) thread,count(1) "ArchiveLog/hour",
count(1)*(select a.BYTES/1024/1024 mb from v$log a where rownum=1) "ArchiveLog_size(MB)"
 from v$log_history 
 where trunc(first_time) 
 	in (trunc(sysdate),trunc(sysdate-1),trunc(sysdate-2),trunc(sysdate-3),trunc(sysdate-4),trunc(sysdate-5),trunc(sysdate-6),trunc(sysdate-7))
 group by to_char(first_time,'yyyy/mm/dd:hh24'),thread# order by 1,thread#,1;

set linesize 300  pagesize 500
col THREAD for a6
col date for a20
select to_char(first_time,'yyyy/mm/dd') "Date",to_char(thread#) thread,count(1) "ArchiveLog/hour",
count(1)*(select a.BYTES/1024/1024 from v$log a where rownum=1) "ArchiveLog_size(MB)"
 from v$log_history 
 where trunc(first_time) 
 	in (trunc(sysdate),trunc(sysdate-1),trunc(sysdate-2),trunc(sysdate-3),trunc(sysdate-4),trunc(sysdate-5),trunc(sysdate-6),trunc(sysdate-7))
 group by to_char(first_time,'yyyy/mm/dd'),thread# order by 1,thread#,1;

prompt *********
prompt *********5.datafile status:
prompt *********
set linesize 200 pagesize 200
col file_id for a5
col file_name for a45
col FILE_STATUS for a15
col TABLESPACE_STATUS for a10
col tablespace_name for a15
select trim(a.file_id) "FILE_ID",b.tablespace_name "TABLESPACE_NAME",b.status "TABLESPACE_STATUS",a.file_name "FILE_NAME",ceil(a.bytes/1024/1024) "FILE_SIZE(M)",a.AUTOEXTENSIBLE "AUTOEXTENSIBLE",a.maxbytes/1024/1024 "max_mb" from dba_data_files a,dba_tablespaces b where a.tablespace_name=b.tablespace_name  order by a.file_id,a.AUTOEXTENSIBLE desc;

prompt *********
prompt *********6.tablespace usage status:
prompt *********
col TABLESPACE_NAME format a25
SELECT * FROM (SELECT D.TABLESPACE_NAME,SPACE "SUM_SPACE(M)",BLOCKS SUM_BLOCKS,SPACE-NVL(FREE_SPACE,0) "USED_SPACE(M)", 
ROUND((1-NVL(FREE_SPACE,0)/SPACE)*100,2) "USED_RATE(%)",FREE_SPACE "FREE_SPACE(M)" 
FROM  
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) SPACE,SUM(BLOCKS) BLOCKS 
FROM DBA_DATA_FILES 
GROUP BY TABLESPACE_NAME) D, 
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) FREE_SPACE 
FROM DBA_FREE_SPACE 
GROUP BY TABLESPACE_NAME) F 
WHERE  D.TABLESPACE_NAME = F.TABLESPACE_NAME(+) ORDER BY  5 DESC) 
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

select trunc(sum(a.total)/1024,2) db_total_gb,trunc(sum(nvl(b.free,0))/1024,2) db_free_gb, trunc((sum(a.total)- sum(nvl(b.free,0)))/1024,2) db_used_gb
  from (select tablespace_name, sum(nvl(bytes, 0)) / 1024 / 1024 total
  from dba_data_files
  group by tablespace_name) a,
  (select tablespace_name, sum(nvl(bytes, 0)) / 1024 / 1024 free
  from dba_free_space
  group by tablespace_name) b,
  dba_tablespaces c
where a.tablespace_name = c.tablespace_name
   and c.tablespace_name = b.tablespace_name(+);

prompt *********
prompt *********7.INVALID object Info:
prompt *********
set linesize 180 pagesize 200
col owner for a15
col OBJECT_NAME for a30
col OBJECT_TYPE for a15
col TABLE_OWNER for a15
col TABLE_NAME for a25
select OWNER,OBJECT_NAME,OBJECT_TYPE from dba_objects where status='INVALID';
select OWNER,INDEX_NAME,INDEX_TYPE,STATUS,TABLE_OWNER,TABLE_NAME from  dba_indexes where STATUS ='INVALID';

prompt *********
prompt *********8.Index level Info:
prompt *********
set linesize 180 pagesize 200
col owner for a15
col index_name for a30
col TABLE_NAME for a25
select index_name,table_name,owner,blevel from dba_indexes where blevel>3;

prompt *********
prompt *********9.DBA ROLE USER:
prompt *********
col GRANTEE for a20
col granted_role for a20
select * from sys.dba_role_privs where granted_role='DBA';

prompt *********
prompt *********10.DATAGUARD STATUS
prompt *********
select process,status,SEQUENCE# from v$managed_standby;
col MESSAGE for a40
select FACILITY,SEVERITY,TIMESTAMP,MESSAGE  from v$dataguard_status;

prompt *********
prompt *********11.RMAN BACK INFO
prompt *********
set linesize 180 pagesize 200
col inc_lev for 9999
col device_type for a6
col bs_key for 99999
col elap_MIN FOR 999999
SELECT bs.recid bs_key
  , DECODE(backup_type, 'L', 'Archived Redo Logs', 'D', 'Datafile Full Backup', 'I', 'Incremental Backup') backup_type
  ,  device_type  
  ,  DECODE(bs.controlfile_included, 'NO', '-', bs.controlfile_included)    controlfile_included
  , bs.incremental_level inc_lev ,  bs.start_time, bs.completion_time, bs.elapsed_seconds/60   elap_MIN                                                                                        
FROM
    v$backup_set    bs
  , (select distinct set_stamp, set_count, tag, device_type
     from v$backup_piece
     where status in ('A', 'X'))           bp
WHERE bs.start_time>sysdate-2 
  AND bs.set_stamp = bp.set_stamp
  AND bs.set_count = bp.set_count
ORDER BY bs.recid;


col TIME_TAKEN_DISPLAY for a10
col INPUG_SIZE for a10
col OUTPUG_SIZE for a10
col "output/s" for a10
col status for a10
col OUT_P for a5
select start_time,time_taken_display,status, input_type, 
output_device_type OUT_P, input_bytes_display INPUG_SIZE, output_bytes_display OUTPUG_SIZE, output_bytes_per_sec_display as "output/s"
     from v$rman_backup_job_details
     where start_time>sysdate-2
     order by start_time DESC;     

prompt *********
prompt *********12.ASM DISKGROP INFO
prompt *********
col path for a20
col name for a10
set linesize 180 pagesize 100
select GROUP_NUMBER,NAME,PATH,STATE, HEADER_STATUS,OS_MB,TOTAL_MB,FREE_MB  from v$asm_disk;
SELECT GROUP_NUMBER,NAME,STATE  FROM V$ASM_DISKGROUP;

set linesize 200
col name for a10
col state for a10
col usage for a5
select name,state,type,total_mb/1024 total_gb,free_mb/1024 free_gb,100-trunc(USABLE_FILE_MB/(total_mb/2)*100)||'%' as Usage,USABLE_FILE_MB/1024 USABLE_FILE_GB,OFFLINE_DISKS from V$ASM_DISKGROUP where type='NORMAL' 
union
 select name,state,type,total_mb/1024 total_gb,free_mb/1024 free_gb,100-trunc(USABLE_FILE_MB/total_mb*100)||'%' as Usage,USABLE_FILE_MB,OFFLINE_DISKS from V$ASM_DISKGROUP where type='EXTERN'
 union
 select name,state,type,total_mb/1024 total_gb,free_mb/1024 free_gb,100-trunc(USABLE_FILE_MB/(total_mb/3)*100)||'%' as Usage,USABLE_FILE_MB/1024 USABLE_FILE_GB,OFFLINE_DISKS from V$ASM_DISKGROUP where type='HIGH';



prompt *********
prompt *********END
prompt *********
SPOOL OFF
SET TERMOUT ON
prompt
prompt Database HealthCheck Report Output written to: orachk_&_instancename._&_spooltime..txt
prompt
EXIT;
