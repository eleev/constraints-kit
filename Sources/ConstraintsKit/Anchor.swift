//
//  Anchor.swift
//  ConstraintsKit
//
//  Created by Astemir Eleev on 08/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

public struct Anchor: OptionSet {
    
    // MARK: Conformance to OptionSet protoocl
    
    public let rawValue: UInt
    
    // MARK: - Properties
    
    public static let left          = Anchor(rawValue: 1 << 0)
    public static let right         = Anchor(rawValue: 1 << 1)
    public static let top           = Anchor(rawValue: 1 << 2)
    public static let bottom        = Anchor(rawValue: 1 << 3)
    public static let width         = Anchor(rawValue: 1 << 4)
    public static let height        = Anchor(rawValue: 1 << 5)
    public static let centerX       = Anchor(rawValue: 1 << 6)
    public static let centerY       = Anchor(rawValue: 1 << 7)
    public static let lastBaseline  = Anchor(rawValue: 1 << 8)
    public static let firstBaseline = Anchor(rawValue: 1 << 9)
    public static let trailing      = Anchor(rawValue: 1 << 10)
    public static let leading       = Anchor(rawValue: 1 << 11)
    
    // MARK: - Private properties
    
    private static let allCases: [Anchor] = [.left, .right, .top, .bottom, .width, .height, .centerX, .centerY, .lastBaseline, .firstBaseline, .trailing, .leading]
    
    // MARK: - Initializers
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    // MARK: - Methods
    
    func convert() -> [NSLayoutConstraint.Attribute] {
        var constraints = [NSLayoutConstraint.Attribute]()
        
        for `case` in Anchor.allCases where contains(`case`) {
            switch `case` {
            case .top:
                constraints += [.top]
            case .bottom:
                constraints += [.bottom]
            case .left:
                constraints += [.left]
            case .right:
                constraints += [.right]
            case .centerX:
                constraints += [.centerX]
            case .centerY:
                constraints += [.centerY]
            case .firstBaseline:
                constraints += [.firstBaseline]
            case .lastBaseline:
                constraints += [.lastBaseline]
            case .trailing:
                constraints += [.trailing]
            case .leading:
                constraints += [.leading]
            case .width:
                constraints += [.width]
            case .height:
                constraints += [.height]
            default:
                continue
            }
        }
        return constraints
    }
}


