//
//  MBGGlowPreset.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

import SwiftUI

// Config/MBGGlowPreset.swift
public enum MBGGlowPreset: Sendable {
    case subtle
    case normal
    case strong

    /// ハロー全体のスケール
    public var scale: CGFloat {
        switch self {
        case .subtle: return 1.03              // ほんのり
        case .normal: return 1.07              // CloCar demo 相当
        case .strong: return 1.12              // 少し大きく
        }
    }

    /// ハローの厚み（ボタン幅に対する割合）
    public var widthFactor: CGFloat {
        switch self {
        case .subtle: return 0.30
        case .normal: return 0.50              // CloCar demo 相当
        case .strong: return 0.80              // 外側にぐっと伸ばす
        }
    }

    /// 内側のぼんやり光る部分の不透明度
    public var fillOpacity: Double {
        switch self {
        case .subtle: return 0.18
        case .normal: return 0.35              // CloCar demo 相当
        case .strong: return 0.65              // 中身をかなり明るく
        }
    }

    /// 外周の輪郭光の不透明度
    public var strokeOpacity: Double {
        switch self {
        case .subtle: return 0.70
        case .normal: return 0.95              // CloCar demo 相当
        case .strong: return 1.00
        }
    }
}
