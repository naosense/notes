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
