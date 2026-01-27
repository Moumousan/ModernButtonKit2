//
//  MBGGlowTuning.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/18.
//

import SwiftUI


// MBGGlowTuning.swift
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

public init(
        fillSubtle: Double,
        fillNormal: Double,
        fillStrong: Double,
        strokeSubtle: Double,
        strokeNormal: Double,
        strokeStrong: Double,
        baseBlurScale: Double,
        spreadTight: Double,
        spreadMedium: Double,
        spreadWide: Double
    ) {
        self.fillSubtle    = fillSubtle
        self.fillNormal    = fillNormal
        self.fillStrong    = fillStrong
        self.strokeSubtle  = strokeSubtle
        self.strokeNormal  = strokeNormal
        self.strokeStrong  = strokeStrong
        self.baseBlurScale = baseBlurScale
        self.spreadTight   = spreadTight
        self.spreadMedium  = spreadMedium
        self.spreadWide    = spreadWide
    }

    /// Segmentary デモなどで使う標準値
    public static let standard = MBGGlowTuning(
        fillSubtle: 0.18,
        fillNormal: 0.60,
        fillStrong: 1.0,
        strokeSubtle: 0.18,
        strokeNormal: 0.60,
        strokeStrong: 1.0,
        baseBlurScale: 0.60,
        spreadTight: 0.60,
        spreadMedium: 1.00,
        spreadWide: 1.40
    )
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

