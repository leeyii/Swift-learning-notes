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