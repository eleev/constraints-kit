//
//  Axis.swift
//  ConstraintsKit
//
//  Created by Astemir Eleev on 06/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public protocol AxisType {
    // Empty protocol, used as Marker Design Pattern
}

public enum Axis: AxisType {
    case horizontal, vertical
}

extension Axis {
    
    func convert() -> Attribute {
        switch self {
        case .horizontal:
            return .centerX
        case .vertical:
            return .centerY
        }
    }
}
