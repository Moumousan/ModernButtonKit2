//
//  PanelBorderStyle.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/06.
//

import SwiftUI

/// パネル系シェイプの枠線スタイル。
///
/// - `kind` で単線 / 二重線を切り替え
/// - 幅・色は outer / inner で個別指定
public struct PanelBorderStyle: Sendable, Equatable {

    /// 枠線の種類
    public enum Kind: Sendable, Equatable {
        /// 単線
        case single
        /// 二重線（外線と内線の間隔を指定）
        ///
        /// `gap` は「外線の内側エッジ」と
        /// 「内線の外側エッジ」の間の距離、というイメージ。
        case double(gap: CGFloat)
    }

    /// 単線 or 二重線
    public var kind: Kind

    /// 外側の線の線幅
    public var outerWidth: CGFloat

    /// 内側の線の線幅（`single` の場合は無視されてもよい）
    public var innerWidth: CGFloat

    /// 外側の線の色
    public var outerColor: Color

    /// 内側の線の色
    public var innerColor: Color

    public init(
        kind: Kind = .single,
        outerWidth: CGFloat = 1,
        innerWidth: CGFloat = 1,
        outerColor: Color = .secondary,
        innerColor: Color = .secondary
    ) {
        self.kind = kind
        self.outerWidth = outerWidth
        self.innerWidth = innerWidth
        self.outerColor = outerColor
        self.innerColor = innerColor
    }
}

// MARK: - よく使うプリセット

public extension PanelBorderStyle {

    /// デフォルトの単線ボーダー
    static let standard = PanelBorderStyle(
        kind: .single,
        outerWidth: 1,
        innerWidth: 0,
        outerColor: .secondary,
        innerColor: .clear
    )

    /// QAC のインスペクタ用：
    /// 外やや濃いグレー、内白、細め二重線
    static let inspector = PanelBorderStyle(
        kind: .double(gap: 1),
        outerWidth: 1.5,
        innerWidth: 1,
        outerColor: .secondary.opacity(0.6),
        innerColor: .white
    )

    /// シンプルな二重線（同色）
    static let doubleSecondary = PanelBorderStyle(
        kind: .double(gap: 2),
        outerWidth: 1.5,
        innerWidth: 1,
        outerColor: .secondary,
        innerColor: .secondary
    )

    /// ごく普通の単線（.secondary / 1pt）
    static let singleSecondary = PanelBorderStyle(
        kind: .single,
        outerWidth: 1,
        innerWidth: 0,
        outerColor: .secondary,
        innerColor: .clear
    )
}

extension Shape where Self: InsettableShape {

    @ViewBuilder
    func panelBorder(_ style: PanelBorderStyle) -> some View {
        switch style.kind {
        case .single:
            self.stroke(style.outerColor, lineWidth: style.outerWidth)

        case .double(let gap):
            self
                .stroke(style.outerColor, lineWidth: style.outerWidth)
                .overlay(
                    self
                        .inset(by: style.outerWidth + gap)
                        .stroke(style.innerColor, lineWidth: style.innerWidth)
                )
        }
    }
}
