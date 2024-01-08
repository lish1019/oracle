
set pagesize 500
set serveroutput on size 80000
set head on
set feedback off
set echo off
set linesize 200

--select owner||'    '||table_name  
--       from dba_tables where owner=upper('mccheckmc963');
--prompt  
--       
--declare
-- v_a number;
--begin
-- select count(*) into v_a 
-- from dba_users where username=upper('mccheckmc963');
-- if v_a =1 then
--   dbms_output.put_line('Hint: dbcheck user:[mccheckmc963] has exist.');
--   dbms_output.put_line('Hint: we will drop it,then recreate the user:[mccheckmc963].');
-- else
--   dbms_output.put_line('Hint:  dbcheck user:[mccheckmc963] is not exist.');
--   dbms_output.put_line('Hint:  we will create the new user:[mccheckmc963].');
-- end if;
--end;
--/
--
--prompt  
--prompt Note:You can drop it[mccheckmc963] after dbcheck is end.   
--prompt
----是否新建用户？
----回车： 表示继续
----ctrl-c：中断退出
--accept uc  prompt 'continue [enter] /exit [ctrl-c] :  '
--accept uc  prompt 'are you sure?  continue [enter] /exit [ctrl-c]  '
--declare
-- uc0 number;
--begin
--select count(*) into uc0 from dba_users where username=upper('mccheckmc963');
--if uc0=1 then
--   execute immediate 'drop user mccheckmc963 cascade';
--   execute immediate 'create user mccheckmc963 identified by mccheckmc963';
--   execute immediate 'grant create session,connect to mccheckmc963'; 
--else
--   dbms_output.put_line('Note:we will create a new user[mccheckmc963] .');
--   execute immediate 'create user mccheckmc963 identified by mccheckmc963';
--   execute immediate 'grant create session,connect to mccheckmc963';  
--end if;
--end;
--/ 

--开始输出数据，格式htm，在某些主机上，不适合用htm格式查看，可以注销掉
set markup html on entmap on
spool dbcheck.htm

declare
 v_t varchar2(30); 
begin 
   select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') into v_t from dual;
   dbms_output.put_line('█巡检时间:  '||v_t||'' ); 
end;
/

prompt
prompt █ORACLE数据库配置   
prompt

