//
//  NSLayoutConstraint+Utils.swift
//  ConstraintsKit
//
//  Created by Astemir Eleev on 06/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    @discardableResult public func set(priority: UILayoutPriority, isActive: Bool) -> Self {
        self.priority = priority
        self.isActive = isActive
        return self
    }
    
    @discardableResult public func set(priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
    
    @discardableResult public func activate() -> Self {
        isActive = true
        return self
    }
    
    @discardableResult public func deactivate() -> Self {
        isActive = false
        return self
    }
    
}

extension NSLayoutConstraint.Attribute {
    func convert() -> Attribute {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .centerX:
            return .centerX
        case .centerY:
            return .centerY
        case .firstBaseline:
            return .firstBaseline
        case .lastBaseline:
            return .lastBaseline
        case .height:
            return .height
        case .width:
            return .width
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .notAnAttribute
        }
    }
}
