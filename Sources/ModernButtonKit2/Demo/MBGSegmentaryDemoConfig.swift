//
//  MBGSegmentaryDemoConfig.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

import SwiftUI
 #if canImport(UIKit)
 import UIKit
 #endif


enum MBGSegmentaryDemoConfig {
    static let buttonHeight: CGFloat      = 52
    static let baseCornerRadius: CGFloat  = 12

    static let glowScale: CGFloat         = 1.07
    static let glowWidthFactor: CGFloat   = 0.50
    static let glowHPadFactor: CGFloat    = 0.12
    static let glowVPadFactor: CGFloat    = 0.08

    static let glowFillOpacity: Double    = 0.35
    static let glowStrokeOpacity: Double  = 0.95
}
