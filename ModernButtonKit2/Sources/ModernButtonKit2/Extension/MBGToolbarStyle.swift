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
public enum MBGToolbarStyle: Equatable, Sendable {
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
            .overlay(Divider(), alignment: .bottom)
    }

    @ViewBuilder
    private func backgroundView(for style: MBGToolbarStyle) -> some View {
        switch style {
        case .clear:
            Color.clear
        case .material:
            if #available(macOS 12.0, iOS 15.0, *) {
                Rectangle().fill(.ultraThinMaterial)
            } else {
                Rectangle().fill(Color.gray.opacity(0.1))
            }
        case .glass:
            Rectangle().fill(Color.white.opacity(0.25))
                .background(Color.white.opacity(0.05))
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
