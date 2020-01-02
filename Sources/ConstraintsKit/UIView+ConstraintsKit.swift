//
//  UIView+ConstraintsKit.swift
//  extensions-kit
//
//  Created by Astemir Eleev on 15/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: Methods
  
    // MARK: - Constraining
    
    /// Constrains `self` using the specified `Attribute` to the specified `Attribute` with respect to the related `UIView`. You may set `Relation` (which is by default `.equal`), `offset` (default is `0.0`) and `multiplier` (default is `1.0`)
    @discardableResult public func constrain(using attribute: Attribute, to viewAttribute: Attribute, of relatedView: UIView, relatedBy relation: Relation = .equal, offset: CGFloat = 0, multiplier: CGFloat = 1) -> UIView {
        enableAutoLayout()
        
        if let superview = self.superview {
            let constraint = NSLayoutConstraint(item: self,
                                                attribute: attribute.convert(),
                                                relatedBy: relation.convert(),
                                                toItem: relatedView,
                                                attribute: viewAttribute.convert(),
                                                multiplier: multiplier,
                                                constant: offset)
            superview.addConstraint(constraint)
        }
        return self
    }
    
    /// Places `self` inside the specified `UIView` with an optional `offset` (default is `0.0`)
    public func fit(inside view: UIView = SuperviewObject(), offset: CGFloat = 0) throws {
        let constrainView = try resolveSuperviewObject(for: view)
        
        constrain(using: .top, to: .top, of: constrainView, offset: offset, multiplier: 1)
            .constrain(using: .bottom, to: .bottom, of: constrainView, offset: -offset, multiplier: 1)
            .constrain(using: .left, to: .left, of: constrainView, offset: offset, multiplier: 1)
            .constrain(using: .right, to: .right, of: constrainView, offset: -offset, multiplier: 1)
    }
    
    /// Centers `self` inside the specified `UIView`
    @discardableResult public func center(in view: UIView = SuperviewObject()) throws -> UIView {
        let constrainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()

        centerXAnchor.constraint(equalTo: constrainView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: constrainView.centerYAnchor).isActive = true

        return self
    }
    
    /// Centers `self` inside the specified `UIView` using a concrete `Axis` case, with an optional `multiplier` (default is `1.0`)
    @discardableResult public func center(in view: UIView = SuperviewObject(), axis: Axis,  multiplier: CGFloat = 1.0) throws -> UIView {
        let constrainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        let anchor = axis.convert()
        constrain(using: anchor, to: anchor, of: constrainView, offset: 0, multiplier: multiplier)
        return self
    }
    
    /// Applies width equalization between `self` and the specified `UIView`. You may change the `Relation` (default is `equal`), `UILayoutPriority` (default is `required`), `multiplier` (default is `1.0`) and `constant` (default is `0.0`)
    @discardableResult public func width(to view: UIView = SuperviewObject(),
                                         relatedBy relatioin: Relation = .equal,
                                         priority: UILayoutPriority = .required,
                                         multiplier: CGFloat = 1.0,
                                         constant: CGFloat = 0.0) throws -> UIView {
        let constrainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        let constraint: NSLayoutConstraint
        
        switch relatioin {
        case .equal:
            constraint = self.widthAnchor.constraint(equalTo: constrainView.widthAnchor, multiplier: multiplier, constant: constant)
        case .lessThanOrEqual:
            constraint = self.widthAnchor.constraint(lessThanOrEqualTo: constrainView.widthAnchor, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqual:
            constraint = self.widthAnchor.constraint(greaterThanOrEqualTo: constrainView.widthAnchor, multiplier: multiplier, constant: constant)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Applies height equalization between `self` and the specified `UIView`. You may change the `Relation` (default is `equal`), `UILayoutPriority` (default is `required`), `multiplier` (default is `1.0`) and `constant` (default is `0.0`)
    @discardableResult public func height(to view: UIView = SuperviewObject(),
                                          relatedBy relatioin: Relation = .equal,
                                          priority: UILayoutPriority = .required,
                                          multiplier: CGFloat = 1.0,
                                          constant: CGFloat = 0.0) throws -> UIView {
        let constrainView = try resolveSuperviewObject(for: view)
        
        enableAutoLayout()
        let constraint: NSLayoutConstraint

        switch relatioin {
        case .equal:
            constraint = self.heightAnchor.constraint(equalTo: constrainView.heightAnchor, multiplier: multiplier, constant: constant)
        case .lessThanOrEqual:
            constraint = self.widthAnchor.constraint(lessThanOrEqualTo: constrainView.heightAnchor, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqual:
            constraint = self.widthAnchor.constraint(greaterThanOrEqualTo: constrainView.heightAnchor, multiplier: multiplier, constant: constant)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    // MARK: - Setting
    
    /// Sets a new `CGSize` for `self` by applying layout constaints for `width` & `height` anchors
    @discardableResult public func set(size: CGSize) -> UIView {
        set(width: size.width)
        set(height: size.height)
        return self
    }
    
    /// Sets a new `width` by applying layout constaint for `width` anchor
    @discardableResult public func set(width value: CGFloat) -> UIView {
        set(value: value, to: .width)
        return self
    }
    
    /// Sets a new `height` by applying layout constraint for `height` anchor
    @discardableResult public func set(height value: CGFloat) -> UIView {
        set(value: value, to: .height)
        return self
    }
    
    /// Sets a new `aspect ratio` by applying layout constaint for `aspect` anchor
    @discardableResult public func set(aspect value: CGFloat) -> UIView {
        set(value: value, to: .aspect)
        return self
    }
    
    /// Sets a new `aspect ratio` by duplicating `aspect` of the specified `UIView`
    @discardableResult public func set(aspectOf view: UIView) -> UIView {
        set(aspect: view.aspect)
        return self
    }
    
    /// Sets a new offset `value` for the `Attribute`
    @discardableResult public func set(value: CGFloat, to attribute: Attribute) -> UIView {
        guard let superview = self.superview else { return self }
        enableAutoLayout()
        
        let constraint = attribute != .aspect ?
            NSLayoutConstraint(item: self, attribute: attribute.convert() , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value) :
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: value, constant: 0)
        superview.addConstraint(constraint)
        
        return self
    }
}

private extension UIView {

    private func enableAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func anchored(to view: UIView, using anchor: AxisY) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        guard #available(iOS 11.0, *) else {
            return (anchor == .bottom) ? view.layoutMarginsGuide.bottomAnchor : view.layoutMarginsGuide.topAnchor
        }
        return (anchor == .bottom) ? view.safeAreaLayoutGuide.bottomAnchor : view.safeAreaLayoutGuide.topAnchor
    }
    
    private func anchored(to view: UIView, using anchor: AxisX, useEdge edge: Bool = false) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        guard #available(iOS 11.0, *) else {
            if edge {
                return (anchor == .left) ? view.layoutMarginsGuide.leadingAnchor : view.layoutMarginsGuide.trailingAnchor
            } else {
                return (anchor == .left) ? view.layoutMarginsGuide.leftAnchor : view.layoutMarginsGuide.rightAnchor
            }
        }
        
        if edge {
            return (anchor == .left) ? view.safeAreaLayoutGuide.leadingAnchor : view.safeAreaLayoutGuide.trailingAnchor
        } else {
            return (anchor == .left) ? view.safeAreaLayoutGuide.leftAnchor : view.safeAreaLayoutGuide.rightAnchor
        }
    }
    
    private func resolveSuperviewObject(for view: UIView) throws -> UIView {
        var constrainView = view
        
        switch view  {
        case is SuperviewObject:
            guard let superview = self.superview else { throw ConstraintsKitError.missingSuperview }
            constrainView = superview
        default: ()
        }
        return constrainView
    }
}

