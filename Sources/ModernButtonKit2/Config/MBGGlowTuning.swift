//
//  MBGGlowTuning.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/18.
//

import SwiftUI


// MBGGlowTuning.swift（イメージ）
public struct MBGGlowTuning: Equatable, Sendable {
    // 内側の塗りの不透明度
    public var fillSubtle:  Double
    public var fillNormal:  Double
    public var fillStrong:  Double

    // 輪郭線の不透明度
    public var strokeSubtle: Double
    public var strokeNormal: Double
    public var strokeStrong: Double

    // ぼかし・広がり
    public var baseBlurScale: CGFloat
    public var spreadTight:   CGFloat
    public var spreadMedium:  CGFloat
    public var spreadWide:    CGFloat

    // ← ここでは init を自前で書かない
    //   （stored property だけ定義しておけば
    //     Swift が memberwise init を自動生成してくれます）
}

// デフォルトプリセット
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


