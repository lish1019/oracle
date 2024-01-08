
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
----�Ƿ��½��û���
----�س��� ��ʾ����
----ctrl-c���ж��˳�
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

--��ʼ������ݣ���ʽhtm����ĳЩ�����ϣ����ʺ���htm��ʽ�鿴������ע����
set markup html on entmap on
spool dbcheck.htm

declare
 v_t varchar2(30); 
begin 
   select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') into v_t from dual;
   dbms_output.put_line('��Ѳ��ʱ��:  '||v_t||'' ); 
end;
/

prompt
prompt ��ORACLE���ݿ�����   
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
 rpad('��ռ�������',30) name, to_char(count(*)) value 
 from dba_tablespaces
 union
 select '999-' inst_id,34 id,
 rpad('������ʱ��ռ�������',30) name, 
 to_char(count(distinct tablespace_name)) value 
 from dba_temp_files
 union
 select '999-' inst_id,35 id,
 rpad('�����ļ�������',30) name,
 to_char(count(*)) value 
 from dba_data_files
 union                                
 select '999-' inst_id,36 id,
 rpad('��ʱ�ļ�������',30) name,to_char(count(*)) value 
 from dba_temp_files
 union                                
 select '999-' inst_id,37 id,
 rpad('�����ļ�������',30) name,to_char(count(*)) value 
 from v$controlfile
 union                                
 select '999-' inst_id,38 id,rpad('��־�ļ�������',30) name,
 to_char(count(*)) value 
 from v$log 
 union
 select '999-' inst_id,39 id,rpad('��ʱ��ռ��С',30) name,
 to_char(trunc(sum(bytes)/1024/1024))||'M' value 
 from dba_temp_files
 union
 select '999-' inst_id,40 id,rpad('UNDO��ռ��С',30) name,
 to_char(trunc(sum(bytes)/1024/1024))||'M'  value from dba_data_files 
  where  tablespace_name in 
  (select tablespace_name 
  from dba_tablespaces where contents='UNDO')
 union
 select '999-' inst_id,41 id,
 rpad('�� '||group#||' ����־�ļ�;'||'��Ա����: '||members||'��',30) name,
 '  ��С: '||to_char(trunc(bytes/1024/1024))||'(M)' value 
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

prompt ����Դ����    
prompt  ______________________________________________________________ 
prompt

prompt 1�����ݿ���Դ 
prompt ______________________________________________________________
prompt
 select RESOURCE_NAME "����",
        CURRENT_UTILIZATION "��ǰֵ",
        MAX_UTILIZATION "��ʹ�����ֵ",
        INITIAL_ALLOCATION "���������ֵ",
        LIMIT_VALUE "�������ֵ" 
        from v$resource_limit; 
prompt ��  ���ۣ�
prompt  
prompt ��  ���飺
prompt  

prompt 2�����ݿ⸺�� 
prompt ______________________________________________________________
prompt

select inst_id "INSTANCE ID",
 status,
 count(*) "SESSION NUMBER" 
 from gv$session 
 group by inst_id,status 
 order by 1,2;
prompt
prompt ��  ���ۣ�
prompt  
prompt ��  ���飺
prompt       
       
prompt ���ռ����  
prompt
prompt1������ϵͳ
prompt ______________________________________________________________
prompt ϵͳ����ΪXXXX������XXX�洢������Ϊ�ļ�ϵͳ�ռ�ʹ�������
      select inst_id,fsname "��ռ���",total "�ܿռ䣨K��",free "ʣ��ռ�(K)",trunc((total-free)*100/total) "ʹ����%" from  mc$fs_space where
      key_date=(select max(key_date) from mc$fs_space) order by 1,5 desc;
prompt  ��  ˵����
prompt    Ŀǰϵͳ��ʹ���ʲ���90%���ļ�ϵͳΪ��
prompt
prompt



prompt2�����ݿ� 
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
   select decode(log_mode,'NOARCHIVELOG','�ǹ鵵ģʽ','�鵵ģʽ') into v_a from v$database;
   select sum(bytes)/1024/1024 into v_b  from v$datafile;
   select sum(bytes)/1024/1024 into v_c  from dba_free_space;
   
   v_d:=v_b - v_c;
   v_e:=trunc((v_b-v_c)/v_b*100,2);  
   dbms_output.put_line('����ORACLE������ݣ�');
   dbms_output.put_line('���ݿ�鵵ģʽ��       '||v_a);  
   dbms_output.put_line('���ݿ�ռ�����ܹ�ģ�� '||v_b||' (M)');
   dbms_output.put_line('���ݿ���пռ��ܹ�ģ�� '||v_c||' (M)');
   dbms_output.put_line('���ݿ���ʹ�ÿռ䣺     '||v_d||' (M)');
   dbms_output.put_line('��ʹ���ܿռ���ʣ�     '||v_e||' %');  
--   select count(1) into v_f from v$version where banner like '%10g%' or banner like '%11g%';
--   if v_f > 0 then
--      select decode(FLASHBACK_ON,'YES','��','NO','δ��') into v_g from v$database;
--      dbms_output.put_line('�Ƿ�����ݿ����أ� '||v_g);
--   end if;
--       
end;
/ 

prompt   
prompt  ���ݿ�ռ������ֲ������ 
       select to_char(key_date,'yyyy-mm-dd hh24:mi') "����",
       round(total_space/1024/1024,2) "�ܷ���ռ� (M)",
       round(used_space/1024/1024,2) "��ʹ�ÿռ� (M)" 
       from mc$db_space
       where to_char(key_date, 'dd') in ('01', '15')
			 order by 1;
  
prompt   
prompt    
prompt ��  ���ۣ�
prompt    �ռ�����ʷ��յȼ�����ȫ  ����  ����ȫ 
prompt ��  ���飺
prompt
prompt 3����ռ� 
prompt ______________________________________________________________

prompt
prompt ��ռ�ʹ���ʳ���85%���£� 

col tablespace_name format a8
col status format a7
col extent_management format a5
col segment_space_management format a6
col contents format a9


select * from (
SELECT  d.tablespace_name  "TABLESPACE",d.status "STATUS",
        d.extent_management "EXT_MGT",
        d.segment_space_management "�ι���", d.contents "CONTENTS",/*d.RETENTION "RETENTION"*/
        TO_CHAR(NVL(trunc(a.bytes / 1024 / 1024), 0),'99G999G990') "ALLOC(M)",
        TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0) / 1024 / 1024 ,'99G999G990') "USED(M)",
        TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0),'990D00') "USED%",
        TO_CHAR(NVL(trunc(f.largest_free / 1024 / 1024), 0),'99G999G990') "������(M)"  
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
  dbms_output.put_line('ϵͳӵ�����ݱ�ռ�����: '||v_a);
  select  count(distinct tablespace_name)  into v_b from dba_temp_files;
  dbms_output.put_line('ϵͳӵ����ʱ��ռ�����: '||v_b);
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
       dbms_output.put_line('���ݱ�ռ�ι���ģʽȫ��Ϊ:  AUTO ');
     else
       dbms_output.put_line('  AUTO�ι���ģʽ�����ݱ�ռ�:'||str1);
       dbms_output.put_line('��AUTO�ι���ģʽ�����ݱ�ռ�:'||str2);
     end if;
     if str4='.  ' then
       dbms_output.put_line('���ݱ�ռ����ģʽȫ��Ϊ:  LOCAL ');
     else
       dbms_output.put_line('  LOCAL����ģʽ�����ݱ�ռ�:'||str3);
       dbms_output.put_line('��LOCAL����ģʽ�����ݱ�ռ�:'||str4);
     end if;  
     if str6='.  ' then
       dbms_output.put_line('���ݱ�ռ�״̬ȫ��Ϊ:  ONLINE ');
     else
       dbms_output.put_line(' ONLINE״̬�����ݱ�ռ�:'||str5);
       dbms_output.put_line('OFFLINE״̬�����ݱ�ռ�:'||str6);
     end if;
     
