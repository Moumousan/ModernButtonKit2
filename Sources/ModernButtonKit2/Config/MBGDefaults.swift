//
//  MBGDefaults.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

// ModernButtonKit2/Config/MBGDefaults.swift
import SwiftUI

enum _MBGDefaults {
    enum Segment {
        static let preset: MBGSegmentPreset = .large   // ← 今は large を標準に
        static var buttonHeight: CGFloat     { preset.buttonHeight }
        static var baseCornerRadius: CGFloat { preset.baseCornerRadius }
        static var font: UIFont              { preset.font }
    }
    enum SegmentSize {
        static let compactHeight: CGFloat  = 28
        static let standardHeight: CGFloat = 40
        static let largeHeight: CGFloat    = 52
    }
    
    enum Glow {
        static let preset: MBGGlowPreset = .normal
        
        static var scale: CGFloat        { preset.scale }
        static var widthFactor: CGFloat  { preset.widthFactor }
        static var fillOpacity: Double   { preset.fillOpacity }
        static var strokeOpacity: Double { preset.strokeOpacity }
    }
}
