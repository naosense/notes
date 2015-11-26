### 第一章 PL/SQL概述

1.什么是PL/SQL?

- 嵌入式语言
- 标准可移植的语言
- 高性能、高集成度

2.一些建议

- 不要太着急
 - 在开始编写代码之前构建测试用例和测试脚本
 - 就开发人员如何编写sql制定一个清晰的规则，比如将sql封装在过程或函数背后。
 - 如何处理异常有清晰的规则，比如创建一个单独的包来处理异常，而不是每个人都写一个。
 - 使用“逐步细化”的方法，避免任何时候处理的需求过于复杂。
- 不要怕寻求帮助

### 第二章 创建并运行PL/SQL代码

1.sqlplus
启动sqlplus有几种方式，
```
os>sqlplus
# 这种方式不推荐，会直接看到密码
os>sqlplus username/password
# 多用户环境，加nolog只会进入sql环境，不会登陆系统，然后用connect
os>sqlplus /nolog
os>connect username/password
# 连接远程数据库
os>connect username/password@连接标识符(也称为服务名)
```

运行一个过程，
```sql
sql>BEGIN
      DBMS_OUTPUT.PUT_LINE('hello world')
    END;
    /
```

- 最后的/是必须的，这标志着你完成了程序的输入，它的含义是执行刚录入的这个语句
- /只能单独放在一行
- 9i之前的版本/前面不能有空格，后面的版本可以

还有一个EXECUTE命令可以很方便的执行过程，
```sql
EXEC DBMS_OUTPUT.PUT_LINE('hello world')
```
最后的分号也是可选的。

运行脚本的命令，`@过程`或者`START过程`

*什么是当前目录？当前目录通常情况下是你在进入sqlplus之前所处的目录，注意sqlplus默认在当前目录查找文件，在不加路径的情况下。当在调用的过程中又调用了其他的过程时，`@@`命令很有用，它假设当前目录已改成当前执行文件所处的目录。*

2.sqlplus个性化配置

查看当前回话的设置，使用`SHOW ALL`命令，支持两种变量定义，
```
sql>DEFINE x = "the answer is 42"
-- 查看x的值
sql>DEFINE x
-- 引用x的值要加&，当x为字符串时还要加引号
select '&x' from dual;

```
第二种
```
sql>VARIABLE x VARCHAR2(10)
sql>BEGIN
      :x := 'hullo'
    END;
sql>PRINT x
```
前一种只是被扩展，后面才能被sql和plsql作为真正的绑定变量。

保存结果到文件，
```
SPOOL report
执行语句
SPOOL OFF
```

自定义文件位置*$ORACLE_HOME/sqlplus/admin/glogin.sql*，常用的设置项为

- SET PAGESIZE 999
- SET LINESIZE 132，设置一行显示的最大字符
- SET SERVEROUTPUT ON：默认情况下不输出DBMS_OUTPUT的输出
- DEFINE _EDITOR = 完整路径，设置sqlplus的默认编辑器

错误处理，默认情况下，sqlplus报告错误然后会继续执行，通过`WHENEVER SQLERROR EXIT SQL.SQLCODE`来设置当sqlplus遇到错误时将终止程序。

CREATE OR REPLACE只会替换相同类型的对象



### 第三章 语言基础

1.块结构

- 块头，只有命名块才有这个单元，这个单元是可选的。
- 声明单元，这部分定义变量、游标，这一单元也是可选的。
- 执行单元，这一部分是必须的。
- 异常处理单元，这一部分也是可选的。

```sql
块头
IS
  声明单元
BEGIN
  执行单元
EXCEPTION
  异常处理单元
END;
```

一个典型的命名块，
```sql
PROCEDURE get_happy(ename_in IN VARCHAR2)
IS
  l_hiredate DATE;
BEGIN
  l_hiredate := SYSDATE - 2;
  INSERT INTO employee
    (emp_name, hiredate)
  VALUES (ename_in, l_hiredate);
  EXCEPTION
    WHEN DUP_VAL_IN_INDEX
    THEN
      DBMS_OUTPUT.PUT_LINE
        ('Cannot insert.')；
  END;
```
匿名块

