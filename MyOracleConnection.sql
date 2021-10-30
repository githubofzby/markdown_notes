-- �½���ռ�wsl001
create tablespace wsl001 datafile 'D:\wsl001.dbf' size 20m uniform size 128k;

-- ����school�û�
create user school identified by wslrrr;
grant dba to school;

-- ����school
conn school/wslrrr;

-- ����class
create table class(
clno varchar2(5) primary key,
dept varchar2(40) not null,
grade varchar2(8) not null,
branch varchar2(20) not null
)tablespace wsl001;

-- ���checkԼ��
alter table class
add constraint ck_class_grade check(grade in('��һ','���','����','����'));

-- ����student
create table student(
sno varchar2(5) primary key,
name varchar2(12) not null,
age number(2) not null,
sex char(1) not null,
entrance date,
address varchar2(100),
clno varchar2(5),
constraint fk_clno foreign key(clno) references class (clno)
)tablespace wsl001;

-- ������ű��ע��
comment on table student is 'ѧ����Ϣ��';
comment on table class is '�༶��Ϣ��';

-- ����course
create table course(
cno varchar2(5) primary key,
name varchar2(60) not null,
score number(2) not null
)tablespace wsl001;

-- ����teacher
create table teacher(
tno varchar2(5) primary key,
name varchar2(12) not null,
age number(2),
cno varchar2(5) not null,
constraint fk_con foreign key(cno)references course(cno)
)tablespace wsl001;

-- ��ѧ��ѡ�α�st
create table st(
sno varchar2(5) not null,
tno varchar2(5) not null,
grade number(2) default 0,
constraint  pk_sno_tno primary key(sno,tno)
)tablespace wsl001;

-- ׷��ע��
comment on table course is '�γ���Ϣ��';
comment on table teacher is '��ʦ��Ϣ��';
comment on table st is 'ѧ��ѡ�α�';

-- �鿴teacher��ṹ
desc teacher;

-- ����ά��
-- ��ѧ����Ϣϵͳ��ѧģ������������ݱ�����Ӳ�������
-- ��insert into��䰴˳���������

-- 1��class�����������
insert into class values('cc101', '�����', '��һ', 'һ��');
insert into class values('cc102', '�����', '��һ', '����');
select * from class;

-- 2����ѧ����Ϣ���������
insert into student values('95001', '����', 21, '1', '01-9��-2006', '�ൺ', 'cc101');
insert into student values('95002', '����', 21, '1', to_date('2006-9-1', 'yyyy-mm-dd'), '���', 'cc101');
insert into student values('95003', '�ŷ�', 23, '1', to_date('2006-9-1', 'yyyy-mm-dd'), '�ൺ', 'cc101');
insert into student values('95004', '����', 20, '0', to_date('2006-9-1', 'yyyy-mm-dd'), '����', 'cc102');
insert into student values('95005', 'С��', 23, '0', to_date('2006-9-1', 'yyyy-mm-dd'), '�Ϻ�', 'cc102');
select * from student;

-- 3����γ���Ϣ���������
insert into course values('cn001', '���ݿ�ԭ��', 4); 
insert into course values('cn002', '���ݽṹ', 4); 
insert into course values('cn003', '����ԭ��', 2); 
insert into course values('cn004', '�������', 2); 
insert into course values('cn005', '�ߵ���ѧ', 3); 
select * from course;

-- 4�����ʦ��Ϣ���������
insert into teacher values('T8101', '����', 34, 'cn001');
insert into teacher values('T8102', '����', 32, 'cn002');
insert into teacher values('T8103', '����', 28, 'cn002');
insert into teacher values('T8104', '��ѩ', 33, 'cn003');
insert into teacher values('T8105', '��˳', 32, 'cn004');
insert into teacher values('T8106', '�ܸ�', 32, 'cn005');
select * from teacher;

