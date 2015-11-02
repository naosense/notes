# Advanced R

### 2.数据结构

#### 2.1 向量(vector)

R语言中的数据类型大致可以分为，

- 一维：向量(vector)，列表(list)
- 二维：矩阵(matrix)，数据框(dataframe)
- n维：数组(array)

向量有三个共同的属性，

- 类型，typeof()
- 长度，元素的个数，length()
- 属性，attributes

向量的元素类型必须相同，列表(list)可以不同

要判断一个对象是否是向量，不能使用is.vector()而要用is.atomic() || is.list()

#### 2.1.1 原子向量(atomic vector)

向量共有六种类型，分别为logical、integer、double、character、complex、raw，integer类型数字后面加L后缀，另外c()函数不起作用，向量永远是平的。缺失值为NA，注意NA也有logical、integer等之分。

#### 2.1.1.1 向量类型测试

- is.logical()
- is.integer()
- is.double()
- is.character()
- is.atomic()
- is.numeric()

#### 2.1.1.2 强制转换

因为向量的元素类型必须一致，所以当类型不一致时就会进行转换，顺序为logical>integer>double>character

#### 2.1.2 列表(list)


```r
x <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
str(x)
```

```
## List of 4
##  $ : int [1:3] 1 2 3
##  $ : chr "a"
##  $ : logi [1:3] TRUE FALSE TRUE
##  $ : num [1:2] 2.3 5.9
```

c()会把元素拆开为独立的个体，list可以保留元素的固有类型，


```r
x <- list(list(1, 2), c(3, 4))
y <- c(list(1, 2), c(3, 4))
str(x)
```

```
## List of 2
##  $ :List of 2
##   ..$ : num 1
##   ..$ : num 2
##  $ : num [1:2] 3 4
```

```r
str(y)
```

```
## List of 4
##  $ : num 1
##  $ : num 2
##  $ : num 3
##  $ : num 4
```

将列表转换为向量使用unlist(),向量转为列表使用as.list()

#### 2.1.3 作业

1.atomic vector的六种类型？list与atomic的区别？

atomic六种类型为int，double，logic，character，complex，raw。list元素类型可以不同，vector只能同种类型，list可以嵌套，vector不能嵌套。

2.is.vector和is.numeric与is.list和is.character有什么根本的区别？

is.vector测试一个向量是否只有名字属性，要测试一个对象是否为向量用is.atomic(x)||is.list(x)，is.list()测试是否为列表，is.numeric测试一个对象是否是数值型，包括integer和double，is.character测试一个向量是否是字符型。

3.强制转换


```r
c(1, F)
```

```
## [1] 1 0
```

```r
c("a", 1)
```

```
## [1] "a" "1"
```

```r
c(list(1), "a")
```

```
## [[1]]
## [1] 1
## 
## [[2]]
## [1] "a"
```

```r
c(T, 1L)
```

```
## [1] 1 1
```

4.将列表转换成向量为什么要用unlist而不用as.vector?

5.解释下面表示的结果


```r
1 == "1"
```

```
## [1] TRUE
```

```r
-1 <= FALSE
```

```
## [1] TRUE
```

```r
"one" < 2
```

```
## [1] FALSE
```

6.为什么NA是一个逻辑向量？

#### 2.2 属性

对象可以有任何的属性。属性可以看做一个带有名字的列表，通过attr()和attributes()访问。


```r
y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")
```

```
## [1] "This is a vector"
```

```r
str(attributes(y))
```

```
## List of 1
##  $ my_attribute: chr "This is a vector"
```

structure()函数可以返回一个拥有新属性的对象，经常用在面向对象编程方面。


```r
structure(1:10, my_attribute = "This is a vector")
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
## attr(,"my_attribute")
## [1] "This is a vector"
```

默认情况下，当修改一个向量时它的大部分属性会随之消失，


```r
attributes(y[1])
```

```
## NULL
```

除了三个属性，

- 名字，name()
- 维度，dim()
- 类，class()

#### 2.2.0.1 名字

设置名字有三种方式，

- x <- c(a = 1, b = 2, c = 3).
- x <- 1:3; names(x) <- c("a", "b", "c")
- x <- setNames(1:3, c("a", "b", "c"))

名字不必唯一，但是取对象子集需要一个唯一的名字。

如果一个向量的元素有些没有名字，那么对于这些元素names()将返回空字符，注意不是NULL，如果所有元素都没有名字，那么names()将返回NULL，


```r
y <- c(a = 1, 2, 3)
names(y)
```

```
## [1] "a" ""  ""
```

```r
z <- c(1, 2, 3)
names(z)
```

```
## NULL
```

去掉一个向量的名字可以使用unname()或者names(x) <- NULL

#### 2.2.1 因子

因子只能取一些预定义好的值(levels)，因子内部存储的实际是整型值(integer)，因子有两个重要的属性，class和levels，


```r
x <- factor(c("a", "b", "b", "a"))
x
```

```
## [1] a b b a
## Levels: a b
```

```r
class(x)
```

```
## [1] "factor"
```

```r
typeof(x)
```

```
## [1] "integer"
```

```r
levels(x)
```

```
## [1] "a" "b"
```


```r
# "c"不属于levels
x[2] <- "c"
```