extension UIView {
    
    public var width: CGFloat {
        return bounds.width
    }
    
    public var height: CGFloat {
        return bounds.height
    }
    
    public var size: CGSize {
        return CGSize(width: width, height: height)
    }
    
    public var aspect: CGFloat {
        return bounds.width / bounds.height
    }
}

// MARK: - Anchoring
extension UIView {
    
    /// Anchors top anchor to the specified `UIView` using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func top(with view: UIView = SuperviewObject(),
                                       anchor: AxisY,
                                       relatedBy relation: Relation = .equal,
                                       priority: UILayoutPriority = .required,
                                       offset: CGFloat = 0) throws -> UIView {
        let constaintView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        let computedAnchor = anchored(to: constaintView, using: anchor)
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = topAnchor.constraint(equalTo: computedAnchor, constant: offset)
        case .greaterThanOrEqual:
            constraint = topAnchor.constraint(greaterThanOrEqualTo: computedAnchor, constant: offset)
        case .lessThanOrEqual:
            constraint = topAnchor.constraint(lessThanOrEqualTo: computedAnchor, constant: offset)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Anchors botom anchor to the specified `UIView` using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func bottom(with view: UIView = SuperviewObject(),
                                          anchor: AxisY,
                                          relatedBy relation: Relation = .equal,
                                          priority: UILayoutPriority = .required,
                                          offset: CGFloat = 0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        let computedAnchor = anchored(to: constainView, using: anchor)
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = bottomAnchor.constraint(equalTo: computedAnchor, constant: offset)
        case .lessThanOrEqual:
            constraint = bottomAnchor.constraint(lessThanOrEqualTo: computedAnchor, constant: offset)
        case .greaterThanOrEqual:
            constraint = bottomAnchor.constraint(greaterThanOrEqualTo: computedAnchor, constant: offset)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Anchors left anchor to the specified `UIView` using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func left(with view: UIView = SuperviewObject(),
                                        anchor: AxisX,
                                        relatedBy realtion: Relation = .equal,
                                        priority: UILayoutPriority = .required,
                                        offset: CGFloat = 0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        let computedAnchor = anchored(to: constainView, using: anchor)
        let constraint: NSLayoutConstraint
        
        switch realtion {
        case .equal:
            constraint = leftAnchor.constraint(equalTo: computedAnchor, constant: offset)
        case .greaterThanOrEqual:
            constraint = leftAnchor.constraint(greaterThanOrEqualTo: computedAnchor, constant: offset)
        case .lessThanOrEqual:
            constraint = leftAnchor.constraint(lessThanOrEqualTo: computedAnchor, constant: offset)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Anchors right anchor to the specified `UIView` using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func right(with view: UIView = SuperviewObject(),
                                         anchor: AxisX,
                                         relatedBy relation: Relation = .equal,
                                         priority: UILayoutPriority = .required,
                                         offset: CGFloat = 0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        let computedAnchor = anchored(to: constainView, using: anchor)
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = rightAnchor.constraint(equalTo: computedAnchor, constant: offset)
        case .greaterThanOrEqual:
            constraint = rightAnchor.constraint(greaterThanOrEqualTo: computedAnchor, constant: offset)
        case .lessThanOrEqual:
            constraint = rightAnchor.constraint(lessThanOrEqualTo: computedAnchor, constant: offset)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
}

// MARK: - Anchoring to System Spacing
extension UIView {
    
    /// Anchors left anchor to the specified `UIView` with respect to System Spacing using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func leftToSystemSpacing(with view: UIView = SuperviewObject(),
                                                       anchor: AxisX,
                                                       relatedBy relation: Relation = .equal,
                                                       priority: UILayoutPriority = .required,
                                                       multiplier: CGFloat = 1.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        // We can be sure that this force-casting will succed sunce NSLayoutYAxisAnchor is a subclass of NSLayoutAnchor class
        let computedAnchor = anchored(to: constainView, using: anchor) as! NSLayoutXAxisAnchor
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = leftAnchor.constraint(equalToSystemSpacingAfter: computedAnchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = leftAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: computedAnchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = leftAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: computedAnchor, multiplier: multiplier)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Anchors bottom anchor to the specified `UIView` with respect to System Spacing using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func bottomToSystemSpacing(with view: UIView = SuperviewObject(),
                                                         anchor: AxisY,
                                                         relatedBy relation: Relation = .equal,
                                                         priority: UILayoutPriority = .required,
                                                         multiplier: CGFloat = 1.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        // We can be sure that this force-casting will succed sunce NSLayoutYAxisAnchor is a subclass of NSLayoutAnchor class
        let computedAnchor = anchored(to: constainView, using: anchor) as! NSLayoutYAxisAnchor
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = bottomAnchor.constraint(equalToSystemSpacingBelow: computedAnchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: computedAnchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: computedAnchor, multiplier: multiplier)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Anchors top anchor to the specified `UIView` with respect to System Spacing using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func topToSystemSpacing(with view: UIView = SuperviewObject(),
                                                      anchor: AxisY,
                                                      relatedBy relation: Relation = .equal,
                                                      priority: UILayoutPriority = .required,
                                                      multiplier: CGFloat = 1.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        // We can be sure that this force-casting will succed sunce NSLayoutYAxisAnchor is a subclass of NSLayoutAnchor class
        let computedAnchor = anchored(to: constainView, using: anchor) as! NSLayoutYAxisAnchor
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = topAnchor.constraint(equalToSystemSpacingBelow: computedAnchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: computedAnchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: computedAnchor, multiplier: multiplier)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
    /// Anchors right anchor to the specified `UIView` with respect to System Spacing using `AxisY` anchor, `Relation` (defatul is `.equal`), NSLayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func rightToSystemSpacing(with view: UIView = SuperviewObject(),
                                                        anchor: AxisX,
                                                        relatedBy relation: Relation = .equal,
                                                        priority: UILayoutPriority = .required,
                                                        multiplier: CGFloat = 1.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        enableAutoLayout()
        
        // We can be sure that this force-casting will succed sunce NSLayoutYAxisAnchor is a subclass of NSLayoutAnchor class
        let computedAnchor = anchored(to: constainView, using: anchor) as! NSLayoutXAxisAnchor
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .equal:
            constraint = rightAnchor.constraint(equalToSystemSpacingAfter: computedAnchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = rightAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: computedAnchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = rightAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: computedAnchor, multiplier: multiplier)
        }
        constraint.set(priority: priority, isActive: true)
        
        return self
    }
    
}

// MARK: - Pin extension
extension UIView {
    
    /// Pins Top Left anchor to the Top Left corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinTopLeftToTopLeftCorner(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try top(with: constainView, anchor: .top, offset: offset)
        try left(with: constainView, anchor: .left, offset: offset)
        
        return self
    }
    
    /// Pins Top Right anchor to the Top Right corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinTopRightToTopRightCorner(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try top(with: constainView, anchor: .top, offset: offset)
        try right(with: constainView, anchor: .right, offset: offset)
        
        return self
    }
    
    /// Pins Bottom Right anchor to the Bottom Right corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinBottomRightToBottomRight(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try bottom(with: constainView, anchor: .bottom, offset: offset)
        try right(with: constainView, anchor: .right, offset: offset)
        
        return self
    }
    
    /// Pins Bottom Left anchor to the Bottom Left corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinBottomLeftToBottomLeft(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try bottom(with: constainView, anchor: .bottom, offset: offset)
        try left(with: constainView, anchor: .left, offset: offset)
        
        return self
    }
    
    /// Pins Bottom Right anchor to the Top Left corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinBottomRightToTopLeft(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try bottom(with: constainView, anchor: .top, offset: offset)
        try right(with: constainView, anchor: .left, offset: offset)
        
        return self
    }
    
    /// Pins Bottom Left anchor to the Top Right corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinBottomLeftToTopRight(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try bottom(with: constainView, anchor: .top, offset: offset)
        try left(with: constainView, anchor: .right, offset: offset)
        
        return self
    }
    
    /// Pins Top Left anchor to the Bottom Right corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinTopLeftToBottomRight(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try top(with: constainView, anchor: .bottom, offset: offset)
        try left(with: constainView, anchor: .right, offset: offset)
        
        return self
    }
    
    /// Pins Bottom Right anchor to the Top Left corner of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinBottomRightToTopLeft(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try top(with: constainView, anchor: .bottom, offset: offset)
        try right(with: constainView, anchor: .left, offset: offset)
        
        return self
    }
    
    /// Pins Top anchor to the Top Center anchor of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinTopToTopCenter(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try top(with: constainView, anchor: .top, offset: offset)
        try center(in: constainView, axis: .horizontal)
        
        return self
    }
    
    /// Pins Bottom anchor to the Bottom Center anchor of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinBottomToBottomCenter(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try bottom(with: constainView, anchor: .bottom, offset: -offset)
        try center(in: constainView, axis: .horizontal)
        
        return self
    }
    
    /// Pins Left anchor to the Left Center anchor of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinLeftToLeftCenter(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try left(with: constainView, anchor: .left, offset: offset)
        try center(in: constainView, axis: .vertical)
        
        return self
    }
    
    /// Pins Right anchor to the Right Center anchor of the specified `UIView` with a given `offset` (default is `0.0`)
    @discardableResult public func pinRightToRightCenter(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        try right(with: constainView, anchor: .right, offset: -offset)
        try center(in: constainView, axis: .vertical)
        
        return self
    }
    
    /// Pins `self` inside the specified `UIView` with `Relation` (default is `.equal`), UILayoutPriority (default is `.required`) and `offset` (default is `0.0`)
    @discardableResult public func pinInside(view: UIView = SuperviewObject(), relatedBy relation: Relation = .equal, priority: UILayoutPriority = .required, offset: CGFloat = 0.0 ) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        
        try left(   with: constainView,     anchor: .left,      relatedBy: relation,    priority: priority,     offset: offset)
        try top(    with: constainView,     anchor: .top,       relatedBy: relation,    priority: priority,     offset: offset)
        try right(  with: constainView,     anchor: .right,     relatedBy: relation,    priority: priority,     offset: -offset)
        try bottom( with: constainView,     anchor: .bottom,    relatedBy: relation,    priority: priority,     offset: -offset)
        
        return self
    }
    
    /// Pins `self` to the specified `UIView` by using `Anchor` (which is an `OptionSet`)
    @discardableResult public func pinTo(view: UIView = SuperviewObject(), using anchor: Anchor) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        let constraints = anchor.convert()
        
        for constraint in constraints {
            switch constraint {
            case .left:
                try left(with: constainView, anchor: .left)
            case .right:
                try right(with: constainView, anchor: .right)
            case .bottom:
                try bottom(with: constainView, anchor: .bottom)
            case .top:
                try top(with: constainView, anchor: .top)
            case .centerY:
                try center(in: constainView, axis: .vertical)
            case .centerX:
                try center(in: constainView, axis: .horizontal)
            case .firstBaseline:
                constrain(using: .firstBaseline, to: .firstBaseline, of: constainView)
            case .lastBaseline:
                constrain(using: .lastBaseline, to: .lastBaseline, of: constainView)
            case .trailing:
                constrain(using: .trailing, to: .trailing, of: constainView)
            case .leading:
                constrain(using: .leading, to: .leading, of: constainView)
            case .width:
                try width(to: constainView)
            case .height:
                try height(to: constainView)
            default:
                continue
            }
        }
        return self
    }
    
    /// Pins the specified `Anchors` of `self` to the `UIView` by using the related `Anchors`
    @discardableResult public func pin(anchors: Anchor, toTargetView view: UIView = SuperviewObject(), using viewAnchors: Anchor) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        let constraints = anchors.convert()
        let targetConstraints = viewAnchors.convert()
        
        for (index, constraint) in constraints.enumerated() where index < targetConstraints.count {
            let targetConstraint = targetConstraints[index].convert()
            
            switch constraint {
            case .left:
                try left(with: constainView, anchor: targetConstraint.toAxisX() ?? .left)
            case .right:
                try right(with: constainView, anchor: targetConstraint.toAxisX() ?? .right)
            case .bottom:
                try bottom(with: constainView, anchor: targetConstraint.toAxisY() ?? .bottom)
            case .top:
                try top(with: constainView, anchor: targetConstraint.toAxisY() ?? .top)
            case .centerY:
                try center(in: constainView, axis: targetConstraint.toAxis() ?? .vertical)
            case .centerX:
                try center(in: constainView, axis: targetConstraint.toAxis() ?? .horizontal)
            case .firstBaseline:
                constrain(using: .firstBaseline, to: targetConstraint, of: constainView)
            case .lastBaseline:
                constrain(using: .lastBaseline, to: targetConstraint, of: constainView)
            case .trailing:
                constrain(using: .trailing, to: targetConstraint, of: constainView)
            case .leading:
                constrain(using: .leading, to: targetConstraint, of: constainView)
            case .width:
                try width(to: constainView)
            case .height:
                try height(to: constainView)
            default:
                continue
            }
        }
        return self
    }
    
}