-- 5����ѧ��ѡ�α��������
insert into st values('95001', 'T8101', 0);
insert into st values('95001', 'T8102', 0);
insert into st values('95001', 'T8104', 0);
insert into st values('95002', 'T8101', 0);
insert into st values('95002', 'T8103', 0);
insert into st values('95002', 'T8104', 0);
insert into st values('95002', 'T8106', 0);
insert into st values('95003', 'T8102', 0);
insert into st values('95003', 'T8104', 0);
insert into st values('95003', 'T8105', 0);
insert into st values('95004', 'T8102', 0);
insert into st values('95004', 'T8105', 0);
insert into st values('95004', 'T8106', 0);
insert into st values('95005', 'T8105', 0);
insert into st values('95005', 'T8106', 0);
select * from st;

-- ����������ӱ�Ҫ��Լ��
-- ѧ����Ϣ������Ҫ��Լ��student
alter table student
add constraint ck_student_age check(age > 16 and age < 41);
alter table student
add constraint ck_student_sex check(sex in ('0', '1'));

-- course��Լ��
alter table course
add constraint ck_course_score check(score > 0 and score < 10);

-- teacher��Լ��
alter table teacher
add constraint ck_teacher_age check(age > 20 and age < 66);

-- st��Լ��
-- st�����Լ��
alter table st
add constraint fk_st_sno foreign key(sno) references student(sno);
alter table st
add constraint fk_st_tno foreign key(tno) references teacher(tno);
-- st��checkԼ��
alter table st
add constraint ck_st_grade check(grade >= 0 and grade <= 9);

-- ��ͼ
-- ��ѧ������ϵͳ��school����ѧ��ģ��Ŀ��������У���Ҫʵ�����µ����ݲ�ѯҳ��

-- ��ѧ����Ϣ��ѯҳ�棺�ṩϵ���꼶���༶��ѧ�š�ѧ�����������䡢�Ա���ѧ����
-- ����ѧ����Ϣ��ѯҳ����ͼ
create or replace view vw_class_student
as
select c.dept, c.grade, c.branch, s.sno, s.name, s.age, s.sex, s.entrance
from class c join student s on c.clno = s.clno
with read only;
select * from vw_class_student;

-- ���ڿ���Ϣ��ѯҳ�棺�ṩ��ʦ�š����������估�����ογ̱�š��γ�����
create or replace view vw_teacher_course
as
select t.tno, t.name tname, t.age, c.cno, c.name cname
from teacher t join course c on t.cno = c.cno
with read only;
select * from vw_teacher_course;

-- ��ѡ����Ϣ��ѯҳ�棺ѧ���š�ѧ����������ѡ�γ̱�š��γ�����
create or replace view vw_student_course
as 
select s.sno, s.name sname, c.cno, c.name cname
from student s join st st on s.sno = st.sno
join  teacher t on st.tno = t.tno
join course c on t.cno = c.cno
with read only;
select * from vw_student_course;
-- ���ν���Ϣ��ѯҳ�棺�ṩϵ���꼶���༶���ڵ�ǰ�ൣ���ڿ�����Ľ�ʦ������
create or replace view vw_class_teacher
as 
select distinct c.dept "ϵ", c.grade "�꼶", c.branch "�༶", t.name "��ʦ����"
from class c join student s on c.clno = s.clno
join st st on s.sno = st.sno
join teacher t on st.tno = t.tno
with read only;
select * from vw_class_teacher;

-- �ݰ༶�γ̲�ѯҳ�棺�ṩϵ���꼶���༶����ǰ�������ǵĿγ�����
create or replace view vw_class_course
as
select distinct cl.dept "ϵ", cl.grade "�꼶", cl.branch "�༶", c.NAME "�γ�����"
from class cl join student s on cl.clno = s.clno
join st st on s.sno = st.sno
join teacher t on t.tno = st.tno
join course c on t.cno = c.cno
with read only;
select * from vw_class_course order by "�γ�����";

-- ��Ҫ���ѧ������ʵ�����µ�����ͳ��ҳ��

-- �ٰ༶����ͳ��ҳ�棺���༶���飬ͳ��ÿ���༶��ѧ������
create or replace view vw_class_count
as
select c.dept ϵ, c.grade �꼶, c.branch �༶, count(*) ѧ������
from class c join student s on c.clno = s.clno
group by (c.dept, c.grade, c.branch);
select * from vw_class_count;

conn school/wslrrr;
show user;

