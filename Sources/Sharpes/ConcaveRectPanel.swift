//
//  ConcaveRectPanel.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/11.
//


import SwiftUI

/// 四隅すべてが内側にえぐれたパネル。
///
/// Contents を置くための「本家スタイル」用。
public struct ConcaveRectPanel: InsettableShape, Sendable {

    /// えぐれ量（＝半径）
    public var radius: CGFloat

    /// InsettableShape 用
    public var insetAmount: CGFloat = 0

    public init(radius: CGFloat) {
        self.radius = radius
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    public func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)

        let x0 = rect.minX
        let x1 = rect.maxX
        let y0 = rect.minY
        let y1 = rect.maxY

        let r = max(
            0,
            min(radius, (x1 - x0) / 2, (y1 - y0) / 2)
        )

        var path = Path()

        // 上辺の中央からスタート
        path.move(to: CGPoint(x: x0 + r, y: y0))

        // ── 上辺 → 右上 concave
        path.addLine(to: CGPoint(x: x1 - r, y: y0))
        path.addArc(
            center: CGPoint(x: x1 - r, y: y0 + r),
            radius: r,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: true      // 内側にえぐる
        )

        // ── 右辺 → 右下 concave
        path.addLine(to: CGPoint(x: x1, y: y1 - r))
        path.addArc(
            center: CGPoint(x: x1 - r, y: y1 - r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: true
        )

        // ── 下辺 → 左下 concave
        path.addLine(to: CGPoint(x: x0 + r, y: y1))
        path.addArc(
            center: CGPoint(x: x0 + r, y: y1 - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: true
        )

        // ── 左辺 → 左上 concave
        path.addLine(to: CGPoint(x: x0, y: y0 + r))
        path.addArc(
            center: CGPoint(x: x0 + r, y: y0 + r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: true
        )

        path.closeSubpath()
        return path
    }
}

