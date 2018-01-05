# Swift standard library - Math

## 目录

* [Integers](#Integters@)
	* [`protocol Numeric`](#Numeric@)
	* [`protocol SignedNumeric`](#SignedNumeric@)

## Note

### <a name='Integters@'></a>Integters

#### <a name='Numeric@'></a>protocol Numeric

Conforming: `public protocol Numeric : Equatable, ExpressibleByIntegerLiteral`

Method:

	public init?<T>(exactly source: T) where T : BinaryInteger
	
	associatedtype Magnitude : Comparable, ExpressibleByIntegerLiteral
	
	public var magnitude: Self.Magnitude { get }
	
	public static func +(lhs: Self, rhs: Self) -> Self
	
	public static func +=(lhs: inout Self, rhs: Self)
	
	public static func -(lhs: Self, rhs: Self) -> Self
	
	public static func -=(lhs: inout Self, rhs: Self)
	
	public static func *(lhs: Self, rhs: Self) -> Self
	
	public static func *=(lhs: inout Self, rhs: Self)

	prefix public static func +(x: Self) -> Self

#### <a name='SignedNumeric@'></a>protocol SignedNumeric
