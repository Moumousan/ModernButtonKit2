//
//  MBGDefaults.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

// ModernButtonKit2/Config/MBGDefaults.swift

import SwiftUI

// 追加の設定は extension でぶら下げる
public extension MBGDefaults {

    // MARK: - Segment

    enum Segment {
        public static let preset: MBGSegmentPreset = .large   // 標準サイズ
        public static var buttonHeight: CGFloat     { preset.buttonHeight }
        public static var baseCornerRadius: CGFloat { preset.baseCornerRadius }
        public static var font: PlatformFont        { preset.font }
    }

    enum SegmentSize {
        public static let compactHeight:  CGFloat = 28
        public static let standardHeight: CGFloat = 40
        public static let largeHeight:    CGFloat = 52
    }

    // MARK: - Glow

    enum Glow {
        public static let preset: MBGGlowPreset = .normal

        public static var scale: CGFloat        { preset.scale }
        public static var widthFactor: CGFloat  { preset.widthFactor }
        public static var fillOpacity: Double   { preset.fillOpacity }
        public static var strokeOpacity: Double { preset.strokeOpacity }
    }
}