end;
/   
prompt
prompt ��  ���ۣ�
prompt   ���пռ������յı�ռ�(80%����)�� 
prompt   �ռ伫�Ƚ��ŵı�ռ�(90%���ϣ��� 
prompt   ��ռ���ƣ� ���� / ��ͨ / ������  
prompt
prompt ��  ���飺
prompt

prompt 4�������ļ� 
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
   dbms_output.put_line('ϵͳ��ӵ�������ļ�������'||v_a); 
   dbms_output.put_line('ϵͳ�����������ļ���СΪ��'||v_b||' M');
   dbms_output.put_line('ϵͳ����С�������ļ���СΪ��'||v_c||' M');
   dbms_output.put_line('ϵͳ�����Զ����ŵ������ļ�Ϊ��'||v_d||' ��');
   dbms_output.put_line('ϵͳ������Զ����ŵ������ļ�Ϊ��'||v_e||' ��');
end;
/
prompt
prompt  �����ļ�״̬��ONLINE���б����£� 
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
    dbms_output.put_line('      Ŀǰ�����ݿ��ڲ�����״̬��ONLINE�������ļ���');
    dbms_output.put_line(chr(10)); 
  end if;
end;
/

--prompt
--prompt  �����С����4G�������ļ��б����£� 
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
--    dbms_output.put_line('      Ŀǰ�����ݿ��ڲ�����4G���ϵ������ļ���');
--    dbms_output.put_line(chr(10)); 
--  end if;
--end;
--/
--
--prompt
--prompt  �����ļ��Ĵ�С��ʹ�������£� 
--col file_id format 999
--col file_name format a40
--col tablespace_name format a15
--col status format a7
--SELECT  d.file_id "file_id",
--        d.file_name "file_name",
--        v.status "status", d.tablespace_name "tablespace",TO_CHAR(d.bytes / 1024 / 1024,'99999990') "alloc(M)", 
--        TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0)) / 1024 / 1024, 0),'99999990') "used(M)",
--        TO_CHAR((NVL(d.bytes - s.bytes, d.bytes) / d.bytes * 100),'990D00') "used%",
--        LPAD(NVL(f.autoextensible, 'NO'),6) "��չ" FROM sys.dba_data_files d,  v$datafile v, 
--        (SELECT file_id,SUM(bytes) bytes  FROM sys.dba_free_space   GROUP BY file_id) s,   
--        (select file#, 'YES' autoextensible  from sys.filext$) f   
--        WHERE s.file_id(+) = d.file_id AND d.file_name = v.name AND f.file#(+) = d.file_id
--        order by "used%" desc;
--    

prompt
prompt ��  ���ۣ�
prompt   �����ļ������ ���豸 / �ļ�ϵͳ / asm / ���   
prompt   �����ļ���ƣ� ���� / ��ͨ / ������ ');
prompt ��  ���飺
prompt



prompt  5����־�ļ� 
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

prompt ��־�ļ��Ĵ�С���������£� 
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
   select count(*),decode(count(*),2,'ƫ��',3,'һ��','����') into v_a,v_b from v$log;
   dbms_output.put_line('ϵͳ������־�ļ�������:  '||v_a||'  '||v_b); 
end;
/
prompt
prompt ��  ���ۣ�
prompt   ��־�ļ������ ���豸 / �ļ�ϵͳ / asm / ���  
prompt   ��־�ļ���ƣ� ���� / ��ͨ / ������ 
prompt
prompt ��  ���飺
prompt


prompt  6���鵵�ļ� 
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
  dbms_output.put_line('���ݿ⴦�ڷǹ鵵ģʽ�£�û�й鵵��־��Ϣ');
else 
  str:=''; 
  for i in (select destination from v$archive_dest where status='VALID' and destination is not null) loop
    str:=str||','||i.destination;  
  end loop;
  dbms_output.put_line('�鵵Ŀ�ĵأ� '||substr(str,2));   
  select trunc(sum(blocks*block_size)/((max(first_time)-min(first_time))*24*3600)),
  trunc(sum(blocks*block_size)/((max(first_time)-min(first_time)))) into sec_redo,day_redo from v$archived_log;
  dbms_output.put_line('ÿ����־����Ƶ��:  '||sec_redo ||' (byte)');
  dbms_output.put_line('ÿ����־����Ƶ��:  '||day_redo ||' (byte)');
  dbms_output.put_line('���������ͳ�����ݣ�');
  select trunc(sum(blocks*block_size)/((max(first_time)-min(first_time))*24*3600)),
  trunc(sum(blocks*block_size)/((max(first_time)-min(first_time)))) into sec_redo_90,day_redo_90 from v$archived_log where first_time>sysdate-91;
  dbms_output.put_line('ÿ����־����Ƶ��:  '||sec_redo_90 ||' (byte)');
  dbms_output.put_line('ÿ����־����Ƶ��:  '||day_redo_90 ||' (byte)');
end if;
end;
/
declare 
ac number;
begin 
select count(*) into ac from v$database where log_mode='ARCHIVELOG' ;
if ac=1 then
  dbms_output.put_line('���һ���¹鵵��־ÿ�ղ���������:  ');
end if;
end;
/
select LPAD(to_char(first_time,'yyyymmdd'),12) "����",
 trunc(sum(blocks*block_size)/1024/1024) "size(M)",count(*) 
 from sys.v$archived_log 
 where first_time >sysdate-31 group by LPAD(to_char(first_time,'yyyymmdd'),12)
 order by 1;

declare 
ac number;
begin 
select count(*) into ac from v$database where log_mode='ARCHIVELOG' ;
if ac=1 then
  dbms_output.put_line('���һ�ܹ鵵��־24Сʱ��ʱ����������:  ');
end if;
end;
/

select LPAD(to_char(first_time,'hh24'),4) "ʱ�̵�",
 trunc(sum(blocks*block_size)/1024/1024) "size(M)",count(*) 
from sys.v$archived_log 
where first_time >sysdate-7 group by to_char(first_time,'hh24') order by 1;

declare 
ac number;
begin 
select count(*) into ac from v$database where log_mode='ARCHIVELOG' ;
if ac=1 then
    dbms_output.put_line(chr(10)); 
    dbms_output.put_line('��  ���ۣ�'); 
    dbms_output.put_line('   �鵵��־�ļ������  �ļ�ϵͳ / asm ');  
    dbms_output.put_line('   �鵵��־�ļ���ƣ� ���� / ��ͨ / ������ ');
end if;
end;
/
prompt ��  ���飺
prompt
    
prompt 7��������־�ļ� 
prompt ______________________________________________________________
prompt

begin
dbms_output.put_line('   9i���ݿ�汾֧�����ز�ѯ����û��������־');
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
--      dbms_output.put_line('���ݿ����ص�Ŀ�궨��ʱ�䳤�ȣ� '||v_a|| '  (����)');
--      dbms_output.put_line('��ǰ��������־��������:   '||v_b||'  (M)');
--      dbms_output.put_line('���ݿ����֧�ֵ���С����ʱ�䣺 '||v_c);
--  else
--      dbms_output.put_line('   ���ݿ���û���κ�������־�ļ�����');
--   end if;
--end;
--/    
 

    
prompt 8����ʱ�οռ����� 
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
  dbms_output.put_line('��ʱ��ռ�������       '||v_a); 
  dbms_output.put_line('��ʱ�ļ�������         '||v_b); 
  dbms_output.put_line('���ݿ�ȱʡ��ʱ��ռ�:  '||v_c);     
end;
/


select file_name ,tablespace_name  ,bytes/1024/1024 "ALLOC(M)",
LPAD(AUTOEXTENSIBLE,10) "AUTOEXTENSIBLE" from dba_temp_files;
 
prompt ��  ���ۣ�
prompt     ��ʱ�οռ����ã� ���� / ��ͨ / ������ 
prompt
prompt ��  ���飺
prompt



prompt  9���ع��οռ����� 
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
-- dbms_output.put_line('�ع���ռ�����С     ��    '||v_a||' (M)'); 
--end;
--/

prompt  ϵͳ�ع��α�ռ�����
select tablespace_name "�ع��α�ռ���",sum(bytes)/1024/1024 "��С(M)" from dba_data_files
where tablespace_name in (select tablespace_name from dba_tablespaces where contents='UNDO')
group by tablespace_name;

prompt  ϵͳ�ع���ռ�������ã�
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
prompt �ع�����չ���±�ʹ��ʱ��
column explain format a53
column explain heading "�ع�����չ���±�ʹ��ʱ�� ..."
column hours format 9999999 heading "Сʱ"
column minutes heading "��"

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



prompt �� ˵����
prompt    ϵͳ����undo_retentionĿǰ����ΪxxxСʱ����Ŀǰϵͳ����ε�extent���±����õ�ƽ��ʱ��Ϊxxx��
prompt  ��飺
prompt	  Ϊ��ȷ���ع����ܴﵽ����ָ��ʱ�䣬�����ʵ����ӻع���ռ��С��
prompt


prompt
prompt  10�����ͱ�� 
prompt ______________________________________________________________
prompt
col owner format a10
col segment_name format a25
col tablespace  format a12
col segment_type format a13
col extents format 9999
prompt ���ͱ�������ݿ�ռ��������ܹ���Ĺؼ����������ڡ�
declare
 v_a number;
 v_b number;
 v_c varchar2(30);
begin
  select count(*) into v_a from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK');
  select sum(bytes)/1024/1024 into v_b from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK');
  select trunc((select sum(bytes) from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK'))*100/
               (select sum(bytes) from dba_segments where owner not in('SYSTEM','SYS','DBCHECK')))  into v_c from dual;
  dbms_output.put_line('Ŀǰ���ݿ��system����ӵ�б��:'||v_a||' ��'); 
  dbms_output.put_line('Ŀǰ���ݿ��system������ռ�ÿռ�:'||v_b||' MB'); 
  dbms_output.put_line('Ŀǰ���ݿ��system������ռ�ռ�ñ���Ϊ:  '||v_c||' %');     
end;
/

prompt
prompt ����Ϊϵͳ������20�ű�� 

select owner,LPAD(segment_type,12) SEGMENT_TYPE,tablespace_name TABLESPACE,segment_name,bytes/1024/1024 "SIZE(M)" from 
 (select owner,SEGMENT_NAME,TABLESPACE_NAME,SEGMENT_TYPE,bytes  
  from dba_segments order by bytes desc) 
  where segment_type like 'TABLE%' and rownum<21��
 ;

prompt
prompt ����Ϊϵͳ3��������������20��ҵ���û����
select owner,LPAD(segment_type,12) SEGMENT_TYPE,tablespace_name TABLESPACE,segment_name,old/1024/1024 "old(M)",now/1024/1024 "now(M)",bytes/1024/1024 "added SIZE(M)" from 
 (select a.owner,a.SEGMENT_NAME,a.TABLESPACE_NAME,a.SEGMENT_TYPE,NVL(b.bytes,null) old,a.bytes now,(a.bytes-NVL(b.bytes,0)) bytes  
  from dba_segments a left outer join (select table_name,bytes,owner from mc$segment_space where to_char(key_date,'yyyymmdd')=to_char(sysdate-90,'yyyymmdd')) b
  on a.segment_name=b.table_name and a.owner=b.owner
  where a.owner not in (select username from mc$system_user)
  order by bytes desc) 
  where segment_type like 'TABLE%' and rownum<21��
 ;
prompt ע��old(M)Ϊ�մ���ñ�Ϊ������±��ʱ��δ����Ѳ�첿��

prompt
prompt ��  ���飺
prompt     ��ǿ���ͱ��Ĺ��������ռ���չ�����ʷ����Լ������ֲ��ȵȡ�



prompt
prompt 11���������� 
prompt ______________________________________________________________
prompt
col owner format a10
col segment_name format a25
col tablespace_name format a12
col segment_type format a12
col extents format 9999
prompt �����������Ǻʹ��ͱ������ģ����ͱ�����ǲ������͵�������
prompt ԭ����������ģӦ�ñ���صı���ģҪС���ȱ����������������ζ�Ų����Ŀռ������ԡ�
declare
 v_a number;
 v_b number;
 v_c varchar2(30);
begin
  select count(*) into v_a from dba_segments where segment_type like 'INDEX%' and owner not in('SYSTEM','SYS','DBCHECK');
  select sum(bytes)/1024/1024 into v_b from dba_segments where segment_type like 'INDEX%' and owner not in('SYSTEM','SYS','DBCHECK');
  select trunc((select sum(bytes) from dba_segments where segment_type like 'INDEX%' and owner not in('SYSTEM','SYS','DBCHECK'))*100/
               (select sum(bytes) from dba_segments where segment_type like 'TABLE%' and owner not in('SYSTEM','SYS','DBCHECK')))  into v_c from dual;
  dbms_output.put_line('Ŀǰ���ݿ��system����ӵ������:'||v_a||' ��'); 
  dbms_output.put_line('Ŀǰ���ݿ��system��������ռ�ÿռ�:'||v_b||' MB'); 
  dbms_output.put_line('Ŀǰ���ݿ��system���������ռ�����ռ����Ϊ:  '||v_c||' %');     
end;
/

prompt
prompt ����Ϊϵͳ������20��������  

select owner,LPAD(segment_type,12) SEGMENT_TYPE,tablespace_name TABLESPACE,segment_name,bytes/1024/1024 "SIZE(M)" from 
 (select owner,SEGMENT_NAME,TABLESPACE_NAME,SEGMENT_TYPE,bytes 
  from dba_segments order by bytes desc) 
  where segment_type like 'INDEX%' and rownum<21��
  order by bytes desc,owner,segment_type;
prompt ��
prompt ��  ���飺
prompt         1����ǿ���������Ĺ��������ռ���չ�����ʷ����Լ��ͱ��Ŀռ�Ƚϡ�
prompt         2������һЩƵ������ update��delete�Ĵ����������ж������´�����
prompt
prompt



prompt 12��������չʧ�ܵĶ��� 
prompt ______________________________________________________________
prompt    ������չʧ�ܽ���ʹҵ���жϣ��ر��Ǵ��������ʧ�ܽ���ɱȽϴ��Ӱ�졣��Ҫ���ڼ�鼴����չʧ�ܵĶ���
prompt    ʹ�ռ�ʧ�ܵ�״������Ԥ�ȱ��ų���
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

prompt ��  ���飺
prompt


prompt 13��Maxextents����
prompt ______________________________________________________________
prompt    �����ﵽmaxextents���ƵĶ���ﵽmaxextents����ʹҵ���޷���������Ҫȷ����񲻻�ﵽmaxextents���ơ�
declare
  num number;
begin
  select count(*) into num from dba_segments where max_extents-extents < 5 and max_extents <> 0;
  if num = 0 then
    dbms_output.put_line('     Ŀǰϵͳ�����ڼ����ﵽmaxextents���ƵĶ���');
  end if;
end;
/
select owner||'.'||segment_name "SEGMENT_NAME",segment_type,extents,max_extents from dba_segments
  where max_extents-extents < 5 and max_extents <> 0;

prompt ��  ���飺
prompt

prompt
prompt   �����ݿ���Ƭ
prompt  
prompt  1����ռ���Ƭ
prompt ______________________________________________________________
prompt   ������б������������ñ�ռ�Ĵ洢�������ã���ռ���Ƭ����������κ���в��
prompt   �����ռ����extentͳһ��С���й���10g����LOCAL����
    select tablespace_name,count(*) "��Ƭ" from dba_free_space
    group by tablespace_name
    having count(*)>1000;
prompt ��  ���飺
prompt    
prompt
prompt  2����Ǩ�Ƶı�� 
prompt ______________________________________________________________
prompt
declare
  num number;
begin
  select count(*) into num from dba_tables where chain_cnt>0;
  if num = 0 then
    dbms_output.put_line('û�з��ִ�����Ǩ�Ƶı��');
  end if;
end;
/
 select owner,table_name,chain_cnt,blocks,NUM_ROWS from dba_tables where chain_cnt>0;

prompt ��  ���ۣ�
prompt 
prompt ��  ���飺
prompt

prompt
prompt   ���������
prompt
prompt 1��SYSTEM��ռ��ڵ�ҵ������ 
prompt ______________________________________________________________
prompt  SYSTEM��ռ���ԭ���ϲ�Ӧ�ô��ҵ�����ݡ� 

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
    dbms_output.put_line('    Ŀǰ�����ݿ���SYSTEM��ռ��ڲ�����ҵ�����ݶ���');
  end if;
end;
/
prompt
prompt 2����ռ������λ�� 
prompt ______________________________________________________________
prompt
prompt ��ռ��ڴ�ŵĶ���ֲ����£� 
 select b.tablespace_name "TABLESPACE",LPAD(segment_type,12) "SEGMENT_TYPE",count(*) from dba_segments a,
 dba_tablespaces b where a.tablespace_name=b.tablespace_name and a.tablespace_name !='SYSTEM'
 group by b.tablespace_name,segment_type
 union
 select tablespace_name ,'--',0 from dba_tablespaces 
 where tablespace_name not in 
 (select distinct tablespace_name from dba_segments);
prompt

prompt ��  ���飺
prompt
prompt 3����Ч���� 
prompt ______________________________________________________________
prompt  ���һ�������޸ĵ���Ч�Ķ�����,���������Ч����������utlrp.sql��Ȼ���ٴ����иýű����鿴�Ƿ�����Ч��������������ڣ������Ƿ�������
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


prompt 4) ϡ����
prompt ______________________________________________________________
prompt  ϡ������ָ���Ŀռ����ò�����֣�ϡ�����˷ѿռ䲢��Ӱ�����ܣ��������ʵ���ʱ��������´�����
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
prompt ��  ���飺
prompt         1�����´��ռ��Լ�ȽϸߵĻ����������൱�͵ı��
prompt         2�����ȷ�ϲ�������ʲô��Ǩ�����Խ����PCTFREEִ�У�ͬ������ռ�ǳ����ţ�Ϊ�˳�����ÿռ�����Ը����н����pctused����������

prompt
prompt 5) ϡ������
prompt ______________________________________________________________
prompt  ϡ�������˷ѿռ䲢��Ӱ�����ܡ������Ƚϱ��������ױ�������
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
prompt ��  ���飺
prompt         1������ϡ��������

prompt
prompt 6������վ�ڵĶ��� 
prompt ______________________________________________________________
prompt
prompt 9i���ݿ�û��recyclebin������վΪ10g�������ԣ���֧�����ز�����

--declare
--   v_a number;
--begin
--  select sum(space) into v_a from dba_recyclebin;
--  dbms_output.put_line('����վ�ڵĶ���ռ���ܿռ����£�  '||v_a||'  blocks');
--end;
--/
--
--prompt ����վ�ڵ����30������ֲ����£�  
--
--select owner,object_name,original_name, type,
--   ts_name,operation,droptime,LPAD(can_purge,6) "������",space "blocks" 
-- from (select owner,object_name,original_name,partition_name,type,
--   ts_name,operation,droptime,can_purge,space from dba_recyclebin order by space desc)
-- where rownum<31;
  


prompt 
prompt 
prompt ����ȫ����    
prompt 1�������û� 
prompt ______________________________________________________________
prompt
prompt ����������ڵ����û����£� 
select username,default_tablespace,to_char(created,'yyyy-mm-dd hh24:mi:ss') created 
from dba_users where created > sysdate-92 and username != 'MCCHECKMC963';

prompt
prompt ��  ���ۣ�
prompt
prompt ��  ���飺
prompt


prompt 2��ȱʡ��ռ�ָ��SYSTEM�ķ�ϵͳ�û� 
prompt ______________________________________________________________
prompt
prompt SYSTEM��ռ���ORACLE��������ֵ�ʹ�õģ����۴ӿռ���仹�����ܿ��ǣ�����Ӧ�ðѷ�ϵͳ�û�ָ��SYSTEM��ռ䣬���ݿ���ȱʡָ��SYSTEM��ռ�ķ�ϵͳ�û����£� 
select username,'ȱʡ��ռ�ΪSYSTEM. ' default_tablespace
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
    dbms_output.put_line('Ŀǰ�����ݿ��ڲ��������Ƶ��û���');
  end if;