// MARK: - Fill extension
extension UIView {
    
    
    /// Fills the bottom half of the specified view by `self` with the given `offset` (default is `0.0`)
    @discardableResult public func fillBottomHalf(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        
        try left(   with: constainView,     anchor: .left,      offset: offset)
        try right(  with: constainView,     anchor: .right,     offset: -offset)
        try bottom( with: constainView,     anchor: .bottom,    offset: -offset)
        
        constrain(using: .top, to: .centerY, of: view, offset: offset)
        
        return self
    }
    /// Fills the top half of the specified view by `self` with the given `offset` (default is `0.0`)
    @discardableResult public func fillTopHalf(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        
        try left(   with: constainView,     anchor: .left,      offset: offset)
        try right(  with: constainView,     anchor: .right,     offset: -offset)
        try top(    with: constainView,     anchor: .top,       offset: offset)
        
        constrain(using: .bottom, to: .centerY, of: view, offset: -offset)
        
        return self
    }
    
    /// Fills the left half of the specified view by `self` with the given `offset` (default is `0.0`)
    @discardableResult public func fillLeftHalf(of view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        
        try left(   with: constainView,     anchor: .left,      offset: offset)
        try bottom( with: constainView,     anchor: .bottom,    offset: -offset)
        try top(    with: constainView,     anchor: .top,   offset: offset)
        
        constrain(using: .right, to: .centerX, of: view, offset: -offset)
        
        return self
    }
    
    /// Fills the right half of the specified view by `self` with the given `offset` (default is `0.0`)
    @discardableResult public func fillRightHalf(cornerOf view: UIView = SuperviewObject(), offset: CGFloat = 0.0) throws -> UIView {
        let constainView = try resolveSuperviewObject(for: view)
        
        try right(  with: constainView,     anchor: .right,     offset: -offset)
        try bottom( with: constainView,     anchor: .bottom,    offset: -offset)
        try top(    with: constainView,     anchor: .top,   offset: offset)
        
        constrain(using: .left, to: .centerX, of: view, offset: offset)
        
        return self
    }
    
}
