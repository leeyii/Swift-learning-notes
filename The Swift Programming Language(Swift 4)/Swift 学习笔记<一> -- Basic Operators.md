# Swift 学习笔记<一> -- Basic Operators

运算符是一个特殊的符号或短语,你可以用来检查,修改或结合values.

swift 支持大部分 standard C 的运算符,并在原有的基础上做出了一些改善,以减少一些在代码中出现的错误.

例如,`=`运算符没有返回值,在你意图使用`==`运算符时,不小心使用了`=`运算符.

算数运算符(+,-,*,%等)会检查value溢出,避免在运行时出现可不预测的错误.你也可以选择使用[Swift’s overflow operators](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID37)

Swift还提供了在C中没有的range operators, eg: `a..<b` 和 `a...b`.

在这里只讨论普通的运算符,swift还支持高级运算符,你可以自己定义运算符并给你自己创建的类型实现运算.详细内容可以看[Advanced Operators](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID28)

## 术语

运算符可以是单目运算,双目运算和三木运算:

* 单目运算操作一个对象(如:`-a`).单目运算符紧跟在运算对象的前面或者后面
* 双目运算操作两个对象(如:`2 + 3`).并且在两个对象的中间
* 三目运算操作三个对象.在swift只支持一种三目运算(a ? b : c)

## 赋值运算

这里在swift没有什么特殊的地方,不细说.

## 算数运算符

swift支持 String 链接


	"hello, " + "world"  // equals "hello, world"

## 取余运算 

没啥特殊的

## 比较运算符

`==` `!=` `>` `<` `>=` `<=` 这些没什么特别的

`===`和`!==` 用来比较两个实例对象是否相等

`==` 还可以用来比较字符串 

	let name = "world"
	if name == "world" {
	    print("hello, world")
	} else {
	    print("I'm sorry \(name), but I don't recognize you")
	}


元组也可以使用`< >` 运算符,前期是两个元组类型相同,并且元组中每一个元素都可以使用操作符.


## 三目条件运算

和oc一样没啥说的

## Nil-Coalescing Operator

`a ?? b` a为可选类型,如果a有值,则对a解包,否则给a一个默认的值b

	let defaultColorName = "red"
	var userDefinedColorName: String?   // defaults to nil
	 
	var colorNameToUse = userDefinedColorName ?? defaultColorName

