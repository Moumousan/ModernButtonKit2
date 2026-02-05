//
//  TitleGapPanel.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/05.
//


//
//  TitleGapPanel.swift
//  ModernButtonKit2
//
//  A rounded rectangle outline with a gap in the top edge
//  for placing a title label box.
//

import SwiftUI

/// 四辺に枠線があるが、上辺の中央だけ線を抜いたパネルシェイプ。
///
/// Use this with `.strokeBorder` or `.stroke`:
///
/// ```swift
/// TitleGapPanel(cornerRadius: 24, gapWidth: 120)
///     .strokeBorder(Color.secondary, lineWidth: 1)
/// ```
///
/// The missing segment on the top edge is centred horizontally.
public struct TitleGapPanel: Shape, Sendable {
    /// 角丸の半径。
    public var cornerRadius: CGFloat

    /// 上辺で線を抜く幅（中央に配置される）。
    public var gapWidth: CGFloat

    public init(cornerRadius: CGFloat = 16,
                gapWidth: CGFloat = 120) {
        self.cornerRadius = cornerRadius
        self.gapWidth = gapWidth
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.width
        let h = rect.height
        guard w > 0, h > 0 else { return path }

        let r = min(cornerRadius, w / 2, h / 2)

        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        let leftX  = minX + r
        let rightX = maxX - r
        let topY   = minY
        let bottomY = maxY

        // gap は左右の角丸の内側に収まるようにクランプ
        let maxGap = max(0, rightX - leftX)
        let gap = min(maxGap, max(0, gapWidth))
        let halfGap = gap / 2

        let centerX = rect.midX
        let gapStartX = max(leftX, centerX - halfGap)
        let gapEndX   = min(rightX, centerX + halfGap)

        // ---- パスを描く ----
        // 上辺の「右側」からスタートして時計回りに一周
        path.move(to: CGPoint(x: gapEndX, y: topY))

        // 上辺 → 右上コーナー
        path.addLine(to: CGPoint(x: rightX, y: topY))
        path.addArc(
            center: CGPoint(x: rightX, y: topY + r),
            radius: r,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        // 右辺
        path.addLine(to: CGPoint(x: maxX, y: bottomY - r))

        // 右下コーナー
        path.addArc(
            center: CGPoint(x: rightX, y: bottomY - r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        // 下辺
        path.addLine(to: CGPoint(x: leftX, y: bottomY))

        // 左下コーナー
        path.addArc(
            center: CGPoint(x: leftX, y: bottomY - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        // 左辺
        path.addLine(to: CGPoint(x: minX, y: topY + r))

        // 左上コーナー
        path.addArc(
            center: CGPoint(x: leftX, y: topY + r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        // 上辺の「左側」まで
        path.addLine(to: CGPoint(x: gapStartX, y: topY))

        // ここで終了：gapStartX〜gapEndX 間は線が引かれない
        // （あえて closeSubpath() は呼ばない）

        return path
    }
}