# Swift standard library - Math

## 目录

* [Integers](#Integters@)
	* [`protocol Numeric`](#Numeric@)
	* [`protocol SignedNumeric`](#SignedNumeric@)
	* [`protocol BinaryInteger`](#BinaryInteger@)

## Note

### <a name='Integters@'></a>Integters

#### <a name='Numeric@'></a>protocol Numeric

Conforming: `public protocol Numeric : Equatable, ExpressibleByIntegerLiteral`

Method:

	public init?<T>(exactly source: T) where T : BinaryInteger
	
	associatedtype Magnitude : Comparable, ExpressibleByIntegerLiteral
	// 作用同`abs(_:)` 建议使用`abs(_:)`
	// 取绝对值
	public var magnitude: Self.Magnitude { get }
	
	public static func +(lhs: Self, rhs: Self) -> Self
	
	public static func +=(lhs: inout Self, rhs: Self)
	
	public static func -(lhs: Self, rhs: Self) -> Self
	
	public static func -=(lhs: inout Self, rhs: Self)
	
	public static func *(lhs: Self, rhs: Self) -> Self
	
	public static func *=(lhs: inout Self, rhs: Self)

	prefix public static func +(x: Self) -> Self

#### <a name='SignedNumeric@'></a>protocol SignedNumeric

代表有符号的values

Conform `Protocol Numeric `  `public protocol SignedNumeric : Numeric`

Method: 
	
	prefix public static func -(operand: Self) -> Self
	///     var x = 21
    ///     x.negate()
    ///     // x == -21
    ///     var y = -21
    ///     y.negate()
    ///     // y == 21
	public mutating func negate()

所有的方法都有默认实现.

#### <a name = 'BinaryInteger@'></a>protocol BinaryInteger

支持整形二进制表现形式

	/// Creates an integer from the given floating-point value, rounding toward  zero.
	///     let x = Int(21.5)
    ///     // x == 21
    ///     let y = Int(-21.5)
    ///     // y == -21
    /// 
	public init<T>(_ source: T) where T : BinaryFloatingPoint
	///     let x = Int(exactly: 21.0)
    ///     // x == Optional(21)
    ///     let y = Int(exactly: 21.5)
    ///     // y == nil
	public init?<T>(exactly source: T) where T : BinaryFloatingPoint
	
	/// Creates a new instance from the bit pattern of the given instance by
    /// sign-extending or truncating to fit this type.
    ///
    /// When the bit width of `T` (the type of `source`) is equal to or greater
    /// than this type's bit width, the result is the truncated
    /// least-significant bits of `source`. For example, when converting a
    /// 16-bit value to an 8-bit type, only the lower 8 bits of `source` are
    /// used.
    ///
    ///     let p: Int16 = -500
    ///     // 'p' has a binary representation of 11111110_00001100
    ///     let q = Int8(truncatingIfNeeded: p)
    ///     // q == 12
    ///     // 'q' has a binary representation of 00001100
    ///
    /// When the bit width of `T` is less than this type's bit width, the result
    /// is *sign-extended* to fill the remaining bits. That is, if `source` is
    /// negative, the result is padded with ones; otherwise, the result is
    /// padded with zeros.
    ///
    ///     let u: Int8 = 21
    ///     // 'u' has a binary representation of 00010101
    ///     let v = Int16(truncatingIfNeeded: u)
    ///     // v == 21
    ///     // 'v' has a binary representation of 00000000_00010101
    ///
    ///     let w: Int8 = -21
    ///     // 'w' has a binary representation of 11101011
    ///     let x = Int16(truncatingIfNeeded: w)
    ///     // x == -21
    ///     // 'x' has a binary representation of 11111111_11101011
    ///     let y = UInt16(truncatingIfNeeded: w)
    ///     // y == 65515
    ///     // 'y' has a binary representation of 11111111_11101011
    ///
    /// - Parameter source: An integer to convert to this type.
    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger
    
    /// Creates a new instance with the representable value that's closest to the
    /// given integer.
    ///
    /// If the value passed as `source` is greater than the maximum representable
    /// value in this type, the result is the type's `max` value. If `source` is
    /// less than the smallest representable value in this type, the result is
    /// the type's `min` value.
    ///
    /// In this example, `x` is initialized as an `Int8` instance by clamping
    /// `500` to the range `-128...127`, and `y` is initialized as a `UInt`
    /// instance by clamping `-500` to the range `0...UInt.max`.
    ///
    ///     let x = Int8(clamping: 500)
    ///     // x == 127
    ///     // x == Int8.max
    ///
    ///     let y = UInt(clamping: -500)
    ///     // y == 0
    ///
    /// - Parameter source: An integer to convert to this type.
    public init<T>(clamping source: T) where T : BinaryInteger