select inst_id,name "Parameter Name",value from (
 select to_char(inst_id) inst_id,11 id,rpad('Instance Name',30) name,value 
 from gv$parameter  where name in ('instance_name') and value is not null
 union
 select to_char(inst_id) inst_id,12 id,rpad('DB Name',30) name,value 
 from gv$parameter  where name in ('db_name') and value is not null
 union
 select to_char(inst_id) inst_id,13 id,rpad('Services Name',30) name,value 
 from gv$parameter  where name in ('service_names') and value is not null
 union 
 select to_char(inst_id) inst_id,14 id,rpad('SGA_MAX_SIZE',30) name,value 
 from gv$parameter  where name in ('sga_max_size') and value is not null
 union 
 select to_char(inst_id) inst_id,15 id,rpad('SGA_TARGET',30) name,value 
 from gv$parameter  where name in ('sga_target') and value is not null
 union 
 select to_char(inst_id) inst_id,16 id,rpad('SHARED_POOL_SIZE',30) name,value 
 from gv$parameter  
 where name in ('shared_pool_size') and value is not null
 union 
 select to_char(inst_id) inst_id,17 id,
 rpad('PGA_AGGREGATE_TARGET',30) name,value 
 from gv$parameter  
 where name in ('pga_aggregate_target') and value is not null
 union 
 select to_char(inst_id) inst_id,18 id,
 rpad('DB_CACHE_SIZE',30) name,value 
 from gv$parameter  where name in ('db_cache_size') and value is not null
 union 
 select to_char(inst_id) inst_id,19 id,
 rpad('DB_BLOCK_SIZE',30) name,value 
 from gv$parameter  where name in ('db_block_size') and value is not null
 union
 select to_char(inst_id) inst_id,20 id,
 rpad('MEMORY_TARGET',30) name,value 
 from gv$parameter  where name in ('memory_target') and value is not null
 union
 select to_char(inst_id) inst_id,21 id,
 rpad('UNDO_MANAGEMENT',30) name,value 
 from gv$parameter  where name in ('undo_management') and value is not null
 union
 select to_char(inst_id) inst_id,22 id,
 rpad('UNDO_TABLESPACE',30) name,value 
 from gv$parameter  where name in ('undo_tablespace') and value is not null
 union
 select to_char(inst_id) inst_id,23 id,
 rpad('UNDO_RETENTION',30) name,value 
 from gv$parameter  where name in ('undo_retention') and value is not null
 union
 select to_char(inst_id) inst_id,24 id,
 rpad('DB_RECOVERY_FILE_DEST_SIZE',30) name,value 
 from gv$parameter  where name in ('db_recovery_file_dest_size') and value is not null
 union 
 select to_char(inst_id) inst_id,25 id,
 rpad('OPEN_CURSORS',30) name,value 
 from gv$parameter  where name in ('open_cursors') and value is not null
 union
 select to_char(inst_id) inst_id,26 id,
 rpad('WORKAREA_SIZE_POLICY',30) name,value 
 from gv$parameter  where name in ('workarea_size_policy') and value is not null
 union
 select '999-' inst_id,27 id,
 rpad('RDBMS Version/Release',30) name,
 substr(banner,instr(banner,'Enterprise Edition')+27,10) value 
 from   v$version 
 where banner like '%Enterprise Edition%'
 union
 select '999-' inst_id,28 id,
 rpad('Database character set',30) name,value$ value  
 from sys.props$ where  name='NLS_CHARACTERSET'
-- union
-- select '999-' inst_id,29 id,
-- rpad('ASM Version/Release',30) name,COMPATIBILITY value 
-- from v$asm_diskgroup
 union 
 select '999-' inst_id,30 id,
 rpad('Archiving Enabled?',30) name,LOG_MODE value  
 from v$database 
 union 
 select to_char(inst_id) inst_id,31 id,
 rpad(name,30),value 
 from gv$parameter  where name in 'log_archive_dest' and value is not null    
 union 
 select to_char(inst_id) inst_id,32 id,
 rpad(name,30),value 
 from gv$parameter  where name like 'log_archive_dest__' and value is not null
 union
 select '999-' inst_id,33 id,
 rpad('表空间总数量',30) name, to_char(count(*)) value 
 from dba_tablespaces
 union
 select '999-' inst_id,34 id,
 rpad('其中临时表空间总数量',30) name, 
 to_char(count(distinct tablespace_name)) value 
 from dba_temp_files
 union
 select '999-' inst_id,35 id,
 rpad('数据文件总数量',30) name,
 to_char(count(*)) value 
 from dba_data_files
 union                                
 select '999-' inst_id,36 id,
 rpad('临时文件总数量',30) name,to_char(count(*)) value 
 from dba_temp_files
 union                                
 select '999-' inst_id,37 id,
 rpad('控制文件总数量',30) name,to_char(count(*)) value 
 from v$controlfile
 union                                
 select '999-' inst_id,38 id,rpad('日志文件组数量',30) name,
 to_char(count(*)) value 
 from v$log 
 union
 select '999-' inst_id,39 id,rpad('临时表空间大小',30) name,
 to_char(trunc(sum(bytes)/1024/1024))||'M' value 
 from dba_temp_files
 union
 select '999-' inst_id,40 id,rpad('UNDO表空间大小',30) name,
 to_char(trunc(sum(bytes)/1024/1024))||'M'  value from dba_data_files 
  where  tablespace_name in 
  (select tablespace_name 
  from dba_tablespaces where contents='UNDO')
 union
 select '999-' inst_id,41 id,
 rpad('第 '||group#||' 组日志文件;'||'成员数量: '||members||'个',30) name,
 '  大小: '||to_char(trunc(bytes/1024/1024))||'(M)' value 
 from v$log  
 union
 select '999-' inst_id,42 id,rpad('Usage (OLTP, DSS, etc.)',30) name,
 rpad(' OLTP',20) value  from dual
 union    
 select '999-' inst_id,43 id,
 rpad('Tablespaces on Raw Devices?',30) name,rpad(' ',20) value 
 from dual
 union    
 select '999-' inst_id,44 id,
 rpad('Number of Concurrent Users',30) name,
 rpad(' ',20) value from dual
 union    
 select '999-' inst_id,45 id,
 rpad('User Access Method',30) name,rpad(' ',20) value 
 from dual
 union      
 select '999-' inst_id,46 id,
 rpad('Distributed? How?',30) name,rpad(' ',20) value 
 from dual
 union     
 select '999-' inst_id,47 id,
 rpad('Data Feeds and Frequencies (e.g. Data Entry,SQL*Load, Copies Database Link, etc.)',100),
 rpad(' ',20) value 
 from dual
 union    
 select '999-' inst_id,48 id,
 rpad('Availability Requirements (e.g. M-F 8-5,7x24, etc.)',100),
 rpad(' ',20) value 
 from dual
 ) order by inst_id,id;
         
set head on 

prompt █资源管理    
prompt  ______________________________________________________________ 
prompt

prompt 1）数据库资源 
prompt ______________________________________________________________
prompt
 select RESOURCE_NAME "名称",
        CURRENT_UTILIZATION "当前值",
        MAX_UTILIZATION "曾使用最大值",
        INITIAL_ALLOCATION "启动后分配值",
        LIMIT_VALUE "最大限制值" 
        from v$resource_limit; 
prompt ☆  结论：
prompt  
prompt ☆  建议：
prompt  

prompt 2）数据库负载 
prompt ______________________________________________________________
prompt

select inst_id "INSTANCE ID",
 status,
 count(*) "SESSION NUMBER" 
 from gv$session 
 group by inst_id,status 
 order by 1,2;
prompt
prompt ☆  结论：
prompt  
prompt ☆  建议：
prompt       
       
prompt █空间管理  
prompt
prompt1）操作系统
prompt ______________________________________________________________
prompt 系统主机为XXXX，配置XXX存储，以下为文件系统空间使用情况：
      select inst_id,fsname "表空间名",total "总空间（K）",free "剩余空间(K)",trunc((total-free)*100/total) "使用率%" from  mc$fs_space where
      key_date=(select max(key_date) from mc$fs_space) order by 1,5 desc;
prompt  ☆  说明：
prompt    目前系统中使用率操作90%的文件系统为：
prompt
prompt



prompt2）数据库 
prompt ______________________________________________________________

--begin
--  execute immediate 'drop table mccheckmc963.mccheckmc963_tmp10_t1';
--exception
--  when others then
--    if sqlcode=-942 then
--      null;
--    else
--      dbms_output.put_line(sqlcode);
--    end if;
--end;
--/
--
--create global temporary table  
--mccheckmc963.mccheckmc963_tmp10_t1 
--on commit preserve rows as
--select trunc(sum(a.bytes)/1024/1024) total 
--from dba_data_files a;
--
--create global temporary table  
--mccheckmc963.mccheckmc963_tmp10_t100 
--on commit preserve rows as
--select trunc(sum(b.bytes)/1024/1024) free
--from dba_free_space b;
  
declare
   v_a varchar2(30);
   v_b number;
   v_c number;      
   v_d number;
   v_e number;  
--   v_f number; 
--   v_g varchar2(30);

begin
   dbms_output.put_line(chr(10)); 
   select decode(log_mode,'NOARCHIVELOG','非归档模式','归档模式') into v_a from v$database;
   select sum(bytes)/1024/1024 into v_b  from v$datafile;
   select sum(bytes)/1024/1024 into v_c  from dba_free_space;
   
   v_d:=v_b - v_c;
   v_e:=trunc((v_b-v_c)/v_b*100,2);  
   dbms_output.put_line('本次ORACLE检查数据：');
   dbms_output.put_line('数据库归档模式：       '||v_a);  
   dbms_output.put_line('数据库空间分配总规模： '||v_b||' (M)');
   dbms_output.put_line('数据库空闲空间总规模： '||v_c||' (M)');
   dbms_output.put_line('数据库已使用空间：     '||v_d||' (M)');
   dbms_output.put_line('已使用总空间比率：     '||v_e||' %');  
--   select count(1) into v_f from v$version where banner like '%10g%' or banner like '%11g%';
--   if v_f > 0 then
--      select decode(FLASHBACK_ON,'YES','打开','NO','未打开') into v_g from v$database;
--      dbms_output.put_line('是否打开数据库闪回： '||v_g);
--   end if;
--       
end;
/ 

prompt   
prompt  数据库空间增长分布情况： 
       select to_char(key_date,'yyyy-mm-dd hh24:mi') "日期",
       round(total_space/1024/1024,2) "总分配空间 (M)",
       round(used_space/1024/1024,2) "总使用空间 (M)" 
       from mc$db_space
       where to_char(key_date, 'dd') in ('01', '15')
			 order by 1;
  
prompt   
prompt    
prompt ☆  结论：
prompt    空间空闲率风险等级：安全  良好  不安全 
prompt ☆  建议：
prompt
prompt 3）表空间 
prompt ______________________________________________________________

prompt
prompt 表空间使用率超过85%如下： 

col tablespace_name format a8
col status format a7
col extent_management format a5
col segment_space_management format a6
col contents format a9


select * from (
SELECT  d.tablespace_name  "TABLESPACE",d.status "STATUS",
        d.extent_management "EXT_MGT",
        d.segment_space_management "段管理", d.contents "CONTENTS",/*d.RETENTION "RETENTION"*/
        TO_CHAR(NVL(trunc(a.bytes / 1024 / 1024), 0),'99G999G990') "ALLOC(M)",
        TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0) / 1024 / 1024 ,'99G999G990') "USED(M)",
        TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0),'990D00') "USED%",
        TO_CHAR(NVL(trunc(f.largest_free / 1024 / 1024), 0),'99G999G990') "最大空闲(M)"  
        FROM sys.dba_tablespaces d,
        (SELECT tablespace_name,SUM(bytes) bytes   FROM dba_data_files  GROUP BY tablespace_name) a,
        (SELECT tablespace_name,SUM(bytes) bytes, MAX(bytes) largest_free   FROM dba_free_space   GROUP BY tablespace_name) f  
        WHERE d.tablespace_name = a.tablespace_name   AND d.tablespace_name = f.tablespace_name(+)
        )
        where "USED%">85
    order by "USED%" desc;
    
declare
  v_a number;
  v_b number;
begin  
  select count(distinct tablespace_name) into v_a from dba_data_files;
  dbms_output.put_line('系统拥有数据表空间数量: '||v_a);
  select  count(distinct tablespace_name)  into v_b from dba_temp_files;
  dbms_output.put_line('系统拥有临时表空间数量: '||v_b);
end;
/

declare
 str1 varchar2(1000);
 str2 varchar2(1000); 
 str3 varchar2(1000); 
 str4 varchar2(1000); 
 str5 varchar2(1000); 
 str6 varchar2(1000);   
 cursor c1 is 
   select tablespace_name,status,segment_space_management,extent_management from dba_tablespaces;
