-- 新建表空间wsl001
create tablespace wsl001 datafile 'D:\wsl001.dbf' size 20m uniform size 128k;

-- 创建school用户
create user school identified by wslrrr;
grant dba to school;

-- 连接school
conn school/wslrrr;

-- 建表class
create table class(
clno varchar2(5) primary key,
dept varchar2(40) not null,
grade varchar2(8) not null,
branch varchar2(20) not null
)tablespace wsl001;

-- 添加check约束
alter table class
add constraint ck_class_grade check(grade in('大一','大二','大三','大四'));

-- 建表student
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

-- 添加两张表的注释
comment on table student is '学生信息表';
comment on table class is '班级信息表';

-- 建表course
create table course(
cno varchar2(5) primary key,
name varchar2(60) not null,
score number(2) not null
)tablespace wsl001;

-- 建表teacher
create table teacher(
tno varchar2(5) primary key,
name varchar2(12) not null,
age number(2),
cno varchar2(5) not null,
constraint fk_con foreign key(cno)references course(cno)
)tablespace wsl001;

-- 建学生选课表st
create table st(
sno varchar2(5) not null,
tno varchar2(5) not null,
grade number(2) default 0,
constraint  pk_sno_tno primary key(sno,tno)
)tablespace wsl001;

-- 追加注释
comment on table course is '课程信息表';
comment on table teacher is '教师信息表';
comment on table st is '学生选课表';

-- 查看teacher表结构
desc teacher;

-- 数据维护
-- 在学生信息系统教学模块相关联的数据表中添加测试数据
-- 用insert into语句按顺序添加数据

-- 1、class表中添加数据
insert into class values('cc101', '计算机', '大一', '一班');
insert into class values('cc102', '计算机', '大一', '二班');
select * from class;

-- 2、向学生信息表添加数据
insert into student values('95001', '赵云', 21, '1', '01-9月-2006', '青岛', 'cc101');
insert into student values('95002', '关羽', 21, '1', to_date('2006-9-1', 'yyyy-mm-dd'), '天津', 'cc101');
insert into student values('95003', '张飞', 23, '1', to_date('2006-9-1', 'yyyy-mm-dd'), '青岛', 'cc101');
insert into student values('95004', '貂蝉', 20, '0', to_date('2006-9-1', 'yyyy-mm-dd'), '北京', 'cc102');
insert into student values('95005', '小乔', 23, '0', to_date('2006-9-1', 'yyyy-mm-dd'), '上海', 'cc102');
select * from student;

-- 3、向课程信息表添加数据
insert into course values('cn001', '数据库原理', 4); 
insert into course values('cn002', '数据结构', 4); 
insert into course values('cn003', '编译原理', 2); 
insert into course values('cn004', '程序设计', 2); 
insert into course values('cn005', '高等数学', 3); 
select * from course;

-- 4、向教师信息表添加数据
insert into teacher values('T8101', '刘华', 34, 'cn001');
insert into teacher values('T8102', '李明', 32, 'cn002');
insert into teacher values('T8103', '王刚', 28, 'cn002');
insert into teacher values('T8104', '张雪', 33, 'cn003');
insert into teacher values('T8105', '赵顺', 32, 'cn004');
insert into teacher values('T8106', '周刚', 32, 'cn005');
select * from teacher;

-- 5、向学生选课表添加数据
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

-- 基本表中添加必要的约束
-- 学生信息表中需要的约束student
alter table student
add constraint ck_student_age check(age > 16 and age < 41);
alter table student
add constraint ck_student_sex check(sex in ('0', '1'));

-- course的约束
alter table course
add constraint ck_course_score check(score > 0 and score < 10);

-- teacher的约束
alter table teacher
add constraint ck_teacher_age check(age > 20 and age < 66);

-- st的约束
-- st的外键约束
alter table st
add constraint fk_st_sno foreign key(sno) references student(sno);
alter table st
add constraint fk_st_tno foreign key(tno) references teacher(tno);
-- st的check约束
alter table st
add constraint ck_st_grade check(grade >= 0 and grade <= 9);

-- 视图
-- 在学生管理系统的school（教学）模块的开发过程中，需要实现以下的数据查询页面

