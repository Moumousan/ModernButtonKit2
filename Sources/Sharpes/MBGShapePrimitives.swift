import SwiftUI

/// 左右どちらか片側だけ丸めた「D 型」パネル.
/// - left: 左側が直線、右側が丸.
/// - right: 右側が直線、左側が丸.
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
        // パネルのサイズをはみ出さないように半径を制限
        let r = min(cornerRadius, rect.width / 2, rect.height / 2)
        let midY = rect.midY

        var path = Path()

        switch side {
        case .left:
            // 左がまるい D（右が直線）
            path.move(to: CGPoint(x: rect.minX + r, y: rect.minY))                // 上の丸み開始
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))                 // 上辺（右端へ）
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))                 // 右辺（下へ）
            path.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))             // 下辺（左へ）
            // 左側の半円
            path.addArc(
                center: CGPoint(x: rect.minX + r, y: midY),
                radius: r,
                startAngle: .degrees(90),
                endAngle: .degrees(270),
                clockwise: true
            )

        case .right:
            // 右がまるい D（左が直線）
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))                    // 左上
            path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))             // 上辺（右側の丸みの手前）
            // 右側の半円
            path.addArc(
                center: CGPoint(x: rect.maxX - r, y: midY),
                radius: r,
                startAngle: .degrees(270),
                endAngle: .degrees(90),
                clockwise: true
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))                 // 下辺（左端へ戻る）
        }

        path.closeSubpath()
        return path
    }
}