begin
     dbms_output.enable(1000000);
     str1:='.  ';
     str2:='.  ';
     str3:='.  ';
     str4:='.  ';
     str5:='.  ';
     str6:='.  ';
     for i in c1 loop
 	 if i.segment_space_management='AUTO' then
 	   str1:=str1||i.tablespace_name||' ';
 	 else
 	   str2:=str2||i.tablespace_name||' ';
 	 end if;
 	 if i.extent_management='LOCAL' then
 	   str3:=str3||i.tablespace_name||' ';
 	 else
 	   str4:=str4||i.tablespace_name||' ';
 	 end if;
 	 if i.status='ONLINE' then
 	   str5:=str5||i.status||' ';
 	 else
 	   str6:=str6||i.status||' ';
 	 end if;
     end loop;
     if str2='.  ' then
       dbms_output.put_line('数据表空间段管理模式全部为:  AUTO ');
     else
       dbms_output.put_line('  AUTO段管理模式的数据表空间:'||str1);
       dbms_output.put_line('非AUTO段管理模式的数据表空间:'||str2);
     end if;
     if str4='.  ' then
       dbms_output.put_line('数据表空间管理模式全部为:  LOCAL ');
     else
       dbms_output.put_line('  LOCAL管理模式的数据表空间:'||str3);
       dbms_output.put_line('非LOCAL管理模式的数据表空间:'||str4);
     end if;  
     if str6='.  ' then
       dbms_output.put_line('数据表空间状态全部为:  ONLINE ');
     else
       dbms_output.put_line(' ONLINE状态的数据表空间:'||str5);
       dbms_output.put_line('OFFLINE状态的数据表空间:'||str6);
     end if;
     
