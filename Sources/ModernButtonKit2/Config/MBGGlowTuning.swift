//
//  MBGGlowTuning.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/18.
//

import SwiftUI


// Kit2 内（Core か Config フォルダ）
public struct MBGGlowTuning: Sendable {
    // 各プリセットの内側・外側の不透明度
    public var fillSubtle: Double
    public var fillNormal: Double
    public var fillStrong: Double

    public var strokeSubtle: Double
    public var strokeNormal: Double
    public var strokeStrong: Double

    /// cornerRadius に掛けるベースのぼかし係数
    public var baseBlurScale: CGFloat

    public init(
        fillSubtle: Double,
        fillNormal: Double,
        fillStrong: Double,
        strokeSubtle: Double,
        strokeNormal: Double,
        strokeStrong: Double,
        baseBlurScale: CGFloat
    ) {
        self.fillSubtle = fillSubtle
        self.fillNormal = fillNormal
        self.fillStrong = fillStrong
        self.strokeSubtle = strokeSubtle
        self.strokeNormal = strokeNormal
        self.strokeStrong = strokeStrong
        self.baseBlurScale = baseBlurScale
    }

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