```sql
[DECLARE ...声明语句...]
BEGIN ...一个或多个执行语句...
[EXCEPTION
...异常处理语句...]
END;
```

匿名块的用处：

- 数据库触发器
- 即席命令（ad hoc）和脚本文件，EXECUTE命令最终会翻译为一个匿名块
- 编译后的3GL程序，匿名块可以嵌入到这些程序中来调用存储程序

嵌套块

```sql
PROCEDURE calc_totals
IS 
  year_total NUMBER;
BEGIN
  year_total := 0;
  -- 嵌套块开始
  BEGIN
    month_total := year_total / 12;
  END set_month_total;
END;
```

**规范sql中对变量和列的引用**
对变量和列的引用要通过表的别名、包名、过程名、嵌套块标签进行规范化，这样做的好处，

- 可读性
- 避免变量名和列名一样时出现bug，Oracle数据库首先会把不规范的标示符当做列名来解释
- 充分利用oracle 11g细粒度依赖这一特性

```sql
PACKAGE scope_demo
IS 
  g_global NUMBER;
  PROCEDURE set_global(number_in IN NUMBER);
END scope_demo;

PACKAGE BODY scope_demo
IS
  PROCEDURE set_global(number_in IN NUMBER)
  IS
    l_salary NUMBER := 10000;
    l_count PLS_INTEGER;
  BEGIN
    <<local_block>>
    DECLARE
      l_inner PLS_INTEGER;
    BEGIN
      SELECT COUNT(*)
        INTO set_global.l_couunt
        FROM employee e
        WHERE e.depart_id = localblock.l_inner
        AND e.salary > set_global.l_salary;
     END localblock;
     
     scope_demo.g_global := set_global.num_in;
  END set_global;
```
2.字符集

- ;代表一个语句的结束
- %属性指示符，游标属性（%ISOPEN），间接声明属性（%ROWTYPE），也可作like中的通配符
- _单个下划线，like中任意单个字符的通配符
- @远程位置指示符
- :冒号宿主变量指示符，:block.item
- \**双星号，幂运算符
- <>或!=不等于
- ||拼接操作符
- <<>>标签分隔符
- :=赋值操作符
- =>位置表示法关联操作符
- ..两个句点，范围操作符

字符组成了词法单位，也称为语言的原子，PLSQL中一个词法单位可以是，

- 标示符，最多30个字符，必须字母开始，可以使用$、#、_，不能有空白
- 直接量，包括数字、字符串、时间间隔、布尔值等
- 分隔符
- 注释

> NULL
在oracle数据库中，缺失值为NULL，一个空字符串（NULL）和0个字符的直接量（''）没有区别。在PLSQL中将一个''赋给varchar2(n)导致的结果就是NULL，而赋给char(n)的结果是使用空格占满这个变量，而在数据库中结果则为NULL

---

在字符串中插入单引号，自oracle10g可以使用q加上字符串来避免里面单引号转义，具体见P68。

使用if时，要注意条件为NULL的情况。

3.PROGMA关键字

progma通常是一行告诉编译器该采取什么行动的代码。
语法为：`PROGMA instruction_to_compiler`

PLSQL 提供了几个progma：

- AUTONOMOUS_TRANSACTION，这个指令告诉编译器，当前块对数据库所做的修改提交或回滚，不影响主事务或外层事务
- EXCEPTION_INIT，这个指令告诉编译器把一个特殊的错误号和程序中声明的异常标示符关联起来，必须跟在异常声明之后。
- RESTRICT_REFERENCES，定义一个包程序的纯度级别
- SERIALLY_REUSABLE，告诉运行时引擎，包级别的数据在引用之间不应该保留

4.标签

标签的写法为：`<<identifier>>`

作用：

- 增强代码清晰可读性，标签具有自我说明的能力
- 从内嵌的代码中引用外层代码的变量具有相同名字的变量
- 作为GOTO语句的目标





