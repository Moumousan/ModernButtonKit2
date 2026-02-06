//
//  PanelBorderStyle.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/06.
//


import SwiftUI

/// パネル系シェイプの枠線スタイル。
public struct PanelBorderStyle: Sendable {

    public enum Kind: Sendable {
        /// 単線
        case single
        /// 二重線
        case double(gap: CGFloat) // 外線と内線の間隔
    }

    public var kind: Kind
    public var outerWidth: CGFloat
    public var innerWidth: CGFloat   // single の場合も使うが、無視してもOK
    public var outerColor: Color
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

// よく使うプリセット
public extension PanelBorderStyle {

    /// QAC のインスペクタ用：外やや濃いグレー、内白、細め
    static var inspector: PanelBorderStyle {
        .init(
            kind: .double(gap: 1),
            outerWidth: 1.5,
            innerWidth: 1,
            outerColor: .secondary.opacity(0.6),
            innerColor: .white
        )
    }

    /// 単純な単線
    static var singleSecondary: PanelBorderStyle {
        .init(kind: .single, outerWidth: 1, innerWidth: 0, outerColor: .secondary)
    }
}
// PanelBorderStyle.swift

public extension PanelBorderStyle {
    /// デフォルトの単線ボーダー
    static let standard = PanelBorderStyle(
        kind: .single,
        outerWidth: 1,
        innerWidth: 0,
        outerColor: .secondary,
        innerColor: .clear
    )
}
/*
    /// QAC のインスペクタ用とかが欲しければ、こんな感じで追加
    static let inspector = PanelBorderStyle(
        kind: .double(gap: 3),
        outerWidth: 2,
        innerWidth: 1,
        outerColor: .secondary,
        innerColor: .primary.opacity(0.7)
    )
}
*/
