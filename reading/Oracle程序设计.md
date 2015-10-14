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
- SET LINESIZE 132
- SET SERVEROUTPUT ON：默认情况下不输出DBMS_OUTPUT的输出
- DEFINE _EDITOR = 完整路径

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
