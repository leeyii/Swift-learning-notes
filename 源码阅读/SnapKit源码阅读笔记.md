# SnapKit 源码阅读笔记

## Basic Information

* Name:SnapKit
* Site:[https://github.com/SnapKit/SnapKit](https://github.com/SnapKit/SnapKit)
* Version:4.0.0
* Introduce: [https://github.com/SnapKit/SnapKit/blob/develop/README.md](https://github.com/SnapKit/SnapKit/blob/develop/README.md)

## Note

#### Constraint.swift

`class Constraint` 

- **Property**
	- internal let sourceLocation: (String, UInt) 
	- internal let label: String?
	- private let from: ConstraintItem
	- private let to: ConstraintItem
	- private let relation: ConstraintRelation
	- private let multiplier: ConstraintMultiplierTarget
	- private var constant: ConstraintConstantTarget
	- private var priority: ConstraintPriorityTarget
	- public var layoutConstraints: [LayoutConstraint]
	- public var isActive: Bool {get}

一个实例对象由一个`maker`语句生成.

  
        view1.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

生成一个Constraint对象,但是`layoutConstraints`有4个约束.

        view1.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.right.equalToSuperview()
        }

生成4个Constraint对象,每个对象中分别有一个约束.所有两种写法是相同的.
但是第一种写法共用一个`multiplier`,`constant`,`priority`.如果这三个值不相同的话就需要使用第二种写法了.

	let layoutFromAttributes = self.from.attributes.layoutAttributes
	for layoutFromAttribute in layoutFromAttributes {
			// ... 省略部分代码
			// create layout constraint
            let layoutConstraint = LayoutConstraint(
                item: layoutFrom,
                attribute: layoutFromAttribute,
                relatedBy: layoutRelation,
                toItem: layoutTo,
                attribute: layoutToAttribute,
                multiplier: self.multiplier.constraintMultiplierTargetValue,
                constant: layoutConstant
            )

            // append
            self.layoutConstraints.append(layoutConstraint)
        }

每个Constraint对象layoutConstraints的个数由`form.attributes.layoutAttributes`的数量决定.

这里的`LayoutConstraint`是`NSLayoutConstraint`的子类.

* Line: 259- 274
* Description: 约束更新
* Note:
		
        guard let item = self.from.layoutConstraintItem else {
            print("WARNING: SnapKit failed to get from item from constraint. Activate will be a no-op.")
            return
        }
        if updatingExisting {
            var existingLayoutConstraints: [LayoutConstraint] = []
            for constraint in item.constraints {
                existingLayoutConstraints += constraint.layoutConstraints
            }

            for layoutConstraint in layoutConstraints {
                let existingLayoutConstraint = existingLayoutConstraints.first { $0 == layoutConstraint }
                guard let updateLayoutConstraint = existingLayoutConstraint else {
                    fatalError("Updated constraint could not find existing matching constraint to update: \(layoutConstraint)")
                }

                let updateLayoutAttribute = (updateLayoutConstraint.secondAttribute == .notAnAttribute) ? updateLayoutConstraint.firstAttribute : updateLayoutConstraint.secondAttribute
                updateLayoutConstraint.constant = self.constant.constraintConstantTargetValueFor(layoutAttribute: updateLayoutAttribute)
            }
        }

从约束添加的view上找到所有的约束,一一比较attribute是否相同,如果没有相同的抛出异常.

#### ConstraintPriority.swift 

* Path:/SnapKit/Source/ConstraintPriority.swift
* Lint:30 - 77
* Note:

		public struct ConstraintPriority : ExpressibleByFloatLiteral, Equatable, Strideable {
		    public typealias FloatLiteralType = Float
		    
		    public let value: Float
		    
		    public init(floatLiteral value: Float) {
		        self.value = value
		    }
		    
		    public init(_ value: Float) {
		        self.value = value
		    }
		    
		    public static var required: ConstraintPriority {
		        return 1000.0
		    }
		    
		    public static var high: ConstraintPriority {
		        return 750.0
		    }
		    
		    public static var medium: ConstraintPriority {
		        #if os(OSX)
		            return 501.0
		        #else
		            return 500.0
		        #endif
		        
		    }
		    
		    public static var low: ConstraintPriority {
		        return 250.0
		    }
		    
		    public static func ==(lhs: ConstraintPriority, rhs: ConstraintPriority) -> Bool {
		        return lhs.value == rhs.value
		    }
		
		    // MARK: Strideable
		
		    public func advanced(by n: FloatLiteralType) -> ConstraintPriority {
		        return ConstraintPriority(floatLiteral: value + n)
		    }
		
		    public func distance(to other: ConstraintPriority) -> FloatLiteralType {
		        return other.value - value
		    }
		}

* Description:ExpressibleByFloatLiteral协议和Strideable协议的使用 MARK

#### ConstraintInsets.swift

* Path: /SnapKit/Source/ConstraintInsets.swift
* Line: 31 - 35
* Note:

		#if os(iOS) || os(tvOS)
		    public typealias ConstraintInsets = UIEdgeInsets
		#else
		    public typealias ConstraintInsets = NSEdgeInsets
		#endif

* Description: typealias的一种使用场景,其他地方还有很多同样的试用场景就不一一列举了.

#### ConstraintAttributes.swift

* Path: /SnapKit/Source/ConstraintAttribu	tes.swift
	* Line: 31 - 190
			* Note: 
			
			internal struct ConstraintAttributes : OptionSet {
			    
			    internal init(rawValue: UInt) {
			        self.rawValue = rawValue
			    }
			    internal init(_ rawValue: UInt) {
			        self.init(rawValue: rawValue)
			    }
			    internal init(nilLiteral: ()) {
			        self.rawValue = 0
			    }
			    
			    internal private(set) var rawValue: UInt
			    internal static var allZeros: ConstraintAttributes { return self.init(0) }
			    internal static func convertFromNilLiteral() -> ConstraintAttributes { return self.init(0) }
			    internal var boolValue: Bool { return self.rawValue != 0 }
			    
			    internal func toRaw() -> UInt { return self.rawValue }
			    internal static func fromRaw(_ raw: UInt) -> ConstraintAttributes? { return self.init(raw) }
			    internal static func fromMask(_ raw: UInt) -> ConstraintAttributes { return self.init(raw) }
			    
			    // normal
			    
			    internal static var none: ConstraintAttributes { return self.init(0) }
			    internal static var left: ConstraintAttributes { return self.init(1) }
			    internal static var top: ConstraintAttributes {  return self.init(2) }
			    internal static var right: ConstraintAttributes { return self.init(4) }
			    internal static var bottom: ConstraintAttributes { return self.init(8) }
			    internal static var leading: ConstraintAttributes { return self.init(16) }
			    internal static var trailing: ConstraintAttributes { return self.init(32) }
			    internal static var width: ConstraintAttributes { return self.init(64) }
			    internal static var height: ConstraintAttributes { return self.init(128) }
			    internal static var centerX: ConstraintAttributes { return self.init(256) }
			    internal static var centerY: ConstraintAttributes { return self.init(512) }
			    internal static var lastBaseline: ConstraintAttributes { return self.init(1024) }
			    
			    @available(iOS 8.0, OSX 10.11, *)
			    internal static var firstBaseline: ConstraintAttributes { return self.init(2048) }
			    
			    @available(iOS 8.0, *)
			    internal static var leftMargin: ConstraintAttributes { return self.init(4096) }
			    
			    @available(iOS 8.0, *)
			    internal static var rightMargin: ConstraintAttributes { return self.init(8192) }
			    
			    @available(iOS 8.0, *)
			    internal static var topMargin: ConstraintAttributes { return self.init(16384) }
			    
			    @available(iOS 8.0, *)
			    internal static var bottomMargin: ConstraintAttributes { return self.init(32768) }
			    
			    @available(iOS 8.0, *)
			    internal static var leadingMargin: ConstraintAttributes { return self.init(65536) }
			    
			    @available(iOS 8.0, *)
			    internal static var trailingMargin: ConstraintAttributes { return self.init(131072) }
			    
			    @available(iOS 8.0, *)
			    internal static var centerXWithinMargins: ConstraintAttributes { return self.init(262144) }
			    
			    @available(iOS 8.0, *)
			    internal static var centerYWithinMargins: ConstraintAttributes { return self.init(524288) }
			    
			    // aggregates
			    
			    internal static var edges: ConstraintAttributes { return self.init(15) }
			    internal static var size: ConstraintAttributes { return self.init(192) }
			    internal static var center: ConstraintAttributes { return self.init(768) }
			    
			    @available(iOS 8.0, *)
			    internal static var margins: ConstraintAttributes { return self.init(61440) }
			    
			    @available(iOS 8.0, *)
			    internal static var centerWithinMargins: ConstraintAttributes { return self.init(786432) }
			    
			    internal var layoutAttributes:[LayoutAttribute] {
			        var attrs = [LayoutAttribute]()
			        if (self.contains(ConstraintAttributes.left)) {
			            attrs.append(.left)
			        }
			        if (self.contains(ConstraintAttributes.top)) {
			            attrs.append(.top)
			        }
			        if (self.contains(ConstraintAttributes.right)) {
			            attrs.append(.right)
			        }
			        if (self.contains(ConstraintAttributes.bottom)) {
			            attrs.append(.bottom)
			        }
			        if (self.contains(ConstraintAttributes.leading)) {
			            attrs.append(.leading)
			        }
			        if (self.contains(ConstraintAttributes.trailing)) {
			            attrs.append(.trailing)
			        }
			        if (self.contains(ConstraintAttributes.width)) {
			            attrs.append(.width)
			        }
			        if (self.contains(ConstraintAttributes.height)) {
			            attrs.append(.height)
			        }
			        if (self.contains(ConstraintAttributes.centerX)) {
			            attrs.append(.centerX)
			        }
			        if (self.contains(ConstraintAttributes.centerY)) {
			            attrs.append(.centerY)
			        }
			        if (self.contains(ConstraintAttributes.lastBaseline)) {
			            attrs.append(.lastBaseline)
			        }
			        
			        #if os(iOS) || os(tvOS)
			            if (self.contains(ConstraintAttributes.firstBaseline)) {
			                attrs.append(.firstBaseline)
			            }
			            if (self.contains(ConstraintAttributes.leftMargin)) {
			                attrs.append(.leftMargin)
			            }
			            if (self.contains(ConstraintAttributes.rightMargin)) {
			                attrs.append(.rightMargin)
			            }
			            if (self.contains(ConstraintAttributes.topMargin)) {
			                attrs.append(.topMargin)
			            }
			            if (self.contains(ConstraintAttributes.bottomMargin)) {
			                attrs.append(.bottomMargin)
			            }
			            if (self.contains(ConstraintAttributes.leadingMargin)) {
			                attrs.append(.leadingMargin)
			            }
			            if (self.contains(ConstraintAttributes.trailingMargin)) {
			                attrs.append(.trailingMargin)
			            }
			            if (self.contains(ConstraintAttributes.centerXWithinMargins)) {
			                attrs.append(.centerXWithinMargins)
			            }
			            if (self.contains(ConstraintAttributes.centerYWithinMargins)) {
			                attrs.append(.centerYWithinMargins)
			            }
			        #endif
			        
			        return attrs
			    }
			}
			
			internal func + (left: ConstraintAttributes, right: ConstraintAttributes) -> ConstraintAttributes {
			    return left.union(right)
			}
			
			internal func +=(left: inout ConstraintAttributes, right: ConstraintAttributes) {
			    left.formUnion(right)
			}
			
			internal func -=(left: inout ConstraintAttributes, right: ConstraintAttributes) {
			    left.subtract(right)
			}
			
			internal func ==(left: ConstraintAttributes, right: ConstraintAttributes) -> Bool {
			    return left.rawValue == right.rawValue
			}

* Description: OptionSet用法 mark
