import SwiftUI

/// セグメンタリー用の glow 設定。
public enum MBGSegmentGlow: Sendable {
    /// ハロー型 glow（光芒）。
    case halo(color: Color, strength: Strength, spread: Spread)

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
}