-- ①学生信息查询页面：提供系、年级、班级、学号、学生姓名、年龄、性别、入学日期
-- 创建学生信息查询页面视图
create or replace view vw_class_student
as
select c.dept, c.grade, c.branch, s.sno, s.name, s.age, s.sex, s.entrance
from class c join student s on c.clno = s.clno
with read only;
select * from vw_class_student;

-- ②授课信息查询页面：提供教师号、姓名、年龄及其所任课程编号、课程名称
create or replace view vw_teacher_course
as
select t.tno, t.name tname, t.age, c.cno, c.name cname
from teacher t join course c on t.cno = c.cno
with read only;
select * from vw_teacher_course;

-- ③选课信息查询页面：学生号、学生姓名、所选课程编号、课程名称
create or replace view vw_student_course
as 
select s.sno, s.name sname, c.cno, c.name cname
from student s join st st on s.sno = st.sno
join  teacher t on st.tno = t.tno
join course c on t.cno = c.cno
with read only;
select * from vw_student_course;
-- ④任教信息查询页面：提供系、年级、班级及在当前班担当授课任务的教师姓名：
create or replace view vw_class_teacher
as 
select distinct c.dept "系", c.grade "年级", c.branch "班级", t.name "教师姓名"
from class c join student s on c.clno = s.clno
join st st on s.sno = st.sno
join teacher t on st.tno = t.tno
with read only;
select * from vw_class_teacher;

-- ⑤班级课程查询页面：提供系、年级、班级及当前班所覆盖的课程名称
create or replace view vw_class_course
as
select distinct cl.dept "系", cl.grade "年级", cl.branch "班级", c.NAME "课程名称"
from class cl join student s on cl.clno = s.clno
join st st on s.sno = st.sno
join teacher t on t.tno = st.tno
join course c on t.cno = c.cno
with read only;
select * from vw_class_course order by "课程名称";

-- 需要针对学生管理，实现以下的数据统计页面

-- ①班级人数统计页面：按班级分组，统计每个班级的学生人数
create or replace view vw_class_count
as
select c.dept 系, c.grade 年级, c.branch 班级, count(*) 学生人数
from class c join student s on c.clno = s.clno
group by (c.dept, c.grade, c.branch);
select * from vw_class_count;

conn school/wslrrr;
show user;

-- ②学生成绩统计页面：按班级、学生分组，统计每个学生的成绩总和及所选修的课程数
create or replace view vw_student_count
as
select c.dept 系, c.grade 年级, c.branch 班级, s.name 学生姓名, count(*) 课程数, sum(st.grade) 成绩
from class c join student s on c.clno = s.clno
join st st on st.sno = s.sno
group by (c.dept, c.grade, c.branch, s.name);
select * from vw_student_count;

-- ③学生成绩列表页面：输出所有学生对现有课程的选修得分
-- decode函数：第一个参数与第二个参数进行对比。若一致，则返回第三个参数；否则，返回第四个参数
create or replace view vw_student_grade
as
select s.name 姓名, 
sum(decode(c.name, '数据库原理', grade, null)) 数据库原理,
sum(decode(c.name, '数据结构', grade, null)) 数据结构,
sum(decode(c.name, '编译原理', grade, null)) 编译原理,
sum(decode(c.name, '程序设计', grade, null)) 程序设计,
sum(decode(c.name, '高等数学', grade, null)) 高等数学
from student s join st st on s.sno = st.sno
join teacher t on t.tno = st.tno
join course c on t.cno = c.cno
where c.name in ('数据库原理', '数据结构', '编译原理', '程序设计', '高等数学')
group by s.name;
select * from vw_student_grade;

-- 用记录类型变量完成DML操作
declare
  -- 使用%rowtype声明class的记录类型变量
  class_record class%rowtype;
  row_id       rowid;  -- 记录行ID
  info         varchar2(80);  -- 记录数据操作信息