end;
/
 
prompt
prompt ��  ���ۣ�
prompt
prompt ��  ���飺
prompt


prompt 3����ʾ�û�����������ͬ���û� 
prompt ______________________________________________________________
prompt
prompt Ŀǰϵͳ�п���̫�򵥵��û����£� 
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
prompt ��  ���ۣ�
prompt
prompt ��  ���飺
prompt

prompt 4��DBAȨ�޹��� 
prompt ______________________________________________________________

prompt Ŀǰϵͳ��ӵ��DBA�ȴ�Ȩ�޵��û����£� 

declare
  num number;
begin
  select count(*) into num  from dba_role_privs
  where granted_role in( 'DBA','IMP_FULL_DATABASE') 
   and grantee not in('SYS','SYSTEM','DBA');
  if num = 0 then
    dbms_output.put_line('���ݿ��ڲ�����DBAȨ�޺�IMP_FULL_DATABASEȨ�޵��û����ɫ��');
  end if;
end;
/
col grantee format a20
col granted_role format a20 
 select a.grantee,granted_role,lpad(a.admin_option,6) "�ɴ���",lpad(a.default_role,6) "ȱʡ��ɫ",b.account_status "�˺�״̬"
 from dba_role_privs a,dba_users b
 where a.grantee=b.username and
 granted_role in( 'DBA','IMP_FULL_DATABASE') 
 and grantee not in('SYS','SYSTEM','DBA');
 
