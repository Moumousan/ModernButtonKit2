//
//  MBGGlowTuning+Defaults.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/26.
//


// Sources/ModernButtonKit2/Config/Glow/MBGGlowTuning+Defaults.swift

import SwiftUI

public extension MBGGlowTuning {
    /// Playground 用のちょっと強めプリセット、など
    static let demoStrong = MBGGlowTuning(
        fillSubtle: 0.30,
        fillNormal: 0.80,
        fillStrong: 1.00,
        strokeSubtle: 0.80,
        strokeNormal: 1.20,
        strokeStrong: 1.50,
        baseBlurScale: 0.80,
        spreadTight: 0.80,
        spreadMedium: 1.20,
        spreadWide: 1.60
    )
}

