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
        case square                 // 四角（角丸なし）
        case convex(CGFloat)        // 外側に丸める（普通の角丸）
        case concave(CGFloat)       // 内側にえぐる（将来の拡張用。現状は convex と同じ扱い）
        case capsule                // 高さに応じたカプセル
    }

    public var cornerRadius: CGFloat
    public var side: Side
    public var cornerKind: CornerKind

    /// InsettableShape 用
    public var insetAmount: CGFloat = 0

    /// - Parameters:
    ///   - cornerRadius: 基本となる角丸半径
    ///   - side: どちら側を丸めるか
    ///   - cornerKind: 角のスタイル（省略時は `.convex(cornerRadius)`）
    public init(
        cornerRadius: CGFloat,
        side: Side,
        cornerKind: CornerKind? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.side = side
        // 省略時は普通の角丸として扱う
        if let cornerKind {
            self.cornerKind = cornerKind
        } else {
            self.cornerKind = .convex(cornerRadius)
        }
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

        // 取り得る最大半径（上下・左右の半分のうち小さい方）
        let maxR = min((y1 - y0) / 2, (x1 - x0) / 2)

        // CornerKind に応じて実際に使う半径を決める
        let r: CGFloat
        switch cornerKind {
        case .square:
            r = 0

        case .convex(let value):
            let base = (value == 0) ? cornerRadius : value
            r = max(0, min(base, maxR))

        case .concave(let value):
            // 現時点では convex と同じ半径扱い。
            // 将来、内側にえぐるパスに差し替えるときもこの r を使う。
            let base = (value == 0) ? cornerRadius : value
            r = max(0, min(base, maxR))

        case .capsule:
            // D 型パネルとして取り得る最大半径 = カプセル
            r = maxR
        }

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