prompt ��  ���ۣ�
prompt
prompt ��  ���飺
prompt


prompt 5��ANYȨ�޹��� 
prompt ______________________________________________________________
prompt     ����ANYȨ�ޱ�DBAȨ����΢��ȫһЩ���������ܷ����κα�ı�����ݣ����ǵ����ݵı����Ժ���Ҫ�ԣ���Ӧ����㸳��ANYȨ�ޡ�Ŀǰϵͳ��ӵ��any�ȴ�Ȩ�޵��û����£� 
prompt
declare
  num number;
begin
  select count(*) into num from dba_sys_privs    
  where privilege in('DELETE ANY TABLE','INSERT ANY TABLE','UPDATE ANY TABLE','SELECT ANY TABLE') 
 and grantee not in('DBA','IMP_FULL_DATABASE','SYS','EXP_FULL_DATABASE');
  if num = 0 then
    dbms_output.put_line('���ݿ��ڲ�����Ȩ��DELETE ANY TABLE��INSERT ANY TABLE��UPDATE ANY TABLE��SELECT ANY TABLE���û����ɫ��');
  end if;
end;
/
col grantee format a20
col granted_role format a20 

col privilege format a24  
select a.grantee,a.PRIVILEGE,lpad(a.ADMIN_OPTION,12) "ADMIN_OPTION",b.account_status "�˺�״̬"
 from dba_sys_privs a,dba_users b                                     
 where  a.grantee=b.username and
 a.privilege in('DELETE ANY TABLE','INSERT ANY TABLE','UPDATE ANY TABLE','SELECT ANY TABLE') 
 and a.grantee not in('DBA','IMP_FULL_DATABASE','SYS','EXP_FULL_DATABASE');
 
