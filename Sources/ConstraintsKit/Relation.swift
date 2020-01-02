//
//  Relation.swift
//  ConstraintsKit
//
//  Created by Astemir Eleev on 06/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

public enum Relation: Int {
    case lessThanOrEqual = -1
    case equal = 0
    case greaterThanOrEqual = 1
}

extension Relation {
    
    func convert() -> NSLayoutConstraint.Relation {
        switch self {
        case .equal:
            return .equal
        case .lessThanOrEqual:
            return .lessThanOrEqual
        case .greaterThanOrEqual:
            return .greaterThanOrEqual
        }
    }
}