-- ��ѧ���ɼ�ͳ��ҳ�棺���༶��ѧ�����飬ͳ��ÿ��ѧ���ĳɼ��ܺͼ���ѡ�޵Ŀγ���
create or replace view vw_student_count
as
select c.dept ϵ, c.grade �꼶, c.branch �༶, s.name ѧ������, count(*) �γ���, sum(st.grade) �ɼ�
from class c join student s on c.clno = s.clno
join st st on st.sno = s.sno
group by (c.dept, c.grade, c.branch, s.name);
select * from vw_student_count;

-- ��ѧ���ɼ��б�ҳ�棺�������ѧ�������пγ̵�ѡ�޵÷�
-- decode��������һ��������ڶ����������жԱȡ���һ�£��򷵻ص��������������򣬷��ص��ĸ�����
create or replace view vw_student_grade
as
select s.name ����, 
sum(decode(c.name, '���ݿ�ԭ��', grade, null)) ���ݿ�ԭ��,
sum(decode(c.name, '���ݽṹ', grade, null)) ���ݽṹ,
sum(decode(c.name, '����ԭ��', grade, null)) ����ԭ��,
sum(decode(c.name, '�������', grade, null)) �������,
sum(decode(c.name, '�ߵ���ѧ', grade, null)) �ߵ���ѧ
from student s join st st on s.sno = st.sno
join teacher t on t.tno = st.tno
join course c on t.cno = c.cno
where c.name in ('���ݿ�ԭ��', '���ݽṹ', '����ԭ��', '�������', '�ߵ���ѧ')
group by s.name;
select * from vw_student_grade;

-- �ü�¼���ͱ������DML����
declare
  -- ʹ��%rowtype����class�ļ�¼���ͱ���
  class_record class%rowtype;
  row_id       rowid;  -- ��¼��ID
  info         varchar2(80);  -- ��¼���ݲ�����Ϣ
begin
  class_record.clno:='cc103';
  class_record.dept:='�Զ���';
  class_record.grade:='����';
  class_record.branch:='һ��';
  
  /*ʹ�ü�¼���ͱ���������ݲ������*/
  insert into class values class_record
  returning rowid, clno||','||DEPT||','||GRADE||','||branch into row_id, info;
  dbms_output.put_line('����:'||row_id||':'||info);
  
  /*��ɼ�¼�������޸�*/
  class_record.clno:='cc104';
  update class set row=class_record where clno = 'cc103'
  returning rowid, clno||','||DEPT||','||GRADE||','||branch into row_id, info;
  dbms_output.put_line('�޸�:'||row_id||':'||info);
  
  /*��ɲ����е��޸�*/
  class_record.branch:='����';
  update class set branch=class_record.branch where clno=class_record.clno
  returning rowid, clno||','||dept||','||grade||','||branch into row_id, info;
  dbms_output.put_line('�޸�:'||row_id||':'||info);
  
  /*���ڼ�¼���ͱ�����������ɾ��*/
  delete from class where clno = class_record.clno
  returning rowid, clno||','||dept||','||grade||','||branch into row_id, info;
  dbms_output.put_line('ɾ��:'||row_id||':'||info);
  
  exception
    when others then
      dbms_output.put_line('����ĳ���쳣!');
end;

-- ʹ��Ƕ�ױ�
-- 1������Ƕ�ױ�����
create or replace type family_type is table of varchar2(20);

-- 2������student��
alter table student add(
  family family_type
)nested table family store as family_table;

-- �������
insert into student
values('95006', '�Ѿ�', 19, 0, to_date('2006-09-01', 'yyyy-mm-dd'), '�Ϻ�', 'cc102', family_type('����','ĸ��','���'));

-- ��Ҫ����Ƕ�ױ��е�����ʱ����Ҫ����Ƕ�ױ������������
declare
  /*����family_type���ͱ������ڽ��ռ������*/
  family_table family_type;
  v_name student.name%type;
begin
  select name, family into v_name, family_table from student where sno = &sno;
  dbms_output.put_line(v_name||'�������У�');
  for i in 1..family_table.count
  loop
    dbms_output.put_line(family_table(i)||' ');
  end loop;
  dbms_output.new_line();  
  exception
    when no_data_found then
      dbms_output.put_line('ָ��ѧ��������');
