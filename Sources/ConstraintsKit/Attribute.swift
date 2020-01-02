//
//  Attribute.swift
//  ConstraintsKit
//
//  Created by Astemir Eleev on 06/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

public enum Attribute {
    case top, bottom, left, right, aspect, width, height, centerX, centerY, lastBaseline, firstBaseline, leading, trailing, notAnAttribute
}

extension Attribute {
    
    func convert() -> NSLayoutConstraint.Attribute {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .left:
            return .leading
        case .right:
            return .trailing
        case .width:
            return .width
        case .height:
            return .height
        case .centerX:
            return .centerX
        case .centerY:
            return .centerY
        case .lastBaseline:
            return .lastBaseline
        case .firstBaseline:
            return .firstBaseline
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .notAnAttribute
        }
    }
    
    func toAxisX() -> AxisX? {
        switch self {
        case .left:
            return AxisX.left
        case .right:
            return AxisX.right
        default:
            return nil
        }
    }
    
    func toAxisY() -> AxisY? {
        switch self {
        case .top:
            return AxisY.top
        case .bottom:
            return AxisY.bottom
        default:
            return nil
        }
    }
    
    func toAxis() -> Axis? {
        switch self {
        case .centerX:
            return Axis.horizontal
        case .centerY:
            return Axis.vertical
        default:
            return nil
        }
    }
}