```
## Warning in `[<-.factor`(`*tmp*`, 2, value = "c"): invalid factor level, NA
## generated
```

```r
x
```

```
## [1] a    <NA> b    a   
## Levels: a b
```

```r
# 拼接factor没有意义
c(factor("a"), factor("b"))
```

```
## [1] 1 1
```

使用factor可以更直观的显示，


```r
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))
table(sex_char)
```

```
## sex_char
## m 
## 3
```

```r
table(sex_factor)
```

```
## sex_factor
## m f 
## 3 0
```

如果想以character的方式处理factor，最好通过as.character()显式的转换。

#### 2.2.2 作业

1.为什么comment属性没有打印出来，

```r
structure(1:5, comment = "my attribute")
```

```
## [1] 1 2 3 4 5
```

一些特殊的属性例如class、comment将会特殊对待，comment不会被print打印

2.当你修改一个因子的levels会怎么样？


```r
f1 <- factor(letters)
str(f1)
```

```
##  Factor w/ 26 levels "a","b","c","d",..: 1 2 3 4 5 6 7 8 9 10 ...
```

```r
table(f1)
```

```
## f1
## a b c d e f g h i j k l m n o p q r s t u v w x y z 
## 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```

```r
levels(f1) <- rev(levels(f1))
str(f1)
```

```
##  Factor w/ 26 levels "z","y","x","w",..: 1 2 3 4 5 6 7 8 9 10 ...
```

```r
table(f1)
```

```
## f1
## z y x w v u t s r q p o n m l k j i h g f e d c b a 
## 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```

显示顺序会变化，内部的映射关系会变化。

3.下面的代码和f1相同吗？


```r
f2 <- rev(factor(letters))
f3 <- factor(letters, levels = rev(letters))
```

f2与f1levels不同，f3与f1的值不同

#### 2.3 矩阵和数组(matrix, array)

数组其实是拥有dim属性的向量，而矩阵是数组的一种特殊形式：二维数组。

length()和names()在多维情况下有更具体的形式，

- length(),对于矩阵有nrow(),ncol()，且length=nrow*ncol，对于数组有dim()
- names(),对于矩阵有rownames()和colnames(),对于数组有dimnames()

注意一点，不是仅有vector是一维的，matrix和array也可以一维，但是它们的输出和处理是不同，这一点尤为注意。


```r
str(1:3) # 1d vector
```

```
##  int [1:3] 1 2 3
```

```r
#> int [1:3] 1 2 3
str(matrix(1:3, ncol = 1)) # column vector
```

```
##  int [1:3, 1] 1 2 3
```

```r
#> int [1:3, 1] 1 2 3
str(matrix(1:3, nrow = 1)) # row vector
```

```
##  int [1, 1:3] 1 2 3
```

```r
#> int [1, 1:3] 1 2 3
str(array(1:3, 3)) # "array" vector
```

```
##  int [1:3(1d)] 1 2 3
```

```r
#> int [1:3(1d)] 1 2 3
```

不只向量可以添加dim属性，列表也可以添加，然后构成列表矩阵或列表数组，


```r
l <- list(1:3, "a", TRUE, 1.0)
dim(l) <- c(2, 2)
l
```

```
##      [,1]      [,2]
## [1,] Integer,3 TRUE
## [2,] "a"       1
```

#### 2.3.1 作业

1.dim(向量)返回什么？

NULL

2.如果is.matrix(x)返回TRUE，is.array(x)返回什么？

返回TRUE，is.matrix只要dim属性的length为2就返回TRUE，is.array只要dim属性的length大于0就返回TRUE

3.下面的对象与1:5有什么区别？


```r
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))
```


1:5没有dim属性

#### 2.4 数据框(dataframe)

本质上一个数据框是一个列表，这些列表的元素是length相同的向量，所以它具有matrix和list的特点。对于数据框，

- 和矩阵一样，拥有names，rownames，colnames，并且names=colnames，但是对于矩阵names和colnames不同。
- 和列表一样，拥有length，nrow，ncol，且length=ncol，对于矩阵length=ncol*nrow。

#### 2.4.1 创建一个数据框


```r
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
str(df)
```

```
## 'data.frame':	3 obs. of  2 variables:
##  $ x: int  1 2 3
##  $ y: Factor w/ 3 levels "a","b","c": 1 2 3
```

默认情况下，data.frame将character转换为factor，使用stringAsFactors = FALSE参数来禁止这一点。

#### 2.4.2 检测类型和强制转换

数据框是一个S3对象，它本质上是一个list。


```r
typeof(df)
```

```
## [1] "list"
```

```r
#> [1] "list"
class(df)
```

```
## [1] "data.frame"
```

```r
#> [1] "data.frame"
is.data.frame(df)
```

```
## [1] TRUE
```

```r
#> [1] TRUE
```

可以使用as.data.frame()将向量、列表等转换为数据框，规则为

- 向量将会转为一个只有一列的数据框
- 列表的每一个元素将会转为一列，元素的length必须相同，不同时可以使用I()函数就行修正
- 矩阵将会转为一个相似的数据框


```r
# data.frame(x = 1:3, y = list(1:2, 1:3, 1:4))
dfl <- data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4)))
str(dfl)
```

```
## 'data.frame':	3 obs. of  2 variables:
##  $ x: int  1 2 3
##  $ y:List of 3
##   ..$ : int  1 2
##   ..$ : int  1 2 3
##   ..$ : int  1 2 3 4
##   ..- attr(*, "class")= chr "AsIs"
```


#### 2.4.3 拼接数据框

- cbind，当进行列拼接时，行数必须相同
- rbind，当进行行拼接时，列名和列数都必须相同

注意将向量进行cbind不会成为一个数据框而是一个矩阵，这种情况下直接使用data.frame()

#### 2.4.5 作业

1.一个数据框有哪些属性

names=colnames，row.names()，class

2.as.matrix()作用于一个列类型数据框将会如何？

强制转换，参考c()

3.一个数据框可以是0行吗，可以是0列吗？


```r
data.frame()
```

```
## data frame with 0 columns and 0 rows
```

### 3.Subsetting

#### 3.1.1 向量


```r
x <- c(2.1, 4.2, 3.3, 5.4)
```

对于一个向量有五种取子集的方法，

- 正整数


```r
x[c(3, 1)]
```

```
## [1] 3.3 2.1
```

```r
# 强制转换为整型
x[c(2.1, 2.9)]
```

```
## [1] 4.2 4.2
```

- 负整数

去除相应位置的值，这点和Python不同，但是正数和负数不能混合使用。


```r
x[-c(3, 1)]
```

```
## [1] 4.2 5.4
```

- 逻辑向量，取TRUE所在位置的值


```r
x[c(TRUE, TRUE, FALSE, FALSE)]
```

```
## [1] 2.1 4.2
```

```r
x[x > 3]
```

```
## [1] 4.2 3.3 5.4
```

逻辑向量长度小于被subsetting的向量的长度时，逻辑向量将会循环拓宽直到等于subsetting向量的长度，长度大于subsetting的向量的长度时，取值为NA


```r
x[c(TRUE, FALSE)]
```

```
## [1] 2.1 3.3
```

```r
# Equivalent to
x[c(TRUE, FALSE, TRUE, FALSE)]
```

```
## [1] 2.1 3.3
```

- 空将返回原来的向量，这在矩阵和数组中非常有用，空将会保留全部的元素


```r
x[]
```

```
## [1] 2.1 4.2 3.3 5.4
```

- 0返回一个length为0的vector


```r
x[0]
```

```
## numeric(0)
```

- 当向量有名字时，可以用字符向量来取子集


```r
(y <- setNames(x, letters[1:4]))
```

```
##   a   b   c   d 
## 2.1 4.2 3.3 5.4
```

```r
y[c("d", "c", "a")]
```

```
##   d   c   a 
## 5.4 3.3 2.1
```

#### 3.1.2 列表

[返回一个list，而[[和$返回元素的类型

#### 3.1.3 矩阵和数组

有三种取子集的方法，

- 多个向量，返回向量
- 单个向量，返回矩阵
- 一个矩阵(仅限integer类型)，每一行对应一个位置，所以用2列的矩阵取一个矩阵的子集，3列的矩阵取一个3d数组的子集，返回值为一个向量
- 当为逻辑矩阵时参考作业第三题


```r
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
vals[c(4, 15)]
```

```
## [1] "4,1" "5,3"
```

```r
select <- matrix(ncol = 2, byrow = TRUE, c(
    1, 1,
    3, 1,
    2, 4
))
vals[select]
```

```
## [1] "1,1" "3,1" "2,4"
```

```r
str(vals[select])
```

```
##  chr [1:3] "1,1" "3,1" "2,4"
```

#### 3.1.4 数据框

数据框同时具有列表和矩阵的特性，当用单个向量取子集时，类似列表，当用多个向量取子集时，类似矩阵。


```r
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
# Like a list:
df[c("x", "z")]
```

```
##   x z
## 1 1 a
## 2 2 b
## 3 3 c
```

```r
# Like a matrix
df[, c("x", "z")]
```

```
##   x z
## 1 1 a
## 2 2 b
## 3 3 c
```

```r
# 有一个特殊情况，当只取一列时，list方式返回一个dataframe，matrix方式返回一个vector
str(df["x"])
```

```
## 'data.frame':	3 obs. of  1 variable:
##  $ x: int  1 2 3
```

```r
str(df[, "x"])
```

```
##  int [1:3] 1 2 3
```

#### 3.1.5 S3类型

包括原始向量(atomic vector)，列表(list)，数组(array)，列表(list)，上面取子集的方法就是针对的S3类型

#### 3.1.6 S4类型

对于S4类型有两个特别的取子集操作符，@(相当于$)，slot()相当于[[。@比$更严谨些，当slot不存在时将返回一个错误。

#### 3.1.7 作业

2.为什么x<- 1:5，x[NA]返回5个缺失值？

因为NA是一个逻辑向量，当长度不及x的length时，将会自动扩展为5，然后返回5个缺失值

3.upper.tri()返回什么？用它来取子集有什么特殊的规则？


```r
x <- outer(1:5, 1:5, FUN = "*")
x[upper.tri(x)]
```

```
##  [1]  2  3  6  4  8 12  5 10 15 20
```

一个逻辑矩阵取子集将会取TRUE所在位置的值，并且是列优先，返回一个向量

4.mtcars[1:20]和mtcars[1:20, ]有什么区别？

前者取1到20列，后者取1到20行

6.df[is.na(df)] <- 0是什么意思？

将df中NA值替换为0

#### 3.2 subsetting操作符


```r
# If you do supply a vector it indexes recursively
b <- list(a = list(b = list(c = list(d = 1))))
b[[c("a", "b", "c", "d")]]
```

```
## [1] 1
```

```r
# Same as
b[["a"]][["b"]][["c"]][["d"]]
```

```
## [1] 1
```

[,[[,$,对于s3和s4表现不同，

> The key difference is usually how you select between simplifying or preserving behaviours, and what the default is.

#### 3.2.1 Simplifying vs. preserving subsetting

- Simplifying subsets returns the simplest possible data structure that can represent the output, and is useful interactively.
- Preserving subsetting keeps the structure of the output the same as the input, and is generally better for programming because the result will always be the same type.

simplify preserving

- vector和list:x[[1]],x[1]
- factor：x[1:4, drop=T],x[1:4]
- array:x[1, ]或x[, 1],x[1, drop=F]或x[, 1, drop=F]
- dataframe:x[, 1]或x[[1]], x[, 1, drop=F]或x[1]

#### 3.2.2 $

$是一个简化的操作符，可以部分匹配属性名，x$y相当于x[["y", exact= FALSE]]

#### 3.3 subsetting and assignment


```r
# Subsetting with nothing can be useful in conjunction with assignment
# return dataframe
mtcars[] <- lapply(mtcars, as.integer)
# return list
mtcars <- lapply(mtcars, as.integer)
```


```r
# 使用subseting+assignment+NULL来删除list的元素
x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x)
```

```
## List of 1
##  $ a: num 1
```

```r
# 添加NULL到list，使用list(NULL)
y <- list(a = 1)
y["b"] <- list(NULL)
str(y)
```

```
## List of 2
##  $ a: num 1
##  $ b: NULL
```

#### 3.4 应用

#### 3.4.1 character subsetting


```r
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
```

```
##        m        f        u        f        f        m        m 
##   "Male" "Female"       NA "Female" "Female"   "Male"   "Male"
```

#### 3.4.2 integer subsetting


```r
grades <- c(1, 2, 2, 3, 1)
info <- data.frame(
    grade = 3:1,
    desc = c("Excellent", "Good", "Poor"),
    fail = c(F, F, T)
)

# 第一种方法Using match
id <- match(grades, info$grade)
info[id, ]
```

```
##     grade      desc  fail
## 3       1      Poor  TRUE
## 2       2      Good FALSE
## 2.1     2      Good FALSE
## 1       3 Excellent FALSE
## 3.1     1      Poor  TRUE
```

```r
# 第二种方法Using rownames
rownames(info) <- info$grade
info[as.character(grades), ]
```

```
##     grade      desc  fail
## 1       1      Poor  TRUE
## 2       2      Good FALSE
## 2.1     2      Good FALSE
## 3       3 Excellent FALSE
## 1.1     1      Poor  TRUE
```

#### 3.4.7 logical subsetting

mtcars[mtcars$gear == 5, ]

#### 3.4.9 作业

1.如何随机排列一个数据框的列？

mtcars[, sample(ncol(mtcars))]

2.如何随机选择m行

mtcars[sample(nrows(mtcars), m), ]

3.如何将数据框的列按字母顺序排列？

mtcars[, order(colnames(mtcars))]

### 6.函数

#### 6.1 函数组成

有三部分组成，

- body()：函数体
- formals():参数
- environment():函数变量所在的位置


```r
f <- function(x) x^2
f
```

```
## function(x) x^2
```

```r
formals(f)
```

```
## $x
```

```r
body(f)
```

```
## x^2
```

```r
environment(f)
```

```
## <environment: R_GlobalEnv>
```

和R语言的其他对象一样，函数也可以拥有任意数量的attributes()

#### 6.1.1 原始函数(primitive function)

原始函数是一个例外，它没有上述三个组成部分，它通过.Primitive()直接调用c函数，它只存在base包中

#### 6.1.2 作业

1.如何检测一个对象是函数？原始函数呢？

is.function()
is.primitive()

2.下面的代码返回base包里的所有函数，


```r
objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.function, objs)
```

- 哪个函数参数最多？


```r
formals_length <- unlist(lapply(funs, function(x)length(formals(x))))
which.max(formals_length)
```

```
## scan 
##  932
```

- 有多少函数没有参数？这些函数有什么特点？


```r
sum(formals_length == 0)
```

```
## [1] 225
```

它们有的是原始函数，有的是无参数函数

- 怎样修改代码来查找所有的原始函数？


```r
objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.primitive, objs)
length(funs)
```

```
## [1] 183
```

3.函数的三个组成部分？

body,formals,environment

4.什么情况下不会打印函数的环境？

原始函数

#### 6.2 词法作用域(lexical scoping)

R语言有两种作用域，

> - lexical scoping, implemented automatically at the language level
> - dynamic scoping, used in select functions to save typing during interactive analysis

lexical scoping意思是去函数创建的地方去寻找它而不是调用它的地方，dynamic scoping意思是在函数调用的时候去寻找而不是创建的时候。

词法作用域实现有四个法则，

- 名称覆盖(name mask)
- 函数和变量(function vs variable)
- 从新开始(fresh start)
- 动态查找(dynamic lookup)

#### 6.2.1 名称覆盖


```r
x <- 2
g <- function() {
    y <- 1
    c(x, y)
}
g()
```

```
## [1] 2 1
```



```r
j <- function(x) {
    y <- 2
    function() {
        c(x, y)
    }
}
k <- j(1)
k()
```

```
## [1] 1 2
```

#### 6.2.2 函数和变量


```r
n <- function(x) x / 2
o <- function() {
    n <- 10
    n(n)
}
o()
```

```
## [1] 5
```

#### 6.2.3 从新开始


```r
j <- function() {
    if (!exists("a")) {
        a <- 1
    } else {
        a <- a + 1
    }
    print(a)
}
```

每次调用j都会创建一个新的环境，因此函数a永远为1

#### 6.2.4 动态查找

lexing scope决定去哪里寻找对象，dynamic scoping决定什么时候去寻找。这意味着函数的输出有可能因为自身环境外的变量不同而不同。


```r
f <- function() x
x <- 15
f()
```

```
## [1] 15
```

```r
x <- 20
f()
```

```
## [1] 20
```

这样的函数应该避免，因为它不是自包含的。

#### 6.2.5 作业

3.下面的函数会输出什么？


```r
f <- function(x) {
    f <- function(x) {
        f <- function(x) {
            x ^ 2
        }
        f(x) + 1
    }
    f(x) * 2
}
f(10)
```

```
## [1] 202
```

#### 6.3 每一个操作都是一个函数调用

- 万物皆为对象
- 万事皆为函数


```r
add <- function(x, y) x + y
sapply(1:10, add, 3)
```

```
##  [1]  4  5  6  7  8  9 10 11 12 13
```

```r
# 等同于
sapply(1:5, `+`, 3)  # 注意可以使用``引用保留的函数
```

```
## [1] 4 5 6 7 8
```

```r
sapply(1:5, "+", 3)  # 之所以可以起作用是因为sapply中使用了match.fun来查找函数
```

```
## [1] 4 5 6 7 8
```

#### 6.4 函数参数

#### 6.4.1 函数调用

调用函数时，参数可以进行位置匹配，名称完全或不完全匹配，顺序为完全匹配，不完全匹配，位置匹配。


```r
f <- function(abcdef, bcde1, bcde2) {
    list(a = abcdef, b1 = bcde1, b2 = bcde2)
}
str(f(1, 2, 3))
```

```
## List of 3
##  $ a : num 1
##  $ b1: num 2
##  $ b2: num 3
```

```r
str(f(2, 3, abcdef = 1))
```

```
## List of 3
##  $ a : num 1
##  $ b1: num 2
##  $ b2: num 3
```

```r
str(f(2, 3, a = 1))
```

```
## List of 3
##  $ a : num 1
##  $ b1: num 2
##  $ b2: num 3
```

```r
# But this doesn't work because abbreviation is ambiguous
# str(f(1, 3, b = 1))
#> Error: argument 3 matches multiple formal arguments
```

...之后的参数必须指定完整的名字。

#### 6.4.2 将参数放入列表进行调用


```r
args <- list(1:10, na.rm = TRUE)
do.call(mean, list(1:10, na.rm = TRUE))
```

```
## [1] 5.5
```

```r
# 等同于
mean(1:10, na.rm = TRUE)
```

```
## [1] 5.5
```

#### 6.4.3 默认和缺失参数


```r
# 默认值
f <- function(a = 1, b = 2) {
    c(a, b)
}
# 因为惰性求值，可以根据其他参数设置默认值
g <- function(a = 1, b = a * 2) {
    c(a, b)
}
g()
```

```
## [1] 1 2
```

```r
h <- function(a = 1, b = d) {
    d <- (a + 1) ^ 2
    c(a, b)
}
h()
```

```
## [1] 1 4
```


```r
# 使用missing()检测参数
i <- function(a, b) {
    c(missing(a), missing(b))
}
i()
```

```
## [1] TRUE TRUE
```

```r
i(a = 1)
```

```
## [1] FALSE  TRUE
```

```r
i(b = 2)
```

```
## [1]  TRUE FALSE
```

```r
i(1, 2)
```

```
## [1] FALSE FALSE
```

#### 6.4.4 惰性求值

惰性求值：只有在用到时才会进行计算


```r
f <- function(x) {
    10
}
f(stop("This is an error!"))
```

```
## [1] 10
```

```r
# 使用force()强制进行计算
f <- function(x) {
    force(x)
    10
}

# f(stop("This is an error!"))
# Error: This is an error!
# 使用lapply创建closure时特别有用
add <- function(x) {
    force(x)  # 去掉这句最后两句将会返回同样的值
    function(y) x + y
}
adders <- lapply(1:10, add)
adders[[1]](10)
```

```
## [1] 11
```

```r
adders[[10]](10)
```

```
## [1] 20
```

默认值只会在函数内部计算，这将导致下面的代码有所不同，


```r
f <- function(x = ls()) {
    a <- 1
    x
}
# 函数内部计算
f()
```

```
## [1] "a" "x"
```

```r
# 在全局环境计算
f(ls())
```

```
##  [1] "add"            "adders"         "args"           "b"             
##  [5] "df"             "dfl"            "f"              "f1"            
##  [9] "f2"             "f3"             "formals_length" "funs"          
## [13] "g"              "grades"         "h"              "i"             
## [17] "id"             "info"           "j"              "k"             
## [21] "l"              "lookup"         "mtcars"         "n"             
## [25] "o"              "objs"           "select"         "sex_char"      
## [29] "sex_factor"     "vals"           "x"              "x1"            
## [33] "x2"             "x3"             "y"              "z"
```

一个没有没有计算的参数称为一个诺言(promise)，它由两部分组成，

- 一个要进行计算的表达式(expression)
- 表达式创建和运行的环境(environment)

惰性求值在if中有很大的用处，


```r
# 如果不是惰性求值，x>0将会返回一个logical(0)，对于if这会出错
x <- NULL
if (!is.null(x) && x > 0) {
}
```

#### 6.4.5 ...


```r
# 使用list(...)来获得...的值
f <- function(...) {
    names(list(...))
}
f(a = 1, b = 2)
```

```
## [1] "a" "b"
```

#### 6.4.6 作业

2.函数将返回？为什么？有什么法则？


```r
f1 <- function(x = {y <- 1; 2}, y = 0) {
    x + y
}
f1()
```

```
## [1] 3
```

惰性求值，第一次计算发生在函数体x+y，此时x=2，y起先为0，在计算x的过程中y<-1，所以结果为3

3.函数将返回？为什么？有什么法则？


```r
f2 <- function(x = z) {
    z <- 100
    x
}
f2()
```

```
## [1] 100
```

#### 6.5 特殊调用(special call)

#### 6.5.1 infix functions

所有用户自己建立的infix函数名字必须以%为起止，


```r
# 创建infix函数时，必须以``将函数名包围起来，这只是R语言特殊的语法糖
`%+%` <- function(a, b) paste(a, b, sep = "")
"new" %+% " string"
```

```
## [1] "new string"
```

```r
# 等同于
`%+%`("new", " string")
```

```
## [1] "new string"
```

```r
# 当定义的函数名包含特殊字符时，在创建函数要进行转义，调用时不用
`% %` <- function(a, b) paste(a, b)
`%'%` <- function(a, b) paste(a, b)
`%/\\%` <- function(a, b) paste(a, b)
"a" % % "b"
```

```
## [1] "a b"
```

```r
"a" %'% "b"
```

```
## [1] "a b"
```

```r
"a" %/\% "b"
```

```
## [1] "a b"
```

#### 6.5.2 replace functions

replace function的名字也很特殊，形式为xxx<-，通常情况下有两个参数x和value，并且必须有value参数，x可以改名。


```r
`second<-` <- function(x, value) {
    x[2] <- value
    x
}
x <- 1:10
second(x) <- 5L
x
```

```
##  [1]  1  5  3  4  5  6  7  8  9 10
```

从表面上看函数修改了参数x，实际上修改的只是x的一份拷贝，而不是真正的x，这种策略将会对性能产生影响。原始函数可以直接修改参数本身，例如


```r
x <- 1:10
x[2] <- 7L
```

#### 6.5.3 作业

1.找出base包里的所有replace函数，它们哪些是原始函数？


```r
r_index <- grep("*<-$", names(funs))
names(funs)[r_index]
```

```
##  [1] "$<-"            "@<-"            "[[<-"           "[<-"           
##  [5] "<-"             "<<-"            "attr<-"         "attributes<-"  
##  [9] "class<-"        "dim<-"          "dimnames<-"     "environment<-" 
## [13] "length<-"       "levels<-"       "names<-"        "oldClass<-"    
## [17] "storage.mode<-"
```

```r
sapply(funs[r_index], is.primitive)
```

```
##            $<-            @<-           [[<-            [<-             <- 
##           TRUE           TRUE           TRUE           TRUE           TRUE 
##            <<-         attr<-   attributes<-        class<-          dim<- 
##           TRUE           TRUE           TRUE           TRUE           TRUE 
##     dimnames<-  environment<-       length<-       levels<-        names<- 
##           TRUE           TRUE           TRUE           TRUE           TRUE 
##     oldClass<- storage.mode<- 
##           TRUE           TRUE
```

3.创建一个xor的infix函数


```r
`%xor%` <- function(x, y) {
    xor(x, y)
}

T %xor% F
```

```
## [1] TRUE
```

5.创建一个replace函数随机修改向量的某个位置


```r
`rr<-` <- function(y, value) {
    y[sample(1:length(y), 1)] <- value
    y
}
x <- 1:10
rr(x) <- 5
x
```

```
##  [1]  1  2  3  4  5  6  7  8  5 10
```

#### 6.6 返回值

可以使用return返回，没有return默认将函数最后一句的值返回，提早返回时最好使用明确的return函数，可以使函数更清晰。


```r
f <- function(x, y) {
    if (!x) return(y)
    # complicated processing here
}
```

> 纯函数的概念\n
> 纯函数不会对工作空间产生影响，没有副作用，同样的输入产生同样的输出。


```r
f <- function(x) {
    x$a <- 2
    x
}
x <- list(a = 1)
f(x)
```

```
## $a
## [1] 2
```

```r
x
```

```
## $a
## [1] 1
```

这得益于copy-on-modify规则，但是environment和reference class已经修改了。

大部分的R函数都是纯函数，除了下面

- library()
- setwd(), Sys.setenv(), Sys.setlocale()
- plot()
- write(), write.csv(), saveRDS()
- options(), pars()
- S4
- 随机数发生器

可以使用invisible隐藏函数的返回值，使用()强制打印函数的返回值


```r
f1 <- function() 1
f2 <- function() invisible(1)
f1()
```

```
## [1] 1
```

```r
f2()
f1() == 1
```

```
## [1] TRUE
```

```r
f2() == 1
```

```
## [1] TRUE
```

```r
(f2())
```

```
## [1] 1
```

#### 6.6.1 on.exit

通常情况下，当你想在函数返回后做一些工作可以使用on.exit，比如对全局变量的恢复等。


```r
in_dir <- function(dir, code) {
    old <- setwd(dir)
    on.exit(setwd(old))
    force(code)
}
getwd()
```

```
## [1] "F:/notes/reading/Advanced R"
```

```r
in_dir("~", getwd())
```

```
## [1] "C:/Users/ASUS/Documents"
```

注意，如果想在同一个函数使用多个on.exit必须设置add=TRUE，否则下一个on.exit将会覆盖上一个。

#### 6.6.2 作业

2.library()没有做什么，怎样保存和恢复options和par？



```r
# op <- options(tag=value)
# some operations
# options(op)
# par和options类似
```

3.打开一个图形设备，运行一些代码，然后关闭它。


```r
devtest <- function(code) {
    dev.new()
    x <- 1
    on.exit(code)
    x
}
devtest(dev.off())
```

```
## [1] 1
```

### 7.面向对象编程

R语言有三种面向对象系统，

- S3，方法属于函数，有一个generic function，没有类的正式定义方法
- S4，与S3类似，但是有两点不同，S4有类的正式定义方法，可以有多个分发器(dispatch)
- RC，与前两者不同，方法属于类，另外RC没有采用R的copy-on-modify方法，而是直接修改原对象，这一点可以解决前两个无法解决的一些难题

#### 7.1 基本类型(base type)

基本类型不是一个真正的面向对象系统，因为只有R核心组才能创建新的类型，可以使用typeof()函数判断一个基本类型，


```r
# The type of a function is "closure"
f <- function() {}
typeof(f)
```

```
## [1] "closure"
```

```r
is.function(f)
```

```
## [1] TRUE
```

```r
# The type of a primitive function is "builtin"
typeof(sum)
```

```
## [1] "builtin"
```

```r
is.primitive(sum)
```

```
## [1] TRUE
```

还有一个mode()和storage.mode()函数最好不要使用，它们只是为了与S语言进行兼容而存在，实际上只是指向typeof函数的一个链接。

使用is.object(x)是否返回FALSE来测试一个对象是否是基本类型

#### 7.2 S3

base和stat包里唯一采用的面向对象系统，

没有直接的方法可以判断S3，最接近的一个方法是is.object(x) & !isS4(x)

在S3中方法属于函数，称为通用函数(generic function)，通用函数源代码通常为UseMethod(xxx)，一些S3对象没有使用UseMethod，比如[, sum(), 和 cbind()，原因是它们是由C代码实现的。

S3方法的形式为generic.class()，例如mean.Data()、print.factor()


```r
# 获得属于通用函数的所有方法
methods("mean")
```

```
## [1] mean.Date     mean.default  mean.difftime mean.POSIXct  mean.POSIXlt 
## see '?methods' for accessing help and source code
```

```r
# 获得所有包含某个class的所有通用函数
methods(class = "ts")
```

```
##  [1] [             [<-           aggregate     as.data.frame cbind        
##  [6] coerce        cycle         diff          diffinv       initialize   
## [11] kernapply     lines         Math          Math2         monthplot    
## [16] na.omit       Ops           plot          print         show         
## [21] slotsFromS3   t             time          window        window<-     
## see '?methods' for accessing help and source code
```

#### 7.2.2 定义类、创建对象

定义类有两种方法，一步就位或者分步执行，


```r
# Create and assign class in one step
foo <- structure(list(), class = "foo")
# Create, then set class
foo <- list()
class(foo) <- "foo"
```

通常情况下，S3类都是在list或者vector基础上建立的

通常情况下，S3的构造函数形式为，且构造函数的名字和class相同


```r
foo <- function(x) {
    if (!is.numeric(x)) stop("X must be numeric")
    structure(list(x), class = "foo")
}
```

S3不会检测对象类别的正确性，要注意不要把枪对着自己

#### 7.2.3 创建新的方法和通用函数


```r
# generic function f
f <- function(x) UseMethod("f")
# method
f.a <- function(x) "Class a"

a <- structure(list(), class = "a")
class(a)
```

```
## [1] "a"
```

```r
f(a)
```

```
## [1] "Class a"
```

```r
# 还可以为现有的generic function添加方法
mean.a <- function(x) "a"
mean(a)
```

```
## [1] "a"
```

```r
# default class类似于if中的else子句
f.default <- function(x) "Unknown class"
```

#### 7.2.5 作业

1.阅读t()和t.test()的源码确认它们是generic function，如果你创建一个test的类，用t调用它会怎么样？


```r
tt <- structure(list(1,2,3), class = "test")
t.test <- function(x, y) "test"
t(tt)
```

```
## [1] "test"
```

2.base包中哪些类拥有属于Math通用函数的方法？How do the methods work？


```r
# 不太确定对不对
methods("Math")
```

```
## [1] Math,nonStructure-method Math,structure-method   
## [3] Math.data.frame          Math.Date               
## [5] Math.difftime            Math.factor             
## [7] Math.POSIXt             
## see '?methods' for accessing help and source code
```

3.R中有两个日期类，POSIXct和POSIXlt, 都是继承自POSIXt，对于这两个日期类，哪些通用函数表现不同，哪些函数相同？

4.哪个base generic拥有最多的方法？

5.预测下面代码的输出


```r
y <- 1
g <- function(x) {
    y <- 2
    UseMethod("g")
}
g.numeric <- function(x) y
g(10)
```

```
## [1] 2
```

```r
h <- function(x) {
    x <- 10
    UseMethod("h")
}
h.character <- function(x) paste("char", x)
h.numeric <- function(x) paste("num", x)
h("a")
```

```
## [1] "char a"
```

执行顺序为，generic function然后是具体的methods

6.Internal generics don’t dispatch on the implicit class of base types.仔细阅读?"internal generic"解释为什么f和g的length不同。What function helps distinguish between the behaviour of f and g?


```r
f <- function() 1
g <- function() 2
class(g) <- "function"
class(f)
```

```
## [1] "function"
```

```r
class(g)
```

```
## [1] "function"
```

```r
length.function <- function(x) "function"
length(f)
```

```
## [1] 1
```

```r
length(g)
```

```
## [1] "function"
```

is.object()

#### 7.3 S4

S4和S3类似，方法仍然属于函数，但是有以下几点不同，

- 类有正式的定义方法
- 通用函数可以根据多个参数分配方法，而不仅仅一个
- @操作符

- isS4()来判断一个对象是否是s4
- is()，一个参数列出所有继承的类，两个参数类似inherit()
- getGenerics()获得所有的s4通用函数，getClasses()获得所有的s4类，showMethods()列出所有的s4方法

#### 7.3.2 定义类、创建对象

s4有三个重要的属性，

- name，根据惯例，s4的类使用驼峰命名法
- field(slots)
- contains,一个字符串表示的类名


```r
# 比s3要严格和正式，s4定义必须要使用setClass方法，创建对象使用new
setClass("Person",
         slots = list(name = "character", age = "numeric"))
setClass("Employee",
         slots = list(boss = "Person"),
         contains = "Person")
alice <- new("Person", name = "Alice", age = 40)
john <- new("Employee", name = "John", age = 20, boss = alice)
# 访问s4的属性使用@或slot()
alice@age
```

```
## [1] 40
```

```r
slot(john, "boss")
```

```
## An object of class "Person"
## Slot "name":
## [1] "Alice"
## 
## Slot "age":
## [1] 40
```

```r
john@boss
```

```
## An object of class "Person"
## Slot "name":
## [1] "Alice"
## 
## Slot "age":
## [1] 40
```

@相当于$，slot()相当于[[

#### 7.3 创建generic和methods


```r
# setGeneric()创建一个新的generic或者将已经存在的函数转换为generic
setGeneric("union")
```

```
## [1] "union"
```

```r
# setMethods()用来创建方法
setMethod("union",
          c(x = "data.frame", y = "data.frame"),
function(x, y) {
    unique(rbind(x, y))
}
)
```

```
## [1] "union"
```

```r
# 如果你重新创建了一个generic，需要调用standardGeneric()，与s3的UseMethod()类似
setGeneric("myGeneric", function(x) {
    standardGeneric("myGeneric")
})
```

```
## [1] "myGeneric"
```

#### 7.3.5 作业

1.哪个S4 generic function拥有最多的方法？哪个S4类拥有最多的方法？

2.如果你创建了一个S4的类没有包含(contain)一个已存在的类会发生什么？

3.将一个S4传给一个S3或者反之，将会出现什么情况？

#### 7.4 RC

RC和前面两个系统有两点重要不同，

- 方法属于对象，不属于函数
- RC对象是易变的，不适用copy-on-modify原则

> Reference classes are implemented using R code: they are a special S4 class
that wraps around an environment.

RC是特殊的S4类

#### 7.4.1 创建对象

RC最适合有状态的对象，比如银行账户，


```r
Account <- setRefClass("Account")
Account$new()
```

```
## Reference class object of class "Account"
```

```r
Account <- setRefClass("Account",
                       fields = list(balance = "numeric"))
a <- Account$new(balance = 100)
# 使用$设置获取变量的值
a$balance
```

```
## [1] 100
```

```r
a$balance <- 200
a$balance
```

```
## [1] 200
```

```r
# RC没有使用copy-on-modify
b <- a
b$balance
```

```
## [1] 200
```

```r
a$balance <- 0
b$balance
```

```
## [1] 0
```

```r
# 正是这个原因，才有一个copy()函数
c <- a$copy()
c$balance
```

```
## [1] 0
```

```r
a$balance <- 100
c$balance
```

```
## [1] 0
```

```r
# 注意<<-
Account <- setRefClass("Account",
                       fields = list(balance = "numeric"),
                       methods = list(
                           withdraw = function(x) {
                               balance <<- balance - x
                           },
                           deposit = function(x) {
                               balance <<- balance + x
                           }
                       )
)

a <- Account$new(balance = 100)
a$deposit(100)
a$balance
```

```
## [1] 200
```

```r
# 继承
NoOverdraft <- setRefClass("NoOverdraft",
                           contains = "Account",
                           methods = list(
                               withdraw = function(x) {
                                   if (balance < x) stop("Not enough money")
                                   balance <<- balance - x
                               }
                           )
)
# accountJohn <- NoOverdraft$new(balance = 100)
# accountJohn$deposit(50)
# accountJohn$balance
# accountJohn$withdraw(200)
```

RC类的一些函数，

- copy()
- callSuper()，调用父类
- field()获得属性值
- export()类似as()
- show()

详细参考setRefClass()函数

使用is(x, "refClass")判断一个对象是否RC

#### 7.4.3 方法分配

与前两个面向对象系统不同，RC方法分配和主流语言类似，调用形式为x$f，R会在x类中寻找f方法，如果没有找到则会在x的父类中寻找，如果找不到则会在父类的父类中寻找……

#### 7.4.4 作业

1.

2.我说过base包里没有RC类，那是一个简化。使用getClasses()看看哪个类别继承了envRefClass，这些类是干嘛的？


```r
cls <- getClasses(where = parent.env(environment()), inherits = T)
ref <- Filter(function(x) extends(x, "envRefClass"), cls)
ref
```

```
## [1] "envRefClass"      "localRefClass"    "refGeneratorSlot"
```

#### 7.5该使用哪个类？

- 大部分情况下，S3足够了，而且能用最少的代码实现相应功能
- 对于一些复杂的系统，典型的如Matrix包，S4是一个不错的选择
- RC尽量不用，它会修改原来的对象，这会产生副作用，除非你真想先这样做


