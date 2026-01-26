//
//  MBGGlowTuning.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/18.
//

import SwiftUI


// MBGGlowTuning.swift（イメージ）
public struct MBGGlowTuning: Sendable {
    public var fillSubtle: Double
    public var fillNormal: Double
    public var fillStrong: Double

    public var strokeSubtle: Double
    public var strokeNormal: Double
    public var strokeStrong: Double

    public var baseBlurScale: CGFloat
    public var spreadTight: CGFloat
    public var spreadMedium: CGFloat
    public var spreadWide: CGFloat

    // 🔽 ここに public init を追加（extension ではなく struct 本体に）
    public init(
        fillSubtle: Double = 0.18,
        fillNormal: Double = 0.60,
        fillStrong: Double = 0.90,
        strokeSubtle: Double = 0.60,
        strokeNormal: Double = 0.90,
        strokeStrong: Double = 1.20,
        baseBlurScale: CGFloat = 0.60,
        spreadTight: CGFloat = 0.60,
        spreadMedium: CGFloat = 1.00,
        spreadWide: CGFloat = 1.40
    ) {
        self.fillSubtle = fillSubtle
        self.fillNormal = fillNormal
        self.fillStrong = fillStrong

        self.strokeSubtle = strokeSubtle
        self.strokeNormal = strokeNormal
        self.strokeStrong = strokeStrong

        self.baseBlurScale = baseBlurScale
        self.spreadTight = spreadTight
        self.spreadMedium = spreadMedium
        self.spreadWide = spreadWide
    }
}
// デフォルトプリセット
/*
public extension MBGGlowTuning {
    static let standard = MBGGlowTuning(
        fillSubtle:  0.20,
        fillNormal:  0.45,
        fillStrong:  0.70,
        strokeSubtle: 0.65,
        strokeNormal: 0.90,
        strokeStrong: 1.00,
        baseBlurScale: 0.90,
        spreadTight:   0.60,
        spreadMedium:  1.00,
        spreadWide:    1.40
    )
}
*/

