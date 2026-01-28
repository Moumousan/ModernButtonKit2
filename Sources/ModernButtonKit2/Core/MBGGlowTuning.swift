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
}
    // デフォルトプリセット

public extension MBGGlowTuning {

    /// Segmentary の標準ハロー設定。
    /// 内部の発光は無効（fill 系は 0）、枠＋外側の光芒のみを使う。
    static let standard = MBGGlowTuning(
        fillSubtle:   0.0,   // ← 内部は触らない
        fillNormal:   0.0,
        fillStrong:   0.0,
        strokeSubtle: 0.30,
        strokeNormal: 0.60,
        strokeStrong: 0.90,
        baseBlurScale: 0.60,
        spreadTight:   0.70,
        spreadMedium:  1.00,
        spreadWide:    1.30
    )

    /// 以前の「内部も光る」プリセットを残したい場合は別名で退避しておく。
    static let legacyInnerGlow = MBGGlowTuning(
        fillSubtle:   0.09,
        fillNormal:   0.18,
        fillStrong:   0.27,
        strokeSubtle: 0.30,
        strokeNormal: 0.60,
        strokeStrong: 0.90,
        baseBlurScale: 0.60,
        spreadTight:   0.70,
        spreadMedium:  1.00,
        spreadWide:    1.30
    )
}

/*
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
 */



