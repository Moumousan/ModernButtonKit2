//
//  MBGToolbarStyle.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/23.
//
//  🎨 共通ツールバースタイル
//  ────────────────────────────────
//  MBGHybridToolbar, MBGSegmentary, MBGToggle など
//  あらゆるレイアウトで再利用可能
//

import SwiftUI

@available(macOS 12.0, iOS 15.0, *)
public enum MBGToolbarStyle: Equatable {
    /// 完全透明（背景なし）
    case clear
    /// macOS / iPadOS の .ultraThinMaterial
    case material
    /// 半透明のガラス風（α=0.3）
    case glass
    /// 固定色塗りつぶし
    case solid(Color)
}

// MARK: - ViewModifierで利用可能にする
@available(macOS 12.0, iOS 15.0, *)
public struct MBGToolbarBackground: ViewModifier {
    let style: MBGToolbarStyle

    public func body(content: Content) -> some View {
        content
            .background(backgroundView(for: style))
            .overlay(alignment: .bottom) { Divider() }
    }

    @ViewBuilder
    private func backgroundView(for style: MBGToolbarStyle) -> some View {
        switch style {
        case .clear:
            Color.clear
        case .material:
            // ファイルスコープの @available により追加の #available は不要
            Rectangle().fill(.ultraThinMaterial)
        case .glass:
            // ZStack でレイヤー順を明示（background の重ねを避ける）
            ZStack {
                Color.white.opacity(0.05)
                Rectangle().fill(Color.white.opacity(0.25))
            }
        case .solid(let color):
            Rectangle().fill(color)
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
public extension View {
    /// 共通スタイル適用ショートハンド
    func mbgToolbarStyle(_ style: MBGToolbarStyle) -> some View {
        modifier(MBGToolbarBackground(style: style))
    }
}
