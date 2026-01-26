//
//  MBGGlowPreset.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

import SwiftUI

/// Config/MBGGlowPreset.swift
/// セグメンタリーボタン用の光芒（グロー）プリセット。
public enum MBGGlowPreset: Sendable {
    /// ひかえめに光る
    case subtle
    /// CloCar デモ相当の標準的な光り方
    case normal
    /// 全体的に強めに光る
    case strong
    /// ハロー型の光芒エフェクト
    /// - Parameters:
    ///   - color: ハローの色
    ///   - strength: 強さプリセット
    ///   - spread: 広がり具合プリセット
    case halo(
        color: Color,
        strength: Strength,
        spread: Spread
    )

    // MARK: - Nested presets

    /// 光の強さプリセット
    public enum Strength: Sendable {
        case subtle
        case normal
        case strong
    }

    /// 広がり具合のプリセット
    public enum Spread: Sendable {
        case tight
        case medium
        case wide
    }

    // MARK: - Derived parameters

    /// ハロー全体のスケール（cornerRadius に対する倍率）
    public var scale: CGFloat {
        switch self {
        case .subtle:
            return 1.03              // ほんのり
        case .normal:
            return 1.07              // CloCar demo 相当
        case .strong:
            return 1.12              // 少し大きく
        case .halo(_, let strength, _):
            // halo のときも、強さプリセットに追従
            switch strength {
            case .subtle: return 1.03
            case .normal: return 1.07
            case .strong: return 1.12
            }
        }
    }

    /// ハローの厚み（ボタン幅に対する割合）
    public var widthFactor: CGFloat {
        switch self {
        case .subtle:
            return 0.30
        case .normal:
            return 0.50              // CloCar demo 相当
        case .strong:
            return 0.80              // 外側にぐっと伸ばす
        case .halo(_, let strength, let spread):
            // 強さと spread から動的に計算
            let base: CGFloat
            switch strength {
            case .subtle: base = 0.30
            case .normal: base = 0.50
            case .strong: base = 0.80
            }

            let spreadFactor: CGFloat
            switch spread {
            case .tight:  spreadFactor = 0.8
            case .medium: spreadFactor = 1.0
            case .wide:   spreadFactor = 1.3
            }

            return base * spreadFactor
        }
    }

    /// 内側のぼんやり光る部分の不透明度
    public var fillOpacity: Double {
        switch self {
        case .subtle:
            return 0.18
        case .normal:
            return 0.35              // CloCar demo 相当
        case .strong:
            return 0.65              // 中身をかなり明るく
        case .halo(_, let strength, _):
            // halo も強さに追従
            switch strength {
            case .subtle: return 0.18
            case .normal: return 0.35
            case .strong: return 0.65
            }
        }
    }

    /// 外周の輪郭光の不透明度
    public var strokeOpacity: Double {
        switch self {
        case .subtle:
            return 0.70
        case .normal:
            return 0.95              // CloCar demo 相当
        case .strong:
            return 1.00
        case .halo(_, let strength, _):
            // halo も強さに追従
            switch strength {
            case .subtle: return 0.70
            case .normal: return 0.95
            case .strong: return 1.00
            }
        }
    }
}
