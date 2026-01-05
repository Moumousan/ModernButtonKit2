//
//  MBGGlowPreset.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

import SwiftUI

// Config/MBGGlowPreset.swift
public enum MBGGlowPreset: Sendable {
    case subtle
    case normal
    case strong

    public var scale: CGFloat {
        switch self {
        case .subtle: return 1.03
        case .normal: return 1.07
        case .strong: return 1.10
        }
    }

    public var widthFactor: CGFloat {
        switch self {
        case .subtle: return 0.35
        case .normal: return 0.50
        case .strong: return 0.60
        }
    }

    public var fillOpacity: Double {
        switch self {
        case .subtle: return 0.20
        case .normal: return 0.35
        case .strong: return 0.50
        }
    }

    public var strokeOpacity: Double {
        switch self {
        case .subtle: return 0.80
        case .normal: return 0.95
        case .strong: return 1.00
        }
    }
}
