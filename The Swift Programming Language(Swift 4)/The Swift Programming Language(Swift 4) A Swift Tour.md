##1.Simple Values


* 使用`let`声明常量, `var`声明变量.
* 在编译阶段不必指明常量类型,但是不行给常量赋值.
* 声明一个变量/常量可以不指定类型,如果没有指定类型则必须赋值,编译器会自动推测出变量/常量的类型
* values永远不会"悄悄"的转换为另一种类型,如果想要将一个值转换为另一种类型必须显式的转换.


##Control Flow 

条件使用 if 和 switch , 循环使用 for-in, while 和 repeat-while 

条件语句使用()包围是可选的,但是body必须用大括号包围.

	let individualScores = [75, 43, 103, 87, 12]
	var teamSorce = 0
	for sorce in individualScores {
	    if sorce > 50 {
	        teamSorce += 3
	    } else {
	        teamSorce += 1
	    }
	}

在if的判断条件中必须是一个Boolean表达式,这就意味着不能使用`if score { ... }` 这样的表达式.

你可以一起使用if和let表示values可能遗失.这种类型一般是可选类型.

####可选类型:
不是包含一个value就是包含nil,如果为nil表示这个value遗失了. 在声明变量时,如果在变量类型后面添加?表示这个值是可选类型.

var optionString : String? = "hello"
print(optionString == nil)


	var nameOption : String? = "james"
	var greeting = "hello!"
	if let name = nameOption {
	    greeting = "Hello, \(name)"
	}

如果optional value 为 nil , if判断条件为false,此段代码将会被跳过.如果optional value的值不为nil,可选类型将会被解包,并赋值给let常量,并在代码块中使用此常量.

另一种处理可选类型的方式是使用`??`运算符, 如果可选类型为nil的话,就使用`??`操作符后面的替代

	let nickName : String? = nil
	let fullName = "John Apple"
	let infoGreeting = "Hi, \(nickName ?? fullName)"

####Switch
Switches 支持多种类型对比操作,不仅仅局限和integers作对比

	let vegetable = "red pepper"
	switch vegetable {
	case "celery":
	    print("Add some raisins and make ants on a log.")
	case "cucumber", "watercress":
	    print("That would make a good tea sandwich.")
	case let x where x.hasSuffix("pepper"):
	    print("Is it a spicy \(x)?")
	default:
	    print("Everything tastes good in soup.")
	}

Notice: 判断条件中可以使用let语句,声明一个常量接收vegetable, 同时可以使用x做判断,如果x满足判断条件,使用x接收.

在switch的条件语句中不需要break跳出,因为switch执行完想匹配的情况就会自动跳出,不会执行next case.

####for-in

使用for-in遍历字典中的键值对

	var interestiongNumbers = ["Prime": [2, 3, 5, 7, 11, 13],
	                           "Fibonacci": [1, 1, 2, 3, 5, 8],
	                           "Square": [1, 4, 9, 16, 25],];
	
	var largest = 0
	
	for (key, numbers) in interestiongNumbers {
	    for number in numbers {
	        if number > largest {
	            largest = number;
	        }
	    }
	}
	
	print(largest)

####while

使用while去循环一段代码知道条件不成立,判断条件可以在开始位置,也可以在结束位置(保证循环执行至少1次).

	var n = 2
	while n < 100 {
	    n *= 2
	}
	print(n)
	 
	var m = 2
	repeat {
	    m *= 2
	} while m < 100
	print(m)

####..<


	var total = 0
	for i in 0..<4 {
	    total += i
	}
	print(total)

`..<`不包含右边界,`...`包含右边界.

##Functions and Closures

使用`func`去声明一个function. 调用一个方法通过他的方法名和括号内的参数

使用`->`分开参数和返回值.

func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")

默认的,方法使用:前面的一部分作为参数名.但是可以自己定义内部参数名和外部参数名.:之前可以有两部分使用空格隔开,前面是外部参数,后面是内部参数.如果想省略使用`_`代替.

	func greet(_ person: String, on day: String) -> String {
	    return "Hello \(person), today is \(day)."
	}
	greet("John", on: "Wednesday")

####Tuple

元组(Tuple): 使用元组保存不同类型的值.元组中的元素可以同时通过key和index取到.

例如:方法返回多个值.

	func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
	    var min = scores[0]
	    var max = scores[0]
	    var sum = 0
	    
	    for score in scores {
	        if score > max {
	            max = score
	        } else if score < min {
	            min = score
	        }
	        sum += score
	    }
	    
	    return (min, max, sum)
	}
	let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
	print(statistics.sum)
	print(statistics.2)

