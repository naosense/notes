# Advanced R课后作业

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
```

如果想以character的方式处理factor，最好显式的转换。

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












