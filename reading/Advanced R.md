### 2.数据结构

1.按维度，R语言共有以下几种数据结构，

|维度|同性质|不同性质|
|--|--------|--------|
|1d|向量(vector)|列表(list)|
|2d|矩阵(matrix)|数据框(data frame)|
|nd|数组(array)||
需要注意是R语言中没有标量。用`str`函数获得数据的结构。

2.向量(vector)
对于向量有几个重要的函数：

- `typeof()`获得向量的类型，向量有四种类型*logical, integer, double (often called numeric), character*
- `length`获得元素的个数
- `attributes()`，设置属性

```
# double
dbl_var <- c(1, 2, 4)
# 如果想要integer，需要在数字后面加L后缀
int_var <- c(1L, 6L, 10L)
```

注意`c()`嵌套是不起作用的。NA表示缺失值，有一点需要强调，尽管都是确实值，但是NA也有类型之分，比如*NA_real_ (a double vector),NA_integer_ and NA_character_*。

测试向量类型的函数有`is.character(), is.double(),is.integer(), is.logical()`，以及`is.atomic()`，`is.numeric()`验证一个向量是否是数值型，包括*integer*和*double*。

3.强制转换
强制转换的原则是从具体的类型转换为更通用的类型，顺序为：*logical, integer,double,character*

4.列表(list)
列表的元素类型可以不同，并且可以嵌套。

列表和向量可以相互转换，函数为`as.list()`和`unlist()`，如果list的元素类型不同，`unlist()`的转换规则和`c()`一样。

列表常用来构造一些复杂的类型，比如数据框和回归模型。

5.属性
属性类似于一个列表，几个有用的函数，

- `attr()`和`attribute()`可以访问对象的属性
- `structure()`返回一个属性被修改的新对象

默认情况下，一个向量如果被修改了，大部分属性就会丢失，除了**名字(name),维度(dimensions),类(class)**这三个属性，并且有专门的函数可以访问它们，`name(x),dim(x),class(x)`
