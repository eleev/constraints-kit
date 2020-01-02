//
//  UILayoutArea.swift
//  ConstraintsKit
//
//  Created by Astemir Eleev on 08/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit


/// The following struct is an experimental development and is not used anywhere in the framework. It was intentionally marked as `private` so you will not be able to accidentally get access to this struct. Please, don't use or try to modify this struct. If a modification will be made, such a pull requrest will be declined.
private struct UILayoutArea: OptionSet {

    // MARK: - Conformance to OptionSet protocol

    public let rawValue: UInt

    // MARK: - Properties

    public static let topLeft = UILayoutArea(rawValue: 1 << 0)
    public static let topRight = UILayoutArea(rawValue: 1 << 1)
    public static let topCenter = UILayoutArea(rawValue: 1 << 2)
    public static let midLeft = UILayoutArea(rawValue: 1 << 3)
    public static let midRight = UILayoutArea(rawValue: 1 << 4)
    public static let bottomLeft = UILayoutArea(rawValue: 1 << 5)
    public static let bottomRight = UILayoutArea(rawValue: 1 << 6)
    public static let bottomCenter = UILayoutArea(rawValue: 1 << 7)

    // MARK: - Private properties

    private static let allCases: [UILayoutArea] = [ .topLeft, .topRight, .topCenter, .midLeft, .midRight, .bottomLeft, .bottomRight, .bottomCenter]

    // MARK: - Initialiezers

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    // MARK: - Methods

    internal func convert() -> [(AxisType, AxisType)] {
        var areas = [(AxisType, AxisType)]()

        for `case` in UILayoutArea.allCases where contains(`case`) {
            switch self {
            case .topLeft:
                areas += [(AxisY.top, AxisX.left)]
            case .topRight:
                areas += [(AxisY.top, AxisX.right)]
            case .topCenter:
                areas += [(AxisY.top, Axis.horizontal)]
            case .midLeft:
                areas += [(Axis.vertical, AxisX.left)]
            case .midRight:
                areas += [(Axis.vertical, AxisX.right)]
            case .bottomLeft:
                areas += [(AxisY.bottom, AxisX.left)]
            case .bottomRight:
                areas += [(AxisY.bottom, AxisX.right)]
            case .bottomCenter:
                areas += [(AxisY.bottom, Axis.horizontal)]
            default:
                continue
            }
        }

        return areas
    }
}
