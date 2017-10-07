//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class Shape {
    var numberOfSide = 0
    var name: String
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "A shape has \(numberOfSide) side"
    }
}

var shape = Shape(name: "Shape")
shape.numberOfSide = 4
shape.simpleDescription()

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






