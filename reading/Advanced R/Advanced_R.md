# Advanced R课后作业

### 2.数据结构

#### 2.1 向量(vector)

R语言中的数据类型大致可以分为，

- 一维：向量(vector)，列表(list)
- 二维：矩阵(matrix)，数据框(dataframe)
- n维：数组(array)


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



