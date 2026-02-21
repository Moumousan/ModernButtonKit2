//
//  TitleGapPanel.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/09.
//

import SwiftUI

/// タイトルラベル用に、上辺中央に「切り欠き（ギャップ）」を持つパネル境界シェイプ。
///
/// - 角は常に外向きの角丸（convex）として描画する。
/// - fill ではなく stroke 専用の利用を想定しているため、上辺のギャップ部分は
///   あえて閉じずに開いたパスとして実装している。
struct TitleGapPanel: InsettableShape {

    /// 四隅の角丸半径
    var cornerRadius: CGFloat

    /// 上辺中央に空けるギャップの幅
    var gapWidth: CGFloat

    /// InsettableShape 用のオフセット
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        var path = Path()

        let w = rect.width
        let h = rect.height
        guard w > 0, h > 0 else { return path }

        let maxR = min(w, h) / 2
        let r = min(cornerRadius, maxR)

        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        let midX = rect.midX
        let halfGap = max(0, gapWidth / 2)

        // --- パス定義 ---
        // 上辺左側の線分の終点（ギャップ左端）
        let gapLeftX  = max(minX + r, midX - halfGap)
        let gapRightX = min(maxX - r, midX + halfGap)

        // 1) ギャップ左端からスタートし、反時計回りに一周（ただしギャップは描かない）

        // 上辺左側：ギャップ左端 → 左上角の角丸開始点
        path.move(to: CGPoint(x: gapLeftX, y: minY))
        path.addLine(to: CGPoint(x: minX + r, y: minY))

        // 左上：外向き角丸（270°→180°）
        path.addArc(
            center: CGPoint(x: minX + r, y: minY + r),
            radius: r,
            startAngle: .degrees(270),
            endAngle: .degrees(180),
            clockwise: true
        )

        // 左辺
        path.addLine(to: CGPoint(x: minX, y: maxY - r))

        // 左下：外向き角丸（180°→90°）
        path.addArc(
            center: CGPoint(x: minX + r, y: maxY - r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )

        // 下辺
        path.addLine(to: CGPoint(x: maxX - r, y: maxY))

        // 右下：外向き角丸（90°→0°）
        path.addArc(
            center: CGPoint(x: maxX - r, y: maxY - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        // 右辺
        path.addLine(to: CGPoint(x: maxX, y: minY + r))

        // 右上：外向き角丸（0°→270°）
        path.addArc(
            center: CGPoint(x: maxX - r, y: minY + r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(270),
            clockwise: true
        )

        // 上辺右側：右上角の角丸終点 → ギャップ右端
        path.addLine(to: CGPoint(x: gapRightX, y: minY))

        // ※ ギャップ部分（gapLeftX〜gapRightX）は move を入れないことで
        //    パスをあえて閉じず、stroke 時に線を描かない領域として扱う。
        //    closeSubpath() は呼ばない。

        return path
    }
}
