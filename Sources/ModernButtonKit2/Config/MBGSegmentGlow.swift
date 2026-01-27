//
//  MBGSegmentGlow.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/20.
//


import SwiftUI

/// セグメンタリー用の glow 設定。
public enum MBGSegmentGlow: Sendable {
    /// ハロー型 glow（光芒）。
    case halo(
        color: Color,
        strength: Strength = .normal,
        spread: Spread = .medium,
        tuning: MBGGlowTuning = .standard
    )
    case none
    /// 光の強さプリセット
    public enum Strength: Sendable {
        case subtle
        case normal
        case strong
    }
    
    /// 光の広がり具合プリセット
    public enum Spread: Sendable {
        case tight
        case medium
        case wide
    }
    
    public typealias MBGGlowStrength = MBGSegmentGlow.Strength
    public typealias MBGGlowSpread  = MBGSegmentGlow.Spread
}

