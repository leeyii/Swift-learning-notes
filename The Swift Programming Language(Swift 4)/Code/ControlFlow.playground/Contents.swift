//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let individualScores = [75, 43, 103, 87, 12]
var teamSorce = 0
for sorce in individualScores {
    if sorce > 50 {
        teamSorce += 3
    } else {
        teamSorce += 1
    }
}

// 可选类型

var optionString : String? = "hello"
print(optionString == nil)


var nameOption : String? = "james"
var greeting = "hello!"
if let name = nameOption {
    greeting = "Hello, \(name)"
}

// 另一种可选类型处理方式

//let nickName : String? = "allen"
let nickName : String? = nil
let fullName = "John Apple"
let infoGreeting = "Hi, \(nickName ?? fullName)"


/***********Switch************/

let value1 = "red apple"

switch value1 {
case "a":
    print(str)
case "b":
    print(str)
case let x where x.hasSuffix("apple") :
    print(x)
default:
    print(str)
}

/***********for-in************/

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


/***********while************/

var n = 2

while n < 5 {
    n += 1
}

repeat {
    n += 1
} while n < 2


// ..<

for i in 0..<4 {
    print(i)
}