prompt ��  ���ۣ�
prompt
prompt ��  ���飺
prompt

prompt 
prompt ������ϵͳ���úͼ��
prompt 1������ϵͳCPUʹ�����
prompt ______________________________________________________________
prompt     ϵͳ����xx��CPU��һ����ƽ��CPU��ʹ����Ϊxx% 
prompt     ����Ϊһ����CPUʹ���ʵ�ʱ��ͼ����ҵ��߷��ڣ�xx��00-xx��00��CPUʹ������xx%���ϡ�
   select inst_id,to_char(key_date,'HH24') as "HH",
          round(avg(cusr+csys),2) "USED %",
          round(avg(cidle),2) "IDLE %"
   from  mc$oscpu where key_date>sysdate-7
   group by inst_id,to_char(key_date,'HH24') order by 1,2;
prompt
prompt     ����ΪCPU��ƽ��ͼ
   select inst_id,to_char(key_date,'YYYY-MM-DD') "����",
          round(avg(cusr+csys),2) "USED %",
          round(avg(cidle),2) "IDLE %"
   from  mc$oscpu where key_date>sysdate-7
   group by inst_id,to_char(key_date,'YYYY-MM-DD') order by 1,2;
prompt
prompt 2������ϵͳ�ڴ�ʹ�����
prompt ______________________________________________________________
prompt    ϵͳ�����ڴ�XXX(GB)��һ��ƽ���ڴ����ΪXXX(MB)
select inst_id,to_char(key_date,'yyyymmdd') "����",trunc(avg(fmem*4)/1024) "MB" from mc$osmem group by  inst_id,to_char(key_date,'yyyymmdd')
order by 1,2;
prompt 
prompt 3) ����ϵͳDISK I/O
prompt ______________________________________________________________
prompt     ����Ϊһ����ƽ��DISK I/O�ȴ����
   select inst_id,to_char(key_date,'HH24') "HH",
          round(avg(cwio),2) "wio %"
   from  mc$oscpu where key_date>sysdate-7
   group by inst_id,to_char(key_date,'HH24') order by 1,2;




