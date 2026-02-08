//
//
//  MBGShapePrimitives.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/05.
//
//
//
//


import SwiftUI

/// 左右どちらか片側だけ丸めた「D 型」パネル。
/// - `.left`  : 左側の上下だけ角丸（右側は直角）
/// - `.right` : 右側の上下だけ角丸（左側は直角）
public struct DSidePanel: Shape, InsettableShape, Sendable {

    public enum Side: Sendable {
        case left
        case right
    }

    /// 角のスタイル
        public enum CornerKind: Equatable, Sendable {
            case square                 // 四角
            case convex(CGFloat)        // 外側に丸める（普通の角丸）
            case concave(CGFloat)       // 内側にえぐる
            case capsule                // 高さに応じたカプセル
        }

        public var cornerRadius: CGFloat
        public var side: Side
        public var cornerKind: CornerKind

        /// InsettableShape 用
        public var insetAmount: CGFloat = 0

        // ★ ここがポイント：cornerKind をパラメータに追加（デフォルト付き）
        public init(
            cornerRadius: CGFloat,
            side: Side,
            cornerKind: CornerKind = .convex(0)  // とりあえず普通の角丸相当
        ) {
            self.cornerRadius = cornerRadius
            self.side = side
            self.cornerKind = cornerKind
        }

    // MARK: - InsettableShape

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    // MARK: - Shape

    public func path(in rect: CGRect) -> Path {
        // insetAmount 分だけ内側に縮める
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)

        let x0 = rect.minX
        let x1 = rect.maxX
        let y0 = rect.minY
        let y1 = rect.maxY

        let r = max(0, min(cornerRadius, (y1 - y0) / 2, (x1 - x0) / 2))

        var path = Path()

        switch side {
        case .left:
            path.move(to: CGPoint(x: x0 + r, y: y0))
            path.addLine(to: CGPoint(x: x1, y: y0))
            path.addLine(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x0 + r, y: y1))

            path.addArc(
                center: CGPoint(x: x0 + r, y: y1 - r),
                radius: r,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )

            path.addLine(to: CGPoint(x: x0, y: y0 + r))

            path.addArc(
                center: CGPoint(x: x0 + r, y: y0 + r),
                radius: r,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )

        case .right:
            path.move(to: CGPoint(x: x0, y: y0))
            path.addLine(to: CGPoint(x: x1 - r, y: y0))

            path.addArc(
                center: CGPoint(x: x1 - r, y: y0 + r),
                radius: r,
                startAngle: .degrees(270),
                endAngle: .degrees(0),
                clockwise: false
            )

            path.addLine(to: CGPoint(x: x1, y: y1 - r))

            path.addArc(
                center: CGPoint(x: x1 - r, y: y1 - r),
                radius: r,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )

            path.addLine(to: CGPoint(x: x0, y: y1))
            path.addLine(to: CGPoint(x: x0, y: y0))
        }

        path.closeSubpath()
        return path
    }
}
