// Sources/ModernButtonKit2/Config/Glow/MBGGlowTuning+Defaults.swift

public extension MBGGlowTuning {
    /// セグメンタリ系の標準ハロー
    static let standard = MBGGlowTuning(
        fillSubtle: 0.18,
        fillNormal: 0.60,
        fillStrong: 0.90,
        strokeSubtle: 0.60,
        strokeNormal: 0.90,
        strokeStrong: 1.20,
        baseBlurScale: 0.60,
        spreadTight: 0.60,
        spreadMedium: 1.00,
        spreadWide: 1.40
    )

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