---

方法可以被嵌套在别的方法内,嵌套的方法可以访问外部方法声明的变量

	func returnFifteen() -> Int {
	    var y = 10
	    func add() {
	        y += 5
	    }
	    add()
	    return y
	}
	returnFifteen()

方法是一等类型,可以作为其他方法的返回值或参数.


	// 方法作为返回值 sec
	func makeIncrementer() -> ((Int) -> Int) {
	    func addOne(number: Int) -> Int {
	        return 1 + number
	    }
	    return addOne
	}
	var increment = makeIncrementer()
	increment(7)

	// 方法作为参数
	func hasAnyMatchse(list: [Int], condition: (Int) -> Bool) -> Bool {
	    for item in list {
	        if condition(item) {
	            return true
	        }
	    }
	    return false
	}
	
	func lessThanTen(_ number: Int) -> Bool {
	    return number > 10
	}
	
	hasAnyMatchse(list: [10,20,30,5,6], condition: lessThanTen)

方法实际上就是一个特殊的闭包:代码块可以在指定的时间被调用.闭包代码可以访问闭包所处上下文的变量和方法.

你可以实现一个没有名字的闭包,闭包使用大括号包裹这,使用`in`分开方法体与参数返回值.

	numbers.map({ (number: Int) -> Int in
	    let result = 3 * number
	    return result
	})

你可以更简洁的创建一个闭包.如果闭包的类型已知(代理回调),或者返回值类型已知,可以省略类型. 如果只有一个语句,可以省略return.

	var numbers:[Int] = [0, 1, 2, 3, 4, 5]
	
	numbers = numbers.map({ (number)  in
	    number + 2
	})
	
	print(numbers)

你也可以使用`$`+数字的方式代替参数名字,这种方式在非常短的闭包中及其有效.

闭包作为方法的最后一个参数可以直接跟在`()`之后.闭包作为方法的唯一参数可以省略`()`.

let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)

##Objects and classes

使用`class`关键+类名创建类.在类中声明属性的写法和声明变量或常量相同.

	class Shape {
	    var numberOfSide = 0
	    
	    func simpleDescription() -> String {
	        return "A shape has \(numberOfSide) side"
	    }
	}

使用`类名()`创建一个实例对象,使用点语法访问属性或方法.

	var shape = Shape()
	shape.numberOfSide = 4
	shape.simpleDescription()

注意:在方法中如果有和属性相同的名字的变量,使用`self`区分他们(如果相同参数或局部变量会覆盖属性).在初始化器中所有的属性都应该有初始值,声明属性时赋值或者在初始化器中赋值都行.

		init(name: String) {
	        self.name = name
	    }

使用`deinit`创建一个析构器,如果需要执行一些清理操作在对象销毁时调用.类似OC中的dealloc函数.

使用 `class 子类名 : 父类名`创建一个子类.没有规定每一个类必须有一个父类,所以如果没有必要你可以不继承父类.

子类重写父类的方法实现使用`override`标记. 如果出现意外情况,重写一个方法忘记添加`override`编译器会检查出错误.

	class Square : Shape {
	    var sideLength : Double
	    
	    init(sideLength: Double, name: String) {
	        self.sideLength = sideLength
	        super.init(name: name)
	        numberOfSide = 4
	    }
	    
	    func area () -> Double {
	        return sideLength * Double(numberOfSide)
	    }
	    
	    override func simpleDescription() -> String {
	        return "A square with sides of length \(sideLength)."
	    }
	}
	
	
	let square = Square(sideLength: 3.4, name: "Square")
	print(square.area())
	square.simpleDescription()

每一个属性都可由setter和getter方法.

	class EquilateralTriangle : Shape {
	    var sideLength: Double
	    init(sideLength: Double, name: String) {
	        self.sideLength = sideLength
	        super.init(name: name)
	        numberOfSide = 3
	    }
	    
	    var perimeter: Double {
	        get {
	            return sideLength * 3.0
	        }
	        set {
	            sideLength = newValue / 3.0
	        }
	    }
	    
	    override func simpleDescription() -> String {
	        return "An equilateral triangle with sides of length \(sideLength)."
	    }
	}
	
	var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
	print(triangle.perimeter)
	triangle.perimeter = 9.9
	print(triangle.sideLength)
