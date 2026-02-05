import SwiftUI

/// 左右どちらか片側だけ丸めた「D 型」パネル。
/// - `.left`  : 左側の上下だけ角丸（右側は直角）
/// - `.right` : 右側の上下だけ角丸（左側は直角）
public struct DSidePanel: Shape, Sendable {

    public enum Side: Sendable {
        case left
        case right
    }

    public var cornerRadius: CGFloat
    public var side: Side

    public init(cornerRadius: CGFloat, side: Side) {
        self.cornerRadius = cornerRadius
        self.side = side
    }

    public func path(in rect: CGRect) -> Path {
        let x0 = rect.minX
        let x1 = rect.maxX
        let y0 = rect.minY
        let y1 = rect.maxY

        // はみ出さないように半径を制限
        let r = max(0, min(cornerRadius, (y1 - y0) / 2, (x1 - x0) / 2))

        var path = Path()

        switch side {
        case .left:
            // 左側だけ上下が角丸

            // スタート: 上辺の左角丸の右端
            path.move(to: CGPoint(x: x0 + r, y: y0))

            // 上辺 → 右上
            path.addLine(to: CGPoint(x: x1, y: y0))

            // 右辺 ↓
            path.addLine(to: CGPoint(x: x1, y: y1))

            // 下辺 → 左下角丸の右端
            path.addLine(to: CGPoint(x: x0 + r, y: y1))

            // 左下の角丸（90°→180°）
            path.addArc(
                center: CGPoint(x: x0 + r, y: y1 - r),
                radius: r,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )

            // 左辺 ↑
            path.addLine(to: CGPoint(x: x0, y: y0 + r))

            // 左上の角丸（180°→270°）
            path.addArc(
                center: CGPoint(x: x0 + r, y: y0 + r),
                radius: r,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )

        case .right:
            // 右側だけ上下が角丸

            // スタート: 左上
            path.move(to: CGPoint(x: x0, y: y0))

            // 上辺 → 右上角丸の左端
            path.addLine(to: CGPoint(x: x1 - r, y: y0))

            // 右上の角丸（270°→360°）
            path.addArc(
                center: CGPoint(x: x1 - r, y: y0 + r),
                radius: r,
                startAngle: .degrees(270),
                endAngle: .degrees(0),
                clockwise: false
            )

            // 右辺 ↓
            path.addLine(to: CGPoint(x: x1, y: y1 - r))

            // 右下の角丸（0°→90°）
            path.addArc(
                center: CGPoint(x: x1 - r, y: y1 - r),
                radius: r,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )

            // 下辺 ←
            path.addLine(to: CGPoint(x: x0, y: y1))

            // 左辺 ↑
            path.addLine(to: CGPoint(x: x0, y: y0))
        }

        path.closeSubpath()
        return path
    }
}