prompt
prompt ������Ϣ
prompt
prompt    
prompt ��ʾ��ִ�д���
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
prompt ��ʾ�߸���SQL
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
prompt ���������
  select to_char(key_date,'YYYY-MM-DD') "DATE",
  	      round(avg(active_trans)) "AVG"
     from  mc$session
     group by to_char(key_date,'YYYY-MM-DD')
     order by 1;

prompt      
prompt �����ʮ��ͼ
    select to_char(key_date,'HH24') "DATE",
  	      round(avg(active_trans)) "AVG"
     from mc$session
     group by to_char(key_date,'HH24')
     order by 1;

prompt     
prompt CPUʹ��״��
   select inst_id,to_char(key_date,'YYYYMMDD') "DATE",
          round(avg(cusr+csys),2) "LOAD",
          round(avg(runp),2) "PROCS"
   from mc$oscpu
   group by inst_id,to_char(key_date,'YYYYMMDD')
   order by 1,2;
   
prompt   
prompt CPUʹ��״��ʱ��ͼ
   select inst_id,to_char(key_date,'HH24') "DATE",
          round(avg(cusr+csys),2) "USED %",
          round(avg(runp),2) "PROCS"
   from mc$oscpu
   group by inst_id,to_char(key_date,'HH24')
   order by 1,2;
   
prompt   
prompt CPUʹ��ƽ��ÿ��
      select inst_id,to_char(key_date,'YYYYMMDD') "HOUR",
    	      round(avg(cusr+csys)) "used",
    	      round(avg(cidle)) "cidle",
    	      round(avg(cwio)) "cwio",
    	      round(avg(runp)) "crunp"
     from mc$oscpu
     group by inst_id,to_char(key_date,'YYYYMMDD')
     order by 1,2;

prompt
prompt CPUʹ��ʱ��ͼ
      select inst_id,to_char(key_date,'HH24') "HOUR",
    	      round(avg(cusr+csys)) "used",
    	      round(avg(cidle)) "cidle",
    	      round(avg(cwio)) "cwio",
    	      round(avg(runp)) "crunp"
     from mc$oscpu
     group by inst_id,to_char(key_date,'HH24')
     order by 1,2;

prompt   
prompt ϵͳ����״��   
   select inst_id,to_char(key_date,'YYYYMMDD') "DATE",
          round(avg(uptime),2) "Uptime"
   from mc$osprocs 
   group by inst_id,to_char(key_date,'YYYYMMDD')
   order by inst_id,to_char(key_date,'YYYYMMDD');
   
