# Swift 学习笔记<一> -- Basic Operators

运算符是一个特殊的符号或短语,你可以用来检查,修改或结合values.

swift 支持大部分 standard C 的运算符,并在原有的基础上做出了一些改善,以减少一些在代码中出现的错误.

例如,`=`运算符没有返回值,在你意图使用`==`运算符时,不小心使用了`=`运算符.

算数运算符(+,-,*,%等)会检查value溢出,避免在运行时出现可不预测的错误.你也可以选择使用[Swift’s overflow operators](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID37)

Swift还提供了在C中没有的range operators, eg: `a..<b` 和 `a...b`.

在这里只讨论普通的运算符,