end;

-- 5����Ҫ����Ƕ�ױ������
declare
  family_table1 family_type:=family_type('����', 'ĸ��', '���');
  family_table2 family_type;
  v_sno student.sno%type:=&sno;
  v_name student.name%type;
begin
  /*ʹ��Ƕ�ױ��������Ƕ�ױ���*/
  update student set family=family_table1 where sno=v_sno;
  /*��ȡ���º������*/
  select name, family into v_name, family_table2 from student where sno=v_sno;
  dbms_output.put_line('ѧ��' || v_name || '��������:');
  for i in 1 .. family_table2.count
  loop
    dbms_output.put_line(family_table2(i)||' ');
  end loop;
  dbms_output.new_line();
  exception
    when no_data_found then
    SYS.DBMS_OUTPUT.PUT_LINE('ָ��ѧ���Ų�����');
end;
  
 �αָ꣨�룩��OracleΪ�û������һ�����ݻ����������SQL����ִ�н��
 Oracle���ݿ���ִ�е�ÿ��SQL��䶼�ж�Ӧ�ĵ������α�
 ��ʽ�α꣺����Ķ��ǵ���select into��DML���
 ��ʾ�α꣺����select��䷵�صĶ������ݡ�

--A�������α� cursor cursor_name [...]is select_statement;
declare
-- ����cursor class_cursor is select clno, dept from class;
    cursor class_cursor is select * from class;
--    v_clno class.clno%type;
--    v_dept class.dept %type;
    class_record class%rowtype;
-- B�����α꣺open cursor_name
begin
    open class_cursor;
--C����ȡ�α����ݣ�fetch cursor_name into {variable_list|record_variable};
    loop
--      fetch class_cursor into v_clno, v_dept;
      fetch class_cursor into class_record;
      exit when class_cursor%notfound or class_cursor%rowcount > 2; 
--      dbms_output.put_line('�༶��' || v_clno ||','||'ϵ'||v_dept);
      dbms_output.put_line('�༶��' || class_record.clno || ',' ||'ϵ'||class_record.dept);
    end loop;
--D�����α�ָ��ָ��ļ�¼���д���
--E����������ֱ��ѭ������û�м�¼
--F���ر��α꣺close cursor_name
    close class_cursor;
end;
select * from class;
--�α�����
--%notfound
--%found
--%rowcount:������ȡ��ʵ������
--%isopen
--�쳣����exception
declare
  v_n1 int:= &n1;
  v_n2 int:= &n2;
  v_div int;
begin
  v_div:=v_n1/v_n2;
  dbms_output.put_line(v_n1 || '/' || v_n2 || '=' || v_div);
exception
  when zero_divide then
    dbms_output.put_line('��������Ϊ0!');
  when others then
    dbms_output.put_line('����δ֪����!');
end;

--PL/sql�飺�����飬�ӳ���
--��������trigger������
--1����䴥��������ִ��DML����ʱ����������ഥ����
--2���д�����
create or replace trigger trg_class
before insert or update or delete on class
declare
v_now varchar2(30);
begin
  v_now:=to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss');
  case
    when inserting then
      dbms_output.put_line(v_now || '��class�������insert����');
  end case;
end;

insert into class values('cc105', '�Զ���', '����', 'һ��');

--����ϵͳҪ�󣬾�����Ҫ��ӡ������Ϣ��Ϊ����ά�����轫�����ӡ����ͳһ��װ�����������ͳһά��
--������1�����ṹ�Ĺ���һ�����ģ�鹦�������壬�ɽ���ѧ����Ĳ�������Ϊһ������
--       2�����ڱ����ӡ��һ���漰������䴦����Ҫ�����αꡣ
--       3�����ڱ����ӡ��һ�㲻�践��ֵ����ʹ�ù��̷�װ��
--�ο��Ľ��������
--  1��������淶
  create or replace package report_pack
  is
    /*��������İ༶�ţ���ӡ��ǰ�༶��Ϣ����ǰ���ѧ����Ϣ*/
    procedure student_of_class(p_clno class.clno%type);
  end report_pack;