begin
  class_record.clno:='cc103';
  class_record.dept:='自动化';
  class_record.grade:='大三';
  class_record.branch:='一班';
  
  /*使用记录类型变量完成数据插入操作*/
  insert into class values class_record
  returning rowid, clno||','||DEPT||','||GRADE||','||branch into row_id, info;
  dbms_output.put_line('插入:'||row_id||':'||info);
  
  /*完成记录的整行修改*/
  class_record.clno:='cc104';
  update class set row=class_record where clno = 'cc103'
  returning rowid, clno||','||DEPT||','||GRADE||','||branch into row_id, info;
  dbms_output.put_line('修改:'||row_id||':'||info);
  
  /*完成部分列的修改*/
  class_record.branch:='二班';
  update class set branch=class_record.branch where clno=class_record.clno
  returning rowid, clno||','||dept||','||grade||','||branch into row_id, info;
  dbms_output.put_line('修改:'||row_id||':'||info);
  
  /*基于记录类型变量进行数据删除*/
  delete from class where clno = class_record.clno
  returning rowid, clno||','||dept||','||grade||','||branch into row_id, info;
  dbms_output.put_line('删除:'||row_id||':'||info);
  
  exception
    when others then
      dbms_output.put_line('出现某种异常!');
end;

-- 使用嵌套表
-- 1、创建嵌套表类型
create or replace type family_type is table of varchar2(20);

-- 2、调整student表
alter table student add(
  family family_type
)nested table family store as family_table;

-- 添加数据
insert into student
values('95006', '昭君', 19, 0, to_date('2006-09-01', 'yyyy-mm-dd'), '上海', 'cc102', family_type('父亲','母亲','姐姐'));

-- 需要检索嵌套表列的数据时，需要定义嵌套表变量接受数据
declare
  /*声明family_type类型变量用于接收检索结果*/
  family_table family_type;
  v_name student.name%type;
begin
  select name, family into v_name, family_table from student where sno = &sno;
  dbms_output.put_line(v_name||'的亲属有：');
  for i in 1..family_table.count
  loop
    dbms_output.put_line(family_table(i)||' ');
  end loop;
  dbms_output.new_line();  
  exception
    when no_data_found then
      dbms_output.put_line('指定学生不存在');
end;

-- 5、需要更新嵌套表的数据
declare
  family_table1 family_type:=family_type('父亲', '母亲', '哥哥');
  family_table2 family_type;
  v_sno student.sno%type:=&sno;
  v_name student.name%type;
begin
  /*使用嵌套表变量更新嵌套表列*/
  update student set family=family_table1 where sno=v_sno;
  /*获取更新后的数据*/
  select name, family into v_name, family_table2 from student where sno=v_sno;
  dbms_output.put_line('学生' || v_name || '的亲属有:');
  for i in 1 .. family_table2.count
  loop
    dbms_output.put_line(family_table2(i)||' ');
  end loop;
  dbms_output.new_line();
  exception
    when no_data_found then
    SYS.DBMS_OUTPUT.PUT_LINE('指定学生号不存在');
end;
  
 游标（指针）：Oracle为用户开设的一个数据缓冲区，存放SQL语句的执行结果
 Oracle数据库中执行的每个SQL语句都有对应的单独的游标
 隐式游标：处理的都是单行select into和DML语句
 显示游标：处理select语句返回的多行数据。

--A、定义游标 cursor cursor_name [...]is select_statement;
declare
-- 错误：cursor class_cursor is select clno, dept from class;
    cursor class_cursor is select * from class;
--    v_clno class.clno%type;
--    v_dept class.dept %type;
    class_record class%rowtype;
-- B、打开游标：open cursor_name
begin
    open class_cursor;
--C、提取游标数据：fetch cursor_name into {variable_list|record_variable};
    loop
--      fetch class_cursor into v_clno, v_dept;
      fetch class_cursor into class_record;
      exit when class_cursor%notfound or class_cursor%rowcount > 2; 
--      dbms_output.put_line('班级号' || v_clno ||','||'系'||v_dept);
      dbms_output.put_line('班级号' || class_record.clno || ',' ||'系'||class_record.dept);
    end loop;
--D、对游标指针指向的记录进行处理
--E、继续处理，直到循环体中没有记录
--F、关闭游标：close cursor_name
    close class_cursor;
end;
select * from class;
--游标属性
--%notfound
--%found
--%rowcount:返回提取的实际行数
--%isopen
--异常处理exception
declare
  v_n1 int:= &n1;
  v_n2 int:= &n2;
  v_div int;
begin
  v_div:=v_n1/v_n2;
  dbms_output.put_line(v_n1 || '/' || v_n2 || '=' || v_div);
exception
  when zero_divide then
    dbms_output.put_line('除数不能为0!');
  when others then
    dbms_output.put_line('出现未知错误!');
end;

