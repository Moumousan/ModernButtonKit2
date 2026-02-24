//
//  Shape+PanelBorder.swift
//  ModernButtonKit2
//
//  汎用パネル枠線描画ヘルパー
//

import SwiftUI

/// `InsettableShape` に対して、
/// `PanelBorderStyle` を使って単線/二重線の枠を描くヘルパー。
public extension InsettableShape {

    /// パネル用の枠線を描画。
    ///
    /// - note:
    ///   - 単線: `self.stroke(outerColor, lineWidth: outerWidth)`
    ///   - 二重線:
    ///       - 外線: 同上
    ///       - 内線: `outerWidth + gap` だけ内側に inset して描画
    @ViewBuilder
    func panelBorder(_ style: PanelBorderStyle) -> some View {
        switch style.kind {
        case .single:
            self.stroke(style.outerColor, lineWidth: style.outerWidth)

        case .double(let gap):
            ZStack {
                // 外側の線
                self.stroke(style.outerColor, lineWidth: style.outerWidth)

                // 内側の線
                //
                // centerline ベースでざっくり言うと、
                // 外線の center から内線の center まで
                // 「outerWidth/2 + gap + innerWidth/2」程度離れる感じ。
                self
                    .inset(by: style.outerWidth + gap)
                    .stroke(style.innerColor, lineWidth: style.innerWidth)
            }
        }
    }
}

public extension View {

    /// パネル型の枠線装飾を View に適用
    ///
    /// - Parameters:
    ///   - shape: 外形を決定するシェイプ（例: `RoundedRectangle`）
    ///   - style: 枠線スタイル（単線／二重線／色／幅など）
    /// - Returns: 枠付きビュー
    @ViewBuilder
    func panelFramed<S: InsettableShape>(
        _ shape: S,
        style: PanelBorderStyle
    ) -> some View {
        self
            .padding() // ← 内容にスペースが必要な場合（調整可）
            .background(
                shape.fill(Color(.gray))
            )
            .overlay(
                shape.panelBorder(style)
            )
    }
}
