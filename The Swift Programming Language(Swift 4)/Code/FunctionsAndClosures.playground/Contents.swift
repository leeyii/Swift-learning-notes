//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


/****functions*****/


func greet( person: String, day: String) -> String {
    
     return "Hello \(person), today is \(day)."
}


greet(person: "lee", day: "sunday")



/*******tuple 元组*******/

func calculateStatistics(scores: [Int]) -> (max: Int, min: Int, sum: Int) {
    var max = scores[0]
    var min = scores[0]
    var sum = 0
    
    for score in scores {
        
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        
        sum += score
    }
    
    return (max, min, sum)
}

let statisitcs = calculateStatistics(scores: [5, 3, 100, 3, 9])

print(statisitcs.max)
print(statisitcs.2)

// 方法作为返回值

func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return number + 1
    }
    return addOne
}

let increment = makeIncrementer()

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

// 闭包

var numbers:[Int] = [0, 1, 2, 3, 4, 5]

numbers = numbers.map({ (number)  in
    number + 2
})

print(numbers)

numbers = numbers.sorted(by: {
    $0 > $1
})

print(numbers)

