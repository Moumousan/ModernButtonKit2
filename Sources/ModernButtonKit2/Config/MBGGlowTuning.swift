//
//  MBGGlowTuning.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/18.
//

import SwiftUI


public struct MBGGlowTuning: Equatable, Sendable {
    public var fillSubtle:  Double
    public var strokeSubtle: Double
    public var fillNormal:  Double
    public var strokeNormal: Double
    public var fillStrong:  Double
    public var strokeStrong: Double

    public var baseBlurScale: CGFloat   // cornerRadius から blur を決める係数
    public var spreadTight:   CGFloat
    public var spreadMedium:  CGFloat
    public var spreadWide:    CGFloat

    // ← ここに public init を書く
    public init(
           fillSubtle:  Double = 0.20,
           strokeSubtle: Double = 0.40,
           fillNormal:  Double = 0.45,
           strokeNormal: Double = 0.90,
           fillStrong:  Double = 0.70,
           strokeStrong: Double = 1.00,
           baseBlurScale: CGFloat = 0.60,
           spreadTight:   CGFloat = 0.60,
           spreadMedium:  CGFloat = 1.00,
           spreadWide:    CGFloat = 1.40
       ) {
           self.fillSubtle    = fillSubtle
           self.strokeSubtle  = strokeSubtle
           self.fillNormal    = fillNormal
           self.strokeNormal  = strokeNormal
           self.fillStrong    = fillStrong
           self.strokeStrong  = strokeStrong
           self.baseBlurScale = baseBlurScale
           self.spreadTight   = spreadTight
           self.spreadMedium  = spreadMedium
           self.spreadWide    = spreadWide
       }

    /// 互換用の標準プリセット
    static let standard = MBGGlowTuning()
}
/*
    /// Kit2 標準値（今までの数値）
    public static let standard = MBGGlowTuning(
        fillSubtle: 0.20,
        fillNormal: 0.45,
        fillStrong: 0.70,
        strokeSubtle: 0.65,
        strokeNormal: 0.90,
        strokeStrong: 1.00,
        baseBlurScale: 0.9    // いま haloGroup で使っている値
    )
}
*/