--PL/sql块：匿名块，子程序
--触发器（trigger）分类
--1、语句触发器：在执行DML操作时，将激活该类触发器
--2、行触发器
create or replace trigger trg_class
before insert or update or delete on class
declare
v_now varchar2(30);
begin
  v_now:=to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss');
  case
    when inserting then
      dbms_output.put_line(v_now || '对class表进行了insert操作');
  end case;
end;

insert into class values('cc105', '自动化', '大三', '一班');

--鉴于系统要求，经常需要打印报表信息，为方便维护，需将报表打印过程统一封装，并放入包内统一维护
--分析：1、包结构的功能一般根据模块功能来定义，可将对学生表的操作定义为一个包。
--       2、对于报表打印，一般涉及多行语句处理，需要引入游标。
--       3、由于报表打印，一般不需返回值，可使用过程封装。
--参考的解决方案：
--  1、定义包规范
  create or replace package report_pack
  is
    /*根据输入的班级号，打印当前班级信息及当前班的学生信息*/
    procedure student_of_class(p_clno class.clno%type);
  end report_pack;
--  2、对于report_pack包的包体代码如下：
  create or replace package body report_pack
  is
  /*实现过程student_of_class*/
    procedure student_of_class(p_clno class.clno%type)
    is
      /*注释部分*/
      cursor student_cursor is select * from student where clno = p_clno; -- 定义游标
      student_record student%rowtype;  -- 定义学生记录类型
      class_record class%rowtype; -- 定义班级记录类型
      v_count number(2);  -- 记录学生人数变量
      v_sex char(2);  -- 性别变量
    begin 
      select * into class_record from class where clno = p_clno;  -- 取得班级信息
      select count(*) into v_count
      from student 
      where clno = p_clno;
--      group by clno;   -- 取得班级人数
      dbms_output.put_line(class_record.dept||'系'||class_record.grade||class_record.branch||'总共有：'|| v_count||'人');
      dbms_output.put_line('-----------------------------------');
      /*取得当前班级学生信息*/
      open student_cursor;
      loop
        fetch student_cursor into student_record;
        exit when student_cursor%notfound;
        if student_record.sex = '1' then v_sex:='男';
                                    else v_sex:='女';
        end if;
        dbms_output.put_line('学生号：'||student_record.sno||',姓名：'||student_record.name||',年龄：'||student_record.age||',性别：'||v_sex
        ||',入学日期：'||to_char(student_record.entrance,'yyyy-mm-dd'));
      end loop;
      close student_cursor;
      
      exception 
        when no_data_found then
          dbms_output.put_line('指定的班级号不存在');   
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






















-- 将报表打印过程统一封装，并放入包内统一维护
/*
分析：
    1.包结构的功能一般根据模块功能来定义，将学生操作定义为一个包
    2.多行语句处理，游标
    3.报表打印不需要返回值，可使用过程封装
*/

--解决方案：
-- 1.定义包规范
create or replace package report_pack
is procedure student_of_class(p_clno class.clno%type);  -- 根据输入的班级号，打印当前班级信息及当前班的学生信息
end report_pack;
--2.对于report_pack包的包体代码如下：
create or replace package body report_pack
is procedure student_of_class(p_clno class.clno%type)  -- student_of_class实现过程
is
    cursor student_cursor is
    select * from student where clno=p_clno;
    student_record student%rowtype
    class_record class%rowtype;
    v_count number(2);
    v_sex char(2);
begin
    select * into class_record from class where clno = pclno; -- 取得班级信息
    select count(*) into v_count from student where clno = pclno
    group by clno;
    dbms_output.put_line(class_record.dept||'系'||class_recoed.grade||class_record.grade||class_record.branch||'总共有：'||v_count||'人')
    dbms_output.put_line（'-----------------------------------------------------'）;
    -- 取得当前班级学生信息
    open student_cursor;
    loop
        fetch student_cursor into student_record;
        exit when student_cursor%notfound;
        if student_record.sex='1' then v_sex:='男';
                                  else v_sex:='女';
        end if;
        dbms_output.put_line('学生号'||student_record.sno||',姓名：'||student_record.name||',年龄：'||student.record.age||',性别：'||v_sex||',入学日期：'||to_char(student.record.entrance,'yyyy-mm-dd'));
        
        
    end loop;
    -- 关闭游标
    close student_cursor;
    exception
        when no_data_found then
            dbms_output.put_line('指定的班级号不存在');
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