prompt   
prompt ϵͳ����״��(ʱ��ͼ�� 
   select inst_id,to_char(key_date,'HH24') "DATE",
          round(avg(uptime),2) "Uptime"
   from mc$osprocs 
   group by inst_id,to_char(key_date,'HH24')
   order by inst_id,to_char(key_date,'HH24');   
   
prompt   
prompt �Ự��ƽ��ÿ��Ự��
   select to_char(key_date,'YYYYMMDD') "HOUR",
    	      round(avg(active_session)) "AVG_SESSION"
      from mc$session where key_date>sysdate-7
      group by to_char(key_date,'YYYYMMDD')
      order by 1;   
      
prompt
prompt  �Ựʱ��ͼ
   select to_char(key_date,'HH24') "HOUR",
    	      round(avg(active_session)) "AVG_SESSION"
      from mc$session where key_date>sysdate-7
      group by to_char(key_date,'HH24')
      order by 1;

prompt
prompt ��ʾversion_countλͼ
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
prompt ��ռ���Ϣ
select * from (
SELECT  d.tablespace_name  "TABLESPACE",d.status "STATUS",
        d.extent_management "EXT_MGT",
        d.segment_space_management "�ι���", d.contents "CONTENTS",/*d.RETENTION "RETENTION",*/
        TO_CHAR(NVL(trunc(a.bytes / 1024 / 1024), 0),'99G999G990') "ALLOC(M)",
        TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0) / 1024 / 1024 ,'99G999G990') "USED(M)",
        TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0),'990D00') "USED%",
        TO_CHAR(NVL(trunc(f.largest_free / 1024 / 1024), 0),'99G999G990') "������(M)"  
        FROM sys.dba_tablespaces d,
        (SELECT tablespace_name,SUM(bytes) bytes   FROM dba_data_files  GROUP BY tablespace_name) a,
        (SELECT tablespace_name,SUM(bytes) bytes, MAX(bytes) largest_free   FROM dba_free_space   GROUP BY tablespace_name) f  
        WHERE d.tablespace_name = a.tablespace_name   AND d.tablespace_name = f.tablespace_name(+)
        )
    order by "USED%" desc
/

prompt
prompt  �����ļ���Ϣ 
col file_id format 999
col file_name format a40
col tablespace_name format a15
col status format a7
SELECT  d.file_id "file_id",
        d.file_name "file_name",
        v.status "status", d.tablespace_name "tablespace",TO_CHAR(d.bytes / 1024 / 1024,'99999990') "alloc(M)", 
        TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0)) / 1024 / 1024, 0),'99999990') "used(M)",
        TO_CHAR(d.MAXBYTES / 1024 / 1024,'99G999G990') "MAXBYTES(M)",
        LPAD(NVL(f.autoextensible, 'NO'),6) "��չ" FROM sys.dba_data_files d,  v$datafile v, 
        (SELECT file_id,SUM(bytes) bytes  FROM sys.dba_free_space   GROUP BY file_id) s,   
        (select file#, 'YES' autoextensible  from sys.filext$) f   
        WHERE s.file_id(+) = d.file_id AND d.file_name = v.name AND f.file#(+) = d.file_id
        order by "MAXBYTES(M)" desc;

prompt
prompt ������Ч����
col owner format a10 
col object_name format a35 
col object_type format a12 
col created format a20   
select owner,object_type, to_char(created,'yyyy-mm-dd') created,to_char(last_ddl_time,'yyyy-mm-dd/hh24:mi:ss') last_ddl_time,object_name 
   from sys.dba_objects
   where status = 'INVALID'
    order by owner, object_type;

prompt
prompt Ѳ�������ݿ��ϵͳ�û���Ϣ
prompt û��ӵ�������������������д洢���̻򴥷�����ͬ��ʵȣ���dba_objects�п��Բ鵽�����Ϣ
prompt ORACLE_OCM�û���10g���������г��֣�11g��ϵͳ�û�
col "�û�" format a20
col "�˻�״̬" format a10
col "����ʱ��" format 9999999999999999
col "Ĭ��temp" format a10
col "ӵ��������(MB)" format 99999999990.99
select a.USERNAME "�û�",a.ACCOUNT_STATUS "�˻�״̬",a.created "����ʱ��",a.TEMPORARY_TABLESPACE "Ĭ��temp",sum(b.bytes)/1024/1024 "ӵ��������(MB)"
from dba_users a left outer join dba_segments b on a.username=b.owner 
where a.username not in (select username from mc$system_user)
--where a.username not in ('OUTLN','DIP','TSMSYS','WMSYS','EXFSYS','DMSYS','CTXSYS','ANONYMOUS','XDB','MDSYS','ORDPLUGINS','ORDSYS','SI_INFORMTN_SCHEMA','OLAPSYS','MDDATA','SYS','SYSTEM','DBSNMP','MGMT_VIEW','SYSMAN')
group by a.USERNAME,a.ACCOUNT_STATUS,a.created,a.TEMPORARY_TABLESPACE
order by a.account_status,a.created;

prompt ��ϵͳ�û���Ӧʹ�ñ�ռ�������
select a.USERNAME "�û�",a.default_tablespace "Ĭ�ϱ�ռ�",b.tablespace_name "ʹ�ñ�ռ�",sum(b.bytes)/1024/1024 "ӵ��������(MB)"
from dba_users a join dba_segments b on a.username=b.owner 
where a.username not in ('OUTLN','DIP','TSMSYS','WMSYS','EXFSYS','DMSYS','CTXSYS','ANONYMOUS','XDB','MDSYS','ORDPLUGINS','ORDSYS','SI_INFORMTN_SCHEMA','OLAPSYS','MDDATA','SYS','SYSTEM','DBSNMP','MGMT_VIEW','SYSMAN')
group by a.USERNAME,a.default_tablespace,b.tablespace_name;

    
spool off
 
exit
