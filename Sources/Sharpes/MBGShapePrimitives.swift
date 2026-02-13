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
/// - `.left`  : 左側の上下だけ処理（右側は直角）
/// - `.right` : 右側の上下だけ処理（左側は直角）
///
/// `cornerKind` は「丸める側」の上下2箇所にだけ適用されます。
public struct DSidePanel: Shape, InsettableShape, Sendable {

    public enum Side: Sendable {
        case left
        case right
    }

    /// 角のスタイル（丸める側に適用）
    public enum CornerKind: Equatable, Sendable {
        case square                 // 直角
        case convex(CGFloat)        // 外側に丸める（普通の角丸）
        case concave(CGFloat)       // 内側にえぐる（角の内側に切り込み）
        case capsule                // 高さに応じたカプセル
    }

    public var cornerRadius: CGFloat
    public var side: Side
    public var cornerKind: CornerKind

    /// InsettableShape 用
    public var insetAmount: CGFloat = 0

    public init(
        cornerRadius: CGFloat,
        side: Side,
        cornerKind: CornerKind = .convex(0)
    ) {
        self.cornerRadius = cornerRadius
        self.side = side
        self.cornerKind = cornerKind
    }

    // MARK: - InsettableShape

    public func inset(by amount: CGFloat) -> DSidePanel {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    // MARK: - Shape

    public func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        guard rect.width > 0, rect.height > 0 else { return Path() }

        let x0 = rect.minX
        let x1 = rect.maxX
        let y0 = rect.minY
        let y1 = rect.maxY

        let maxR = min(rect.width, rect.height) / 2

        // cornerKind から「実効半径」を決める
        let r: CGFloat = {
            switch cornerKind {
            case .square:
                return 0
            case .capsule:
                return min(rect.height / 2, maxR)
            case .convex(let v):
                let rr = (v == 0) ? cornerRadius : v
                return max(0, min(rr, maxR))
            case .concave(let v):
                let rr = (v == 0) ? cornerRadius : v
                return max(0, min(rr, maxR))
            }
        }()

        // r=0ならただの矩形
        if r == 0 {
            return Path(CGRect(x: x0, y: y0, width: rect.width, height: rect.height))
        }

        var p = Path()

        switch side {

        // =========================================================
        // LEFT D-SIDE
        // =========================================================
        case .left:
            switch cornerKind {
            case .convex, .capsule:
                // 左側が外側に丸い（普通のD）
                p.move(to: CGPoint(x: x0 + r, y: y0))
                p.addLine(to: CGPoint(x: x1, y: y0))
                p.addLine(to: CGPoint(x: x1, y: y1))
                p.addLine(to: CGPoint(x: x0 + r, y: y1))

                p.addArc(
                    center: CGPoint(x: x0 + r, y: y1 - r),
                    radius: r,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false
                )

                p.addLine(to: CGPoint(x: x0, y: y0 + r))

                p.addArc(
                    center: CGPoint(x: x0 + r, y: y0 + r),
                    radius: r,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false
                )

            case .concave:
                // 左側が内側にえぐれる（左上＆左下が切り込み）
                p.move(to: CGPoint(x: x0, y: y0))
                p.addLine(to: CGPoint(x: x1, y: y0))
                p.addLine(to: CGPoint(x: x1, y: y1))
                p.addLine(to: CGPoint(x: x0, y: y1))

                // 左下の内側切り込み： (x0+r, y1) -> (x0, y1-r)
                p.addLine(to: CGPoint(x: x0 + r, y: y1))
                p.addArc(
                    center: CGPoint(x: x0, y: y1),
                    radius: r,
                    startAngle: .degrees(0),
                    endAngle: .degrees(270),
                    clockwise: true
                )

                // 左上の内側切り込み： (x0, y0+r) -> (x0+r, y0)
                p.addLine(to: CGPoint(x: x0, y: y0 + r))
                p.addArc(
                    center: CGPoint(x: x0, y: y0),
                    radius: r,
                    startAngle: .degrees(90),
                    endAngle: .degrees(0),
                    clockwise: true
                )

            default:
                break
            }

        // =========================================================
        // RIGHT D-SIDE
        // =========================================================
        case .right:
            switch cornerKind {
            case .convex, .capsule:
                // 右側が外側に丸い（普通のD）
                p.move(to: CGPoint(x: x0, y: y0))
                p.addLine(to: CGPoint(x: x1 - r, y: y0))

                p.addArc(
                    center: CGPoint(x: x1 - r, y: y0 + r),
                    radius: r,
                    startAngle: .degrees(270),
                    endAngle: .degrees(0),
                    clockwise: false
                )

                p.addLine(to: CGPoint(x: x1, y: y1 - r))

                p.addArc(
                    center: CGPoint(x: x1 - r, y: y1 - r),
                    radius: r,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false
                )

                p.addLine(to: CGPoint(x: x0, y: y1))
                p.addLine(to: CGPoint(x: x0, y: y0))

            case .concave:
                // 右側が内側にえぐれる（右上＆右下が切り込み）
                p.move(to: CGPoint(x: x0, y: y0))
                p.addLine(to: CGPoint(x: x1, y: y0))
                p.addLine(to: CGPoint(x: x1, y: y1))
                p.addLine(to: CGPoint(x: x0, y: y1))
                p.addLine(to: CGPoint(x: x0, y: y0))

                // 右上： (x1-r, y0) -> (x1, y0+r)
                p.move(to: CGPoint(x: x0, y: y0))
                p.addLine(to: CGPoint(x: x1 - r, y: y0))
                p.addArc(
                    center: CGPoint(x: x1, y: y0),
                    radius: r,
                    startAngle: .degrees(180),
                    endAngle: .degrees(90),
                    clockwise: true
                )

                // 右辺を下へ
                p.addLine(to: CGPoint(x: x1, y: y1 - r))

                // 右下： (x1, y1-r) -> (x1-r, y1)
                p.addArc(
                    center: CGPoint(x: x1, y: y1),
                    radius: r,
                    startAngle: .degrees(270),
                    endAngle: .degrees(180),
                    clockwise: true
                )

                p.addLine(to: CGPoint(x: x0, y: y1))
                p.addLine(to: CGPoint(x: x0, y: y0))

            default:
                break
            }
        }

        p.closeSubpath()
        return p
    }
}