--  2������report_pack���İ���������£�
  create or replace package body report_pack
  is
  /*ʵ�ֹ���student_of_class*/
    procedure student_of_class(p_clno class.clno%type)
    is
      /*ע�Ͳ���*/
      cursor student_cursor is select * from student where clno = p_clno; -- �����α�
      student_record student%rowtype;  -- ����ѧ����¼����
      class_record class%rowtype; -- ����༶��¼����
      v_count number(2);  -- ��¼ѧ����������
      v_sex char(2);  -- �Ա����
    begin 
      select * into class_record from class where clno = p_clno;  -- ȡ�ð༶��Ϣ
      select count(*) into v_count
      from student 
      where clno = p_clno;
--      group by clno;   -- ȡ�ð༶����
      dbms_output.put_line(class_record.dept||'ϵ'||class_record.grade||class_record.branch||'�ܹ��У�'|| v_count||'��');
      dbms_output.put_line('-----------------------------------');
      /*ȡ�õ�ǰ�༶ѧ����Ϣ*/
      open student_cursor;
      loop
        fetch student_cursor into student_record;
        exit when student_cursor%notfound;
        if student_record.sex = '1' then v_sex:='��';
                                    else v_sex:='Ů';
        end if;
        dbms_output.put_line('ѧ���ţ�'||student_record.sno||',������'||student_record.name||',���䣺'||student_record.age||',�Ա�'||v_sex
        ||',��ѧ���ڣ�'||to_char(student_record.entrance,'yyyy-mm-dd'));
      end loop;
      close student_cursor;
      
      exception 
        when no_data_found then
          dbms_output.put_line('ָ���İ༶�Ų�����');   
     end student_of_class;
     end report_pack;
     
begin
  report_pack.student_of_class('cc101');
end;
      
--
--select * from class;
--select * from student;
--select * from teacher;
--select * from st;






















-- �������ӡ����ͳһ��װ�����������ͳһά��
/*
������
    1.���ṹ�Ĺ���һ�����ģ�鹦�������壬��ѧ����������Ϊһ����
    2.������䴦���α�
    3.�����ӡ����Ҫ����ֵ����ʹ�ù��̷�װ
*/

--���������
-- 1.������淶
create or replace package report_pack
is procedure student_of_class(p_clno class.clno%type);  -- ��������İ༶�ţ���ӡ��ǰ�༶��Ϣ����ǰ���ѧ����Ϣ
end report_pack;
--2.����report_pack���İ���������£�
create or replace package body report_pack
is procedure student_of_class(p_clno class.clno%type)  -- student_of_classʵ�ֹ���
is
    cursor student_cursor is
    select * from student where clno=p_clno;
    student_record student%rowtype
    class_record class%rowtype;
    v_count number(2);
    v_sex char(2);
begin
    select * into class_record from class where clno = pclno; -- ȡ�ð༶��Ϣ
    select count(*) into v_count from student where clno = pclno
    group by clno;
    dbms_output.put_line(class_record.dept||'ϵ'||class_recoed.grade||class_record.grade||class_record.branch||'�ܹ��У�'||v_count||'��')
    dbms_output.put_line��'-----------------------------------------------------'��;
    -- ȡ�õ�ǰ�༶ѧ����Ϣ
    open student_cursor;
    loop
        fetch student_cursor into student_record;
        exit when student_cursor%notfound;
        if student_record.sex='1' then v_sex:='��';
                                  else v_sex:='Ů';
        end if;
        dbms_output.put_line('ѧ����'||student_record.sno||',������'||student_record.name||',���䣺'||student.record.age||',�Ա�'||v_sex||',��ѧ���ڣ�'||to_char(student.record.entrance,'yyyy-mm-dd'));
        
        
    end loop;
    -- �ر��α�
    close student_cursor;
    exception
        when no_data_found then
            dbms_output.put_line('ָ���İ༶�Ų�����');
end student_of_class;
end record_pack; 
            
            
begin
    report_pack.student_of_class('cc101');
end;



/*======================================================*/

conn system/system;

show user;

passw hr;

grant connect to hr;

conn hr;

show user;