end;
/   
prompt
prompt ☆  结论：
prompt   具有空间分配风险的表空间(80%以上)： 
prompt   空间极度紧张的表空间(90%以上）： 
prompt   表空间设计： 合理 / 普通 / 不合理  
prompt
prompt ☆  建议：
prompt

prompt 4）数据文件 
prompt ______________________________________________________________
prompt
declare
 v_a number;
 v_b number;
 v_c number;
 v_d number;
 v_e number;
begin 
   select  count(*) into v_a from dba_data_files;
   select max(bytes)/1024/1024 into v_b from dba_data_files;
   select min(bytes)/1024/1024 into v_c from dba_data_files;
   select count(*)  into v_d from dba_data_files where autoextensible='YES';
   select count(*)  into v_e from dba_data_files where autoextensible='NO'; 
   dbms_output.put_line('系统中拥有数据文件数量：'||v_a); 
   dbms_output.put_line('系统中最大的数据文件大小为：'||v_b||' M');
   dbms_output.put_line('系统中最小的数据文件大小为：'||v_c||' M');
   dbms_output.put_line('系统中最自动扩张的数据文件为：'||v_d||' 个');
   dbms_output.put_line('系统中最非自动扩张的数据文件为：'||v_e||' 个');
end;
/
prompt
prompt  数据文件状态非ONLINE的列表如下： 
col file# format 999
col name format a40
col status format a7
SELECT file# ,name,status from sys.v$datafile where status !='ONLINE' and status !='SYSTEM';

declare
  num number;
begin
  select count(*) into num   from sys.v$datafile where status !='ONLINE' and status !='SYSTEM';
   if num = 0 then
    dbms_output.put_line(chr(10)); 
    dbms_output.put_line('      目前，数据库内不存在状态非ONLINE的数据文件。');
    dbms_output.put_line(chr(10)); 
  end if;
end;
/

--prompt
--prompt  分配大小超过4G的数据文件列表如下： 
--col file# format 999
--col name format a30
--col status format a7
--SELECT file# "File ID" ,name,trunc(bytes/1024/1024)||'(M)' "SIZE(M)",status 
-- from sys.v$datafile where bytes >(4*1024*1024*1024)
-- order by "SIZE(M)";
--
--declare
--  num number;
--begin
--  select count(*) into num  from sys.v$datafile where bytes >(4*1024*1024*1024);
--   if num = 0 then
--    dbms_output.put_line(chr(10)); 
--    dbms_output.put_line('      目前，数据库内不存在4G以上的数据文件。');
--    dbms_output.put_line(chr(10)); 
--  end if;
--end;
--/
--
--prompt
--prompt  数据文件的大小和使用率如下： 
--col file_id format 999
--col file_name format a40
--col tablespace_name format a15
--col status format a7
--SELECT  d.file_id "file_id",
--        d.file_name "file_name",
--        v.status "status", d.tablespace_name "tablespace",TO_CHAR(d.bytes / 1024 / 1024,'99999990') "alloc(M)", 
--        TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0)) / 1024 / 1024, 0),'99999990') "used(M)",
--        TO_CHAR((NVL(d.bytes - s.bytes, d.bytes) / d.bytes * 100),'990D00') "used%",
--        LPAD(NVL(f.autoextensible, 'NO'),6) "扩展" FROM sys.dba_data_files d,  v$datafile v, 
--        (SELECT file_id,SUM(bytes) bytes  FROM sys.dba_free_space   GROUP BY file_id) s,   
--        (select file#, 'YES' autoextensible  from sys.filext$) f   
--        WHERE s.file_id(+) = d.file_id AND d.file_name = v.name AND f.file#(+) = d.file_id
--        order by "used%" desc;
--    

prompt
prompt ☆  结论：
prompt   数据文件存放在 裸设备 / 文件系统 / asm / 混合   
prompt   数据文件设计： 合理 / 普通 / 不合理 ');
prompt ☆  建议：
prompt



prompt  5）日志文件 
prompt ______________________________________________________________
prompt
--begin
--  execute immediate 'drop table mccheckmc963.mccheckmc963_tmp10_t2';
--exception
--  when others then
--    if sqlcode=-942 then
--      null;
--    else
--      dbms_output.put_line(sqlcode);
--    end if;
--end;
--/
--create global temporary table  mccheckmc963.mccheckmc963_tmp10_t2 on commit preserve rows as
--select group#,member from v$logfile where rownum<1;
--
--declare
-- str1 varchar2(100);
-- cursor c1 is 
--   SELECT  distinct GROUP# FROM v$logfile ORDER BY GROUP#;
-- 
--begin
--  for i in c1 loop
--    str1:='';
--    for j in (select member from v$logfile where group#=i.group#) loop
--      str1:=str1||','||j.member;
--    end loop;
--    insert into mccheckmc963.mccheckmc963_tmp10_t2 values(i.group#,substr(str1,2));
--    commit;
--  end loop;
--end;
--/

prompt 日志文件的大小和配置如下： 
col MEMBER_NAME format a36
col GROUP# format 99
col THREAD# format 9
col logstatus format a10

SELECT  l.GROUP# GROUP# ,
        l.THREAD# THREAD#,
        l.SEQUENCE# SEQUENCE#,
        l.bytes bytes,
        l.members members,
        LPAD(l.archived,12) archived,
        NVL(l.status, 'null') logstatus,
        t.MEMBER MEMBER_NAME  
  FROM v$log l,v$logfile t WHERE l.GROUP#=t.GROUP#
  ORDER BY l.GROUP#, l.THREAD#;
  
 
declare
 v_a number;
 v_b varchar2(10); 
begin 
   select count(*),decode(count(*),2,'偏少',3,'一般','正常') into v_a,v_b from v$log;
   dbms_output.put_line('系统配置日志文件组数量:  '||v_a||'  '||v_b); 
end;
/
prompt
prompt ☆  结论：
prompt   日志文件存放在 裸设备 / 文件系统 / asm / 混合  
prompt   日志文件设计： 合理 / 普通 / 不合理 
prompt
prompt ☆  建议：
prompt


prompt  6）归档文件 
prompt ______________________________________________________________
prompt 
declare 
ac number;
sec_redo number;
day_redo number;
sec_redo_90 number;
day_redo_90 number;
str varchar2(100);
begin 
select count(*) into ac from v$database where log_mode='NOARCHIVELOG' ;
if ac=1 then
  dbms_output.put_line('数据库处于非归档模式下，没有归档日志信息');
else 
  str:=''; 
  for i in (select destination from v$archive_dest where status='VALID' and destination is not null) loop
    str:=str||','||i.destination;  
  end loop;
  dbms_output.put_line('归档目的地： '||substr(str,2));   
  select trunc(sum(blocks*block_size)/((max(first_time)-min(first_time))*24*3600)),
  trunc(sum(blocks*block_size)/((max(first_time)-min(first_time)))) into sec_redo,day_redo from v$archived_log;
  dbms_output.put_line('每秒日志产生频率:  '||sec_redo ||' (byte)');
  dbms_output.put_line('每天日志产生频率:  '||day_redo ||' (byte)');
  dbms_output.put_line('最近三个月统计数据：');
  select trunc(sum(blocks*block_size)/((max(first_time)-min(first_time))*24*3600)),
  trunc(sum(blocks*block_size)/((max(first_time)-min(first_time)))) into sec_redo_90,day_redo_90 from v$archived_log where first_time>sysdate-91;
  dbms_output.put_line('每秒日志产生频率:  '||sec_redo_90 ||' (byte)');
  dbms_output.put_line('每天日志产生频率:  '||day_redo_90 ||' (byte)');
end if;
end;
/
declare 
ac number;
begin 
select count(*) into ac from v$database where log_mode='ARCHIVELOG' ;
if ac=1 then
  dbms_output.put_line('最近一个月归档日志每日产生量如下:  ');
end if;
end;
/
select LPAD(to_char(first_time,'yyyymmdd'),12) "日期",
 trunc(sum(blocks*block_size)/1024/1024) "size(M)",count(*) 
 from sys.v$archived_log 
 where first_time >sysdate-31 group by LPAD(to_char(first_time,'yyyymmdd'),12)
 order by 1;

declare 
ac number;
begin 
select count(*) into ac from v$database where log_mode='ARCHIVELOG' ;
if ac=1 then
  dbms_output.put_line('最近一周归档日志24小时分时产生量如下:  ');
end if;
end;
/

select LPAD(to_char(first_time,'hh24'),4) "时刻点",
 trunc(sum(blocks*block_size)/1024/1024) "size(M)",count(*) 
from sys.v$archived_log 
where first_time >sysdate-7 group by to_char(first_time,'hh24') order by 1;

declare 
ac number;
begin 
select count(*) into ac from v$database where log_mode='ARCHIVELOG' ;
if ac=1 then
    dbms_output.put_line(chr(10)); 
    dbms_output.put_line('☆  结论：'); 
    dbms_output.put_line('   归档日志文件存放在  文件系统 / asm ');  
    dbms_output.put_line('   归档日志文件设计： 合理 / 普通 / 不合理 ');
end if;
end;
/
prompt ☆  建议：
prompt
    
prompt 7）闪回日志文件 
prompt ______________________________________________________________
prompt

begin
dbms_output.put_line('   9i数据库版本支持闪回查询，但没有闪回日志');
end;
/    
prompt

--declare
--v_a number;
--v_b number;
--v_c varchar2(30);
--v_d number;
--begin    
--   select count(*) into v_d from  v$flashback_database_log; 
--   if v_d > 0 then
--      select retention_target ,trunc(flashback_size/1024/1024),
--         to_char(OLDEST_FLASHBACK_TIME,'yyyy/mm/dd hh24:mi:ss') into v_a,v_b,v_c 
--         from v$flashback_database_log;    
--      dbms_output.put_line('数据库闪回的目标定义时间长度： '||v_a|| '  (分钟)');
--      dbms_output.put_line('当前的闪回日志数据总量:   '||v_b||'  (M)');
--      dbms_output.put_line('数据库可以支持的最小闪回时间： '||v_c);
--  else
--      dbms_output.put_line('   数据库内没有任何闪回日志文件存在');
--   end if;
--end;
--/    
 

    
prompt 8）临时段空间配置 
prompt ______________________________________________________________
prompt
 
declare
 v_a number;
 v_b number;
 v_c varchar2(30);
begin
  select count(distinct tablespace_name) into v_a from dba_temp_files;
  select count(distinct file_name) into v_b from dba_temp_files;
  select property_value into v_c from database_properties  
    where property_name=upper('default_temp_tablespace');
  dbms_output.put_line('临时表空间数量：       '||v_a); 
  dbms_output.put_line('临时文件数量：         '||v_b); 
  dbms_output.put_line('数据库缺省临时表空间:  '||v_c);     
end;
/


select file_name ,tablespace_name  ,bytes/1024/1024 "ALLOC(M)",
LPAD(AUTOEXTENSIBLE,10) "AUTOEXTENSIBLE" from dba_temp_files;
 
prompt ☆  结论：
prompt     临时段空间配置： 合理 / 普通 / 不合理 
prompt
prompt ☆  建议：
prompt



prompt  9）回滚段空间配置 
prompt ______________________________________________________________
prompt

--declare
-- v_a number;
-- v_b varchar2(30);
--begin
-- select sum(bytes)/1024/1024 into v_a from dba_data_files where tablespace_name in (
-- select distinct tablespace_name  from dba_rollback_segs v where status='ONLINE' and tablespace_name!='SYSTEM'
-- union
-- select distinct tablespace_name  from dba_undo_extents v  where status='ONLINE' and tablespace_name!='SYSTEM'
-- );
-- dbms_output.put_line('回滚表空间分配大小     ：    '||v_a||' (M)'); 
--end;
--/

prompt  系统回滚段表空间配置
select tablespace_name "回滚段表空间名",sum(bytes)/1024/1024 "大小(M)" from dba_data_files
where tablespace_name in (select tablespace_name from dba_tablespaces where contents='UNDO')
group by tablespace_name;

prompt  系统回滚表空间参数配置：
select inst_id,name,value from ( 
 select inst_id,name,value  
 from gv$parameter  where name in ('undo_management') and value is not null
 union
 select inst_id,name,value    
 from gv$parameter  where name in ('undo_tablespace') and value is not null 
 union 
 select inst_id,name,value    
 from gv$parameter  where name in ('undo_retention') and value is not null)
 order by inst_id,name;
 
prompt 
prompt 回滚段扩展重新被使用时间
column explain format a53
column explain heading "回滚段扩展重新被使用时间 ..."
column hours format 9999999 heading "小时"
column minutes heading "分"

select
  null explain,
  trunc(24 * (sysdate - i.startup_time) / v.cycles)  hours,
  trunc(1440 * (sysdate - i.startup_time) / v.cycles)  minutes
from
  sys.v_$instance  i,
  ( select
      max(
	(r.writes + 24 * r.gets) /			-- bytes used /
	nvl(least(r.optsize, r.rssize), r.rssize) *	-- segment size
	(r.extents - 1) / r.extents			-- reduce by 1 extent
      )  cycles
    from
      sys.v_$rollstat  r
    where
      r.status = 'ONLINE' 
  )  v
/  



prompt ☆ 说明：
prompt    系统参数undo_retention目前配置为xxx小时，而目前系统归滚段的extent重新被利用的平均时间为xxx。
prompt  ☆建议：
prompt	  为了确保回滚段能达到保留指定时间，建议适当增加回滚表空间大小。
prompt


prompt
prompt  10）大型表格 
prompt ______________________________________________________________
prompt
col owner format a10
col segment_name format a25
col tablespace  format a12
col segment_type format a13
col extents format 9999
prompt 大型表格是数据库空间管理和性能管理的关键和难题所在。
declare
 v_a number;
 v_b number;
 v_c varchar2(30);
begin
  select count(*) into v_a from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK');
  select sum(bytes)/1024/1024 into v_b from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK');
  select trunc((select sum(bytes) from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK'))*100/
               (select sum(bytes) from dba_segments where owner not in('SYSTEM','SYS','DBCHECK')))  into v_c from dual;
  dbms_output.put_line('目前数据库除system以外拥有表格:'||v_a||' 张'); 
  dbms_output.put_line('目前数据库除system以外表格占用空间:'||v_b||' MB'); 
  dbms_output.put_line('目前数据库除system以外表格空间占用比率为:  '||v_c||' %');     
end;
/

prompt
prompt 以下为系统中最大的20张表格： 

select owner,LPAD(segment_type,12) SEGMENT_TYPE,tablespace_name TABLESPACE,segment_name,bytes/1024/1024 "SIZE(M)" from 
 (select owner,SEGMENT_NAME,TABLESPACE_NAME,SEGMENT_TYPE,bytes  
  from dba_segments order by bytes desc) 
  where segment_type like 'TABLE%' and rownum<21　
 ;

prompt
prompt 以下为系统3个月来增长最快的20张业务用户表格：
select owner,LPAD(segment_type,12) SEGMENT_TYPE,tablespace_name TABLESPACE,segment_name,old/1024/1024 "old(M)",now/1024/1024 "now(M)",bytes/1024/1024 "added SIZE(M)" from 
 (select a.owner,a.SEGMENT_NAME,a.TABLESPACE_NAME,a.SEGMENT_TYPE,NVL(b.bytes,null) old,a.bytes now,(a.bytes-NVL(b.bytes,0)) bytes  
  from dba_segments a left outer join (select table_name,bytes,owner from mc$segment_space where to_char(key_date,'yyyymmdd')=to_char(sysdate-90,'yyyymmdd')) b
  on a.segment_name=b.table_name and a.owner=b.owner
  where a.owner not in (select username from mc$system_user)
  order by bytes desc) 
  where segment_type like 'TABLE%' and rownum<21　
 ;
prompt 注：old(M)为空代表该表为最近的新表或当时还未进行巡检部署

prompt
prompt ☆  建议：
prompt     加强大型表格的管理，包括空间扩展，访问分析以及索引分布等等。



prompt
prompt 11）大型索引 
prompt ______________________________________________________________
prompt
col owner format a10
col segment_name format a25
col tablespace_name format a12
col segment_type format a12
col extents format 9999
prompt 大型索引总是和大型表格半生的，大型表格总是产生大型的索引。
prompt 原则上索引规模应该比相关的表格规模要小，比表格更大的索引可能意味着不当的空间管理策略。
declare
 v_a number;
 v_b number;
 v_c varchar2(30);
begin
  select count(*) into v_a from dba_segments where segment_type like 'INDEX%' and owner not in('SYSTEM','SYS','DBCHECK');
  select sum(bytes)/1024/1024 into v_b from dba_segments where segment_type like 'INDEX%' and owner not in('SYSTEM','SYS','DBCHECK');
  select trunc((select sum(bytes) from dba_segments where segment_type like 'INDEX%' and owner not in('SYSTEM','SYS','DBCHECK'))*100/
               (select sum(bytes) from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK')))  into v_c from dual;
  dbms_output.put_line('目前数据库除system以外拥有索引:'||v_a||' 张'); 
  dbms_output.put_line('目前数据库除system以外索引占用空间:'||v_b||' MB'); 
  dbms_output.put_line('目前数据库除system以外索引空间与表格空间比率为:  '||v_c||' %');     
end;
/

prompt
prompt 以下为系统中最大的20张索引：  

select owner,LPAD(segment_type,12) SEGMENT_TYPE,tablespace_name TABLESPACE,segment_name,bytes/1024/1024 "SIZE(M)" from 
 (select owner,SEGMENT_NAME,TABLESPACE_NAME,SEGMENT_TYPE,bytes 
  from dba_segments order by bytes desc) 
  where segment_type like 'INDEX%' and rownum<21　
  order by bytes desc,owner,segment_type;
prompt 　
prompt ☆  建议：
prompt         1、加强大型索引的管理，包括空间扩展，访问分析以及和表格的空间比较。
prompt         2、对于一些频繁进行 update和delete的大型索引进行定期重新创建。
prompt
prompt



prompt 12）即将扩展失败的对象 
prompt ______________________________________________________________
prompt    对象扩展失败将会使业务中断，特别是大型事务的失败将造成比较大的影响。需要定期检查即将扩展失败的对象，
prompt    使空间失败的状况可以预先被排除。
select dt.owner||'.'||dt.table_name "TABLE_NAME",'TABLE' "TYPE", dt.next_extent,
       dt.pct_increase,df.max_free,dt.tablespace_name 
       from dba_tables dt,
       (select tablespace_name,max(bytes) max_free from dba_free_space group by tablespace_name) df
       where dt.tablespace_name = df.tablespace_name 
       and dt.next_extent > df.max_free
union
select di.owner||'.'||di.index_name,'INDEX' "TYPE",di.next_extent,
       di.pct_increase,df.max_free,di.tablespace_name 
       from dba_indexes di,
       (select tablespace_name,max(bytes) max_free from dba_free_space group by tablespace_name) df
       where di.tablespace_name = df.tablespace_name 
       and di.next_extent > df.max_free

prompt ☆  建议：
prompt


prompt 13）Maxextents限制
prompt ______________________________________________________________
prompt    即将达到maxextents限制的对象达到maxextents对象将使业务无法继续，需要确保表格不会达到maxextents限制。
declare
  num number;
begin
  select count(*) into num from dba_segments where max_extents-extents < 5 and max_extents <> 0;
  if num = 0 then
    dbms_output.put_line('     目前系统不存在即将达到maxextents限制的对象。');
  end if;
end;
/
select owner||'.'||segment_name "SEGMENT_NAME",segment_type,extents,max_extents from dba_segments
  where max_extents-extents < 5 and max_extents <> 0;

prompt ☆  建议：
prompt

prompt
prompt   █数据库碎片
prompt  
prompt  1）表空间碎片
prompt ______________________________________________________________
prompt   如果所有表格和索引都采用表空间的存储参数设置，表空间碎片将不会产生任何威胁，
prompt   建议表空间采用extent统一大小进行管理，10g采用LOCAL管理。
    select tablespace_name,count(*) "碎片" from dba_free_space
    group by tablespace_name
    having count(*)>1000;
prompt ☆  建议：
prompt    
prompt
prompt  2）行迁移的表格 
prompt ______________________________________________________________
prompt
declare
  num number;
begin
  select count(*) into num from dba_tables where chain_cnt>0;
  if num = 0 then
    dbms_output.put_line('没有发现存在行迁移的表格。');
  end if;
end;
/
 select owner,table_name,chain_cnt,blocks,NUM_ROWS from dba_tables where chain_cnt>0;

prompt ☆  结论：
prompt 
prompt ☆  建议：
prompt

prompt
prompt   █对象管理
prompt
prompt 1）SYSTEM表空间内的业务数据 
prompt ______________________________________________________________
prompt  SYSTEM表空间内原则上不应该存放业务数据。 

select  owner,segment_name,LPAD(segment_type,12) "SEGMENT_TYPE",bytes from dba_segments
  where tablespace_name='SYSTEM' and owner not in(
      'ANONYMOUS','BI','CTXSYS','DBSNMP','DIP','DMSYS','EXFSYS','HR','IX','LBACSYS',
      'MDDATA','MDSYS','MGMT_VIEW','OE','OLAPSYS','ORDPLUGINS','ORDSYS',
      'OUTLN','PM','SCOTT','SH','SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM','WMSYS',
      'WKPROXY','WK_TEST','WKSYS','XDB');

declare
  num number;
begin
  select  count(segment_name) into num from dba_segments
     where tablespace_name='SYSTEM' and owner not in(
      'ANONYMOUS','BI','CTXSYS','DBSNMP','DIP','DMSYS','EXFSYS','HR','IX','LBACSYS',
      'MDDATA','MDSYS','MGMT_VIEW','OE','OLAPSYS','ORDPLUGINS','ORDSYS',
      'OUTLN','PM','SCOTT','SH','SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM','WMSYS',
      'WKPROXY','WK_TEST','WKSYS','XDB');
  if num = 0 then
    dbms_output.put_line('    目前，数据库中SYSTEM表空间内不存在业务数据对象。');
  end if;
end;
/
prompt
prompt 2）表空间与对象位置 
prompt ______________________________________________________________
prompt
prompt 表空间内存放的对象分布如下： 
 select b.tablespace_name "TABLESPACE",LPAD(segment_type,12) "SEGMENT_TYPE",count(*) from dba_segments a,
 dba_tablespaces b where a.tablespace_name=b.tablespace_name and a.tablespace_name !='SYSTEM'
 group by b.tablespace_name,segment_type
 union
 select tablespace_name ,'--',0 from dba_tablespaces 
 where tablespace_name not in 
 (select distinct tablespace_name from dba_segments);
prompt

prompt ☆  建议：
prompt
prompt 3）无效对象 
prompt ______________________________________________________________
prompt  最近一个月有修改的无效的对象监控,如果存在无效对象请运行utlrp.sql，然后再次运行该脚本，查看是否还有无效对象，如果继续存在，评估是否正常。
column owner format a10 
column object_name format a35 
column object_type format a10 
column created format a10 

  Select Owner, Object_Name, Object_Type, Created, Last_DDL_Time
   From Sys.DBA_Objects
   Where Status = 'INVALID'
   and last_ddl_time>sysdate-30
    Order By Owner, Object_Type
/


prompt 4) 稀疏表格
prompt ______________________________________________________________
prompt  稀疏表格是指表格的空间利用不够充分，稀疏表格浪费空间并且影响性能，建议在适当的时间进行重新创建。
column table_name format a40
column degree heading " DEGREE"
column density heading "   DATA|DENSITY"
column new_free format 99 heading "SUGGEST|PCTFREE"
column new_used format 99 heading "SUGGEST|PCTUSED"
column reads_wasted format 999999 heading "MBREADS|TO SAVE"

select /*+ ordered */
  u.name ||'.'|| o.name  table_name,
  lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree, 1)), 7)  degree,
  substr(
    to_char(
      100 * t.rowcnt / (
        floor((p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11))
        * t.blkcnt
      ),
      '999.00'
    ),
    2
  ) ||
  '%'  density,
  1  new_free,
  99 - ceil(
    ( 100 * ( p.value - 66 - t.initrans * 24 -
          greatest(
            floor(
              (p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11)
            ) - 1,
            1
          ) * greatest(t.avgrln + 2, 11)
      )
      / (p.value - 66 - t.initrans * 24)
    )
  )  new_used,
  ceil(
    ( t.blkcnt - t.rowcnt /
      floor((p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11))
    ) / m.value
  )  reads_wasted
from
  sys.tab$  t,
  ( select
      value
    from
      sys.v_$parameter
    where
      name = 'db_file_multiblock_read_count'
  )  m,
  sys.obj$  o,
  sys.user$  u,
  (select value from sys.v_$parameter where name = 'db_block_size')  p
where
  t.tab# is null and
  t.blkcnt > m.value and
  t.chncnt = 0 and
  t.avgspc > t.avgrln and
  ceil(
    ( t.blkcnt - t.rowcnt /
      floor((p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11))
    ) / m.value
  ) > 0 and
  o.obj# = t.obj# and
  o.owner# != 0 and
  u.user# = o.owner#
order by
  5 desc, 2
/

prompt
prompt ☆  建议：
prompt         1、重新创空间节约比较高的或者利用率相当低的表格。
prompt         2、如果确认不会引起什么行迁移则以建议的PCTFREE执行，同样如果空间非常紧张，为了充分利用空间可以以附件中建议的pctused参数创建。

prompt
prompt 5) 稀疏索引
prompt ______________________________________________________________
prompt  稀疏索引浪费空间并且影响性能。索引比较表格更加容易被创建。
column index_name format a59

select /*+ ordered */
  u.name ||'.'|| o.name  index_name,
  substr(
    to_char(
      100 * i.rowcnt * (sum(h.avgcln) + 11) / (
        i.leafcnt * (p.value - 66 - i.initrans * 24) 
      ),
      '999.00'
    ),
    2
  ) || '%'  density,
  floor((1 - i.pctfree$/100) * i.leafcnt -
    i.rowcnt * (sum(h.avgcln) + 11) / (p.value - 66 - i.initrans * 24)
  ) extra_blocks
from
  sys.ind$  i,
  sys.icol$  ic,
  sys.hist_head$  h,
  ( select
      kvisval  value
    from
      sys.x$kvis
    where
      kvistag = 'kcbbkl' )  p,
  sys.obj$  o,
  sys.user$  u
where
  i.leafcnt > 1 and
  i.type# in (1,4,6) and		-- exclude special types
  ic.obj# = i.obj# and
  h.obj# = i.bo# and
  h.intcol# = ic.intcol# and
  o.obj# = i.obj# and
  o.owner# != 0 and
  u.user# = o.owner#
group by
  u.name,
  o.name,
  i.rowcnt,
  i.leafcnt,
  i.initrans, 
  i.pctfree$,
  p.value
having
  50 * i.rowcnt * (sum(h.avgcln) + 11) 
  < (i.leafcnt * (p.value - 66 - i.initrans * 24)) * (50 - i.pctfree$) and
  floor((1 - i.pctfree$/100) * i.leafcnt -
    i.rowcnt * (sum(h.avgcln) + 11) / (p.value - 66 - i.initrans * 24)
  ) > 0
order by
  3 desc, 2
/
prompt
prompt ☆  建议：
prompt         1、重新稀疏索引。

prompt
prompt 6）回收站内的对象 
prompt ______________________________________________________________
prompt
prompt 9i数据库没有recyclebin，回收站为10g的新特性，以支持闪回操作。

--declare
--   v_a number;
--begin
--  select sum(space) into v_a from dba_recyclebin;
--  dbms_output.put_line('回收站内的对象占用总空间如下：  '||v_a||'  blocks');
--end;
--/
--
--prompt 回收站内的最大30个对象分布如下：  
--
--select owner,object_name,original_name, type,
--   ts_name,operation,droptime,LPAD(can_purge,6) "可清理",space "blocks" 
-- from (select owner,object_name,original_name,partition_name,type,
--   ts_name,operation,droptime,can_purge,space from dba_recyclebin order by space desc)
-- where rownum<31;
  


prompt 
prompt 
prompt █安全管理    
prompt 1）新增用户 
prompt ______________________________________________________________
prompt
prompt 最近三个月内的新用户如下： 
select username,default_tablespace,to_char(created,'yyyy-mm-dd hh24:mi:ss') created 
from dba_users where created > sysdate-92 and username != 'MCCHECKMC963';

prompt
prompt ☆  结论：
prompt
prompt ☆  建议：
prompt


prompt 2）缺省表空间指向SYSTEM的非系统用户 
prompt ______________________________________________________________
prompt
prompt SYSTEM表空间是ORACLE存放数据字典使用的，无论从空间分配还是性能考虑，都不应该把非系统用户指向SYSTEM表空间，数据库内缺省指向SYSTEM表空间的非系统用户如下： 
select username,'缺省表空间为SYSTEM. ' default_tablespace
 from dba_users where  default_tablespace='SYSTEM' and 
   username not in (
      'ANONYMOUS','BI','CTXSYS','DBSNMP','DIP','DMSYS','EXFSYS','HR','IX','LBACSYS',
      'MDDATA','MDSYS','MGMT_VIEW','OE','OLAPSYS','ORDPLUGINS','ORDSYS',
      'OUTLN','PM','SCOTT','SH','SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM','WMSYS',
      'WKPROXY','WK_TEST','WKSYS','XDB','MCCHECKMC963');
declare
  num number;
begin
  select count(username) into num  from dba_users where 
    default_tablespace='SYSTEM' and 
      username not in (
      'ANONYMOUS','BI','CTXSYS','DBSNMP','DIP','DMSYS','EXFSYS','HR','IX','LBACSYS',
      'MDDATA','MDSYS','MGMT_VIEW','OE','OLAPSYS','ORDPLUGINS','ORDSYS',
      'OUTLN','PM','SCOTT','SH','SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM','WMSYS',
      'WKPROXY','WK_TEST','WKSYS','XDB','MCCHECKMC963');
  if num = 0 then
    dbms_output.put_line('目前，数据库内不存在类似的用户。');
  end if;
end;
/
 
prompt
prompt ☆  结论：
prompt
prompt ☆  建议：
prompt


prompt 3）显示用户名和密码相同的用户 
prompt ______________________________________________________________
prompt
prompt 目前系统中口令太简单的用户如下： 
set serveroutput on
declare
     hexpw varchar2(30);
     modpw varchar2(30);
     un varchar2(30);
     v_st varchar2(30);
     cursor c2 is select username,password,account_status 
     from dba_users 
     where username not in('MCCHECKMC963','SYS','SYSTEM','SYSMAN','MCCHECKMC963','DRB','DBCHECK') order by account_status desc;
begin
   for i in c2 loop
 	 hexpw := i.password;
 	 un := i.username;
 	 v_st := i.account_status;
 	 execute immediate 'alter user '||un||' identified by '||un;
 	 select password into modpw from dba_users where username = un;
 	 if modpw = hexpw then
	    dbms_output.put_line(rpad(un,15,'.')||' password is '||rpad(un,15,'.')||'-- status is '||v_st);
         else
   	    execute immediate 'alter user '||un||' identified by values '''||hexpw||'''';
	 end if;
    end loop;
end;
/
prompt
prompt ☆  结论：
prompt
prompt ☆  建议：
prompt

prompt 4）DBA权限管理 
prompt ______________________________________________________________

prompt 目前系统中拥有DBA等大权限的用户如下： 

declare
  num number;
begin
  select count(*) into num  from dba_role_privs
  where granted_role in( 'DBA','IMP_FULL_DATABASE') 
   and grantee not in('SYS','SYSTEM','DBA');
  if num = 0 then
    dbms_output.put_line('数据库内不存在DBA权限和IMP_FULL_DATABASE权限的用户或角色。');
  end if;
end;
/
col grantee format a20
col granted_role format a20 
 select a.grantee,granted_role,lpad(a.admin_option,6) "可传递",lpad(a.default_role,6) "缺省角色",b.account_status "账号状态"
 from dba_role_privs a,dba_users b
 where a.grantee=b.username and
 granted_role in( 'DBA','IMP_FULL_DATABASE') 
 and grantee not in('SYS','SYSTEM','DBA');
 
prompt ☆  结论：
prompt
prompt ☆  建议：
prompt


prompt 5）ANY权限管理 
prompt ______________________________________________________________
prompt     尽管ANY权限比DBA权限稍微安全一些，但是它能访问任何别的表格数据，考虑到数据的保密性和重要性，不应该随便赋予ANY权限。目前系统中拥有any等大权限的用户如下： 
prompt
declare
  num number;
begin
  select count(*) into num from dba_sys_privs    
  where privilege in('DELETE ANY TABLE','INSERT ANY TABLE','UPDATE ANY TABLE','SELECT ANY TABLE') 
 and grantee not in('DBA','IMP_FULL_DATABASE','SYS','EXP_FULL_DATABASE');
  if num = 0 then
    dbms_output.put_line('数据库内不存在权限DELETE ANY TABLE、INSERT ANY TABLE、UPDATE ANY TABLE、SELECT ANY TABLE的用户或角色。');
  end if;
end;
/
col grantee format a20
col granted_role format a20 

col privilege format a24  
select a.grantee,a.PRIVILEGE,lpad(a.ADMIN_OPTION,12) "ADMIN_OPTION",b.account_status "账号状态"
 from dba_sys_privs a,dba_users b                                     
 where  a.grantee=b.username and
 a.privilege in('DELETE ANY TABLE','INSERT ANY TABLE','UPDATE ANY TABLE','SELECT ANY TABLE') 
 and a.grantee not in('DBA','IMP_FULL_DATABASE','SYS','EXP_FULL_DATABASE');
 
prompt ☆  结论：
prompt
prompt ☆  建议：
prompt

prompt 
prompt █操作系统配置和监控
prompt 1）操作系统CPU使用情况
prompt ______________________________________________________________
prompt     系统配置xx颗CPU。一天内平均CPU的使用率为xx% 
prompt     以下为一天中CPU使用率的时分图，在业务高峰期（xx：00-xx：00）CPU使用率在xx%以上。
   select inst_id,to_char(key_date,'HH24') as "HH",
          round(avg(cusr+csys),2) "USED %",
          round(avg(cidle),2) "IDLE %"
   from  mc$oscpu where key_date>sysdate-7
   group by inst_id,to_char(key_date,'HH24') order by 1,2;
prompt
prompt     以下为CPU日平均图
   select inst_id,to_char(key_date,'YYYY-MM-DD') "日期",
          round(avg(cusr+csys),2) "USED %",
          round(avg(cidle),2) "IDLE %"
   from  mc$oscpu where key_date>sysdate-7
   group by inst_id,to_char(key_date,'YYYY-MM-DD') order by 1,2;
prompt
prompt 2）操作系统内存使用情况
prompt ______________________________________________________________
prompt    系统配置内存XXX(GB)，一天平均内存空闲为XXX(MB)
select inst_id,to_char(key_date,'yyyymmdd') "日期",trunc(avg(fmem*4)/1024) "MB" from mc$osmem group by  inst_id,to_char(key_date,'yyyymmdd')
order by 1,2;
prompt 
prompt 3) 操作系统DISK I/O
prompt ______________________________________________________________
prompt     以下为一天内平均DISK I/O等待情况
   select inst_id,to_char(key_date,'HH24') "HH",
          round(avg(cwio),2) "wio %"
   from  mc$oscpu where key_date>sysdate-7
   group by inst_id,to_char(key_date,'HH24') order by 1,2;




prompt
prompt 其他信息
prompt
prompt    
prompt 显示包执行次数
column stored_object format a61

select /*+ ordered use_hash(d) use_hash(c) */
  o.kglnaown||'.'||o.kglnaobj  stored_object,
  sum(c.kglhdexc)  sql_executions
from
  sys.x$kglob  o,
  sys.x$kglrd  d,
  sys.x$kglcursor  c
where
  o.inst_id = userenv('Instance') and
  d.inst_id = userenv('Instance') and
  c.inst_id = userenv('Instance') and
  o.kglobtyp in (7, 8, 9, 11, 12) and
  d.kglhdcdr = o.kglhdadr and
  c.kglhdpar = d.kglrdhdl
group by
  o.kglnaown,
  o.kglnaobj
order by sql_executions
/

prompt
prompt 显示高负载SQL
prompt This script shows SQL statement that account for more than
prompt a certain percentage of disk reads.
prompt

column executes format 9999999
break on load on executes
define Percent=2.5

select
  substr(to_char(s.pct, '99.00'), 2) || '%'  load,
  s.executions  executes,
  p.sql_text
from
  ( 
    select
      address,
      disk_reads,
      executions,
      100 * ratio_to_report(disk_reads) over ()  pct
    from
      sys.v_$sql
    where
      command_type != 47
  )  s,
  sys.v_$sqltext  p
where
  s.pct > &Percent and
  s.disk_reads > 50 * s.executions and
  p.address = s.address
order by
  1, s.address, p.piece
/


prompt     
prompt 活动事务数量
  select to_char(key_date,'YYYY-MM-DD') "DATE",
  	      round(avg(active_trans)) "AVG"
     from  mc$session
     group by to_char(key_date,'YYYY-MM-DD')
     order by 1;

prompt      
prompt 活动事务十分图
    select to_char(key_date,'HH24') "DATE",
  	      round(avg(active_trans)) "AVG"
     from mc$session
     group by to_char(key_date,'HH24')
     order by 1;

prompt     
prompt CPU使用状况
   select inst_id,to_char(key_date,'YYYYMMDD') "DATE",
          round(avg(cusr+csys),2) "LOAD",
          round(avg(runp),2) "PROCS"
   from mc$oscpu
   group by inst_id,to_char(key_date,'YYYYMMDD')
   order by 1,2;
   
prompt   
prompt CPU使用状况时分图
   select inst_id,to_char(key_date,'HH24') "DATE",
          round(avg(cusr+csys),2) "USED %",
          round(avg(runp),2) "PROCS"
   from mc$oscpu
   group by inst_id,to_char(key_date,'HH24')
   order by 1,2;
   
prompt   
prompt CPU使用平均每天
      select inst_id,to_char(key_date,'YYYYMMDD') "HOUR",
    	      round(avg(cusr+csys)) "used",
    	      round(avg(cidle)) "cidle",
    	      round(avg(cwio)) "cwio",
    	      round(avg(runp)) "crunp"
     from mc$oscpu
     group by inst_id,to_char(key_date,'YYYYMMDD')
     order by 1,2;

prompt
prompt CPU使用时份图
      select inst_id,to_char(key_date,'HH24') "HOUR",
    	      round(avg(cusr+csys)) "used",
    	      round(avg(cidle)) "cidle",
    	      round(avg(cwio)) "cwio",
    	      round(avg(runp)) "crunp"
     from mc$oscpu
     group by inst_id,to_char(key_date,'HH24')
     order by 1,2;

prompt   
prompt 系统负载状况   
   select inst_id,to_char(key_date,'YYYYMMDD') "DATE",
          round(avg(uptime),2) "Uptime"
   from mc$osprocs 
   group by inst_id,to_char(key_date,'YYYYMMDD')
   order by inst_id,to_char(key_date,'YYYYMMDD');
   
prompt   
prompt 系统负载状况(时分图） 
   select inst_id,to_char(key_date,'HH24') "DATE",
          round(avg(uptime),2) "Uptime"
   from mc$osprocs 
   group by inst_id,to_char(key_date,'HH24')
   order by inst_id,to_char(key_date,'HH24');   
   
prompt   
prompt 会话（平均每天会话）
   select to_char(key_date,'YYYYMMDD') "HOUR",
    	      round(avg(active_session)) "AVG_SESSION"
      from mc$session where key_date>sysdate-7
      group by to_char(key_date,'YYYYMMDD')
      order by 1;   
      
prompt
prompt  会话时分图
   select to_char(key_date,'HH24') "HOUR",
    	      round(avg(active_session)) "AVG_SESSION"
      from mc$session where key_date>sysdate-7
      group by to_char(key_date,'HH24')
      order by 1;

prompt
prompt 显示version_count位图
column version_count format a20

select
  to_char(min(v)) ||
  decode(
    max(v) - min(v),
    0, null,
    ' to ' || to_char(max(v))
  )  version_count,
  count(*)  cursors
from
  (
    select
      count(*)  v
    from
      sys.x$kglcursor
    where
      inst_id = userenv('Instance') and
      kglhdadr != kglhdpar
    group by
      kglhdpar,
      kglnahsh
  )
group by
  trunc(round(log(2, v), 37))
/    
    
prompt
prompt 表空间信息
select * from (
SELECT  d.tablespace_name  "TABLESPACE",d.status "STATUS",
        d.extent_management "EXT_MGT",
        d.segment_space_management "段管理", d.contents "CONTENTS",/*d.RETENTION "RETENTION",*/
        TO_CHAR(NVL(trunc(a.bytes / 1024 / 1024), 0),'99G999G990') "ALLOC(M)",
        TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0) / 1024 / 1024 ,'99G999G990') "USED(M)",
        TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0),'990D00') "USED%",
        TO_CHAR(NVL(trunc(f.largest_free / 1024 / 1024), 0),'99G999G990') "最大空闲(M)"  
        FROM sys.dba_tablespaces d,
        (SELECT tablespace_name,SUM(bytes) bytes   FROM dba_data_files  GROUP BY tablespace_name) a,
        (SELECT tablespace_name,SUM(bytes) bytes, MAX(bytes) largest_free   FROM dba_free_space   GROUP BY tablespace_name) f  
        WHERE d.tablespace_name = a.tablespace_name   AND d.tablespace_name = f.tablespace_name(+)
        )
    order by "USED%" desc
/

prompt
prompt  数据文件信息 
col file_id format 999
col file_name format a40
col tablespace_name format a15
col status format a7
SELECT  d.file_id "file_id",
        d.file_name "file_name",
        v.status "status", d.tablespace_name "tablespace",TO_CHAR(d.bytes / 1024 / 1024,'99999990') "alloc(M)", 
        TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0)) / 1024 / 1024, 0),'99999990') "used(M)",
        TO_CHAR(d.MAXBYTES / 1024 / 1024,'99G999G990') "MAXBYTES(M)",
        LPAD(NVL(f.autoextensible, 'NO'),6) "扩展" FROM sys.dba_data_files d,  v$datafile v, 
        (SELECT file_id,SUM(bytes) bytes  FROM sys.dba_free_space   GROUP BY file_id) s,   
        (select file#, 'YES' autoextensible  from sys.filext$) f   
        WHERE s.file_id(+) = d.file_id AND d.file_name = v.name AND f.file#(+) = d.file_id
        order by "MAXBYTES(M)" desc;

prompt
prompt 所有无效对象
col owner format a10 
col object_name format a35 
col object_type format a12 
col created format a20   
select owner,object_type, to_char(created,'yyyy-mm-dd') created,to_char(last_ddl_time,'yyyy-mm-dd/hh24:mi:ss') last_ddl_time,object_name 
   from sys.dba_objects
   where status = 'INVALID'
    order by owner, object_type;

prompt
prompt 巡检日数据库非系统用户信息
prompt 没有拥有数据量并不代表不含有存储过程或触发器、同义词等，在dba_objects中可以查到相关信息
prompt ORACLE_OCM用户在10g升级过程中出现，11g的系统用户
col "用户" format a20
col "账户状态" format a10
col "创建时间" format 9999999999999999
col "默认temp" format a10
col "拥有数据量(MB)" format 99999999990.99
select a.USERNAME "用户",a.ACCOUNT_STATUS "账户状态",a.created "创建时间",a.TEMPORARY_TABLESPACE "默认temp",sum(b.bytes)/1024/1024 "拥有数据量(MB)"
from dba_users a left outer join dba_segments b on a.username=b.owner 
where a.username not in (select username from mc$system_user)
--where a.username not in ('OUTLN','DIP','TSMSYS','WMSYS','EXFSYS','DMSYS','CTXSYS','ANONYMOUS','XDB','MDSYS','ORDPLUGINS','ORDSYS','SI_INFORMTN_SCHEMA','OLAPSYS','MDDATA','SYS','SYSTEM','DBSNMP','MGMT_VIEW','SYSMAN')
group by a.USERNAME,a.ACCOUNT_STATUS,a.created,a.TEMPORARY_TABLESPACE
order by a.account_status,a.created;

prompt 非系统用户对应使用表空间数据量
select a.USERNAME "用户",a.default_tablespace "默认表空间",b.tablespace_name "使用表空间",sum(b.bytes)/1024/1024 "拥有数据量(MB)"
from dba_users a join dba_segments b on a.username=b.owner 
where a.username not in ('OUTLN','DIP','TSMSYS','WMSYS','EXFSYS','DMSYS','CTXSYS','ANONYMOUS','XDB','MDSYS','ORDPLUGINS','ORDSYS','SI_INFORMTN_SCHEMA','OLAPSYS','MDDATA','SYS','SYSTEM','DBSNMP','MGMT_VIEW','SYSMAN')
group by a.USERNAME,a.default_tablespace,b.tablespace_name;

    
spool off
 
exit
