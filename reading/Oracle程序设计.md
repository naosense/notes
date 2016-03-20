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
> 在oracle数据库中，缺失值为NULL，一个空字符串（NULL）和0个字符的直接量（''）没有区别。在PLSQL中将一个''赋给varchar2(n)导致的结果就是NULL，而赋给char(n)的结果是使用空格占满这个变量，而在数据库中结果则为NULL


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

### 第四章 条件和顺序控制

1.if语句

| if类型 | 特点 |
|--------|--------|
| if then end if; | 最基本的形式 |
| if then else end if; | 二选一 |
| if then elsif else end if; | 多选形式，oracle9以后的版本可以考虑case语句 |

> 1.三值逻辑
> 
> 逻辑表达式可能返回值为true，false以及null，但是对于if的条件来说，后两种都视为不通过
> 
> 2.使用布尔标志，即将布尔值存到一个变量里
> 
> `order_exceeds_balance := :customer.order_total > max_allowable_order`,这样就可以在if语句中反复使用

避免if语句陷阱

- 一个if要有一个匹配的end if
- end if之间必须要有空格
- elsif没有e
- 只在end if后面加分号

短路求值：`if condition1 and condition2`

当condition1为false或null时，plsql就会停止对整个表达式的求值

> 在赋值时这种情况就不同了，例如下面的代码
> `my_condition := condition1 and condition2`
> 当condition1为null时，求值不会停止，因为my_condition的值是null还是false取决于condition2的值

2.case语句和表达式

case语句的几种情形：

- 简单case语句

```sql
CASE expression
WHEN result1 THEN
     statement1
WHEN result2 THEN
     statement2
...
ELSE
	statement_else
END CASE;
```

else语句是可选的，尽管如此，尽量使用else，因为如果when语句没有一条匹配，且没有else，case语句最后会抛出case_not_found错误。

与传统语言的case不同，这里只要有一个情况匹配，执行就会停止，而不用加break。

- 搜索型case语句

```sql
CASE
WHEN expression1 THEN
     statement1
WHEN expression2 THEN
     statement2
...
ELSE
	statement_else
END CASE;
```

本质上搜索性case语句等同于前面简单case语句的case true情形。

- 嵌套型case语句

case表达式

case表达式有两种情况，如下，

```sql
简单case表达式 := 
CASE expression
WHEN result1 THEN
     result1_expression
WHEN result2 THEN
     result2_expression
...
ELSE
	result_expression_else
END;

搜索case表达式 :=
CASE
WHEN expression1 THEN
     result1
WHEN expression2 THEN
     result2
...
ELSE
	result_else
END;
```

case表达式以一个end结束，每个when都关联一个表达式而不是语句，不要加分号。

3.goto语句

goto语句的常见形式为`goto label_name`

goto语句有以下限制：

- 一个标签后面至少有一个执行语句
- 目标标签必须和goto语句在同一个作用域
- goto目标标签和goto语句必须在plsql的相同部分

4.null语句

有时候我们需要一条语句什么都不做，null语句就是干这个的，类似于python的pass

### 第五章 用循环进行迭代处理

plsql提供了三种循环：

- 简单循环或无线循环
- for循环(数值循环和游标循环)
- while循环

1.简单循环

```sql
LOOP
    statements
END LOOP;
```
简单循环只有遇到exit或exit when或者一个异常才会终止。

什么时候用exit和exit when呢？

- 当只有一种情况退出时使用exit when
- 有多个情况退出使用exit，与if或case搭配使用

2.while循环

```sql
WHILE condition
LOOP
    statement
END LOOP;
```

3.数值型for循环

```sql
FOR loop_index IN [REVERSE] low .. high
LOOP
    statement
END LOOP;
```

使用数值型for循环的规则：

- 不用声明循环索引，plsql会隐式的声明一个integer类型的局部变量，作用范围是循环本身
- 如果边界中包含表达式，表达式在进入循环时会求值一次，往后不会改变即使循环体改变了表达式的值
- 在循环体不要改变索引值和边界值，这是非常不好的习惯
- 使用reverse关键字时，上下边界的位置不要调换
- 步长无法调节，永远为1

4.游标for循环

```sql
FOR record IN {cursor_name | select statement}
LOOP
    statement
END LOOP;
```

record的类型通过cursor_name的%ROWTYPE属性隐式声明

5.continue语句

作用可以终止本次循环进入下一次

6.迭代处理的技巧

- 循环索引使用容易理解的名字
- 好的退出方式，one way in，one way out
 - 在for和while中不要使用exit或exit when，如果不能消除exit可以使用简单循环
 - 在循环中尽量不要使用return和goto，这会导致不成熟，非结构化的循环结束

7.纯sql和plsql代码的权衡

sql代码往往是全或无的逻辑，比如插入一些数据，只要有一行失败整个sql语句就会失败，而plsql提供了一次访问一条记录的能力，如果你需要这种能力那么就把sql和plsql混合起来使用吧，否则使用sql就够了，这样代码更简洁，效率也更高。

### 第六章 异常处理

一些概念和术语

异常分类：

- 系统产生的错误
- 用户导致的错误
- 应用程序发出的警告

术语：

- 作用范围：可以抛出异常的代码部分，也包括能够铺货和处理抛出异常的代码部分
- 传播：一个异常没有在当前块处理，从当前块传给外层块的过程
- 未处理异常：一个异常如果传播到最外层块仍没有被处理，称为未处理异常

1.定义异常

plsql中的异常分为两种：有名或匿名，standard包里定义了一些有名异常，但更大部分的异常都是匿名的。

声明有名异常

- 异常已经存在，现在只不过给它起一个名字，要在过程的声明部分采用`exception_name EXCEPTION`的形式进行声明，然后使用`PROGMA EXCEPTION_INIT(exception_name, errcode)`将异常名称与错误代码关联起来
- 异常事先不存在，可以使用`RAISE_APPLICATION_ERROR(errcode, errmsg)`进行定义，然后采用上面的方法进行关联


