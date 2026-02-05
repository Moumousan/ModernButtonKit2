import SwiftUI


/// 左右どちらか片側だけが丸い「D字型」パネル。
/// - `side == .right`  : 左が直線 / 右が上下だけ角丸
/// - `side == .left`   : 右が直線 / 左が上下だけ角丸
public struct DSidePanel: Shape, Sendable {

    public enum Side: Sendable {
        case left   // 左側がフラット、右側が角丸
        case right  // 右側がフラット、左側が角丸
    }

    public var cornerRadius: CGFloat
    public var side: Side

    public init(cornerRadius: CGFloat, side: Side) {
        self.cornerRadius = cornerRadius
        self.side = side
    }

    public func path(in rect: CGRect) -> Path {
        let r = min(cornerRadius,
                    rect.width  / 2,
                    rect.height / 2)

        var path = Path()

        switch side {
        case .left:
            // 左側フラット / 右側だけ上下角丸
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))                // 左上
            path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))         // 上辺
            path.addArc(                                                     // 右上角
                center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
                radius: r,
                startAngle: .degrees(-90),
                endAngle: .degrees(0),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))         // 右辺
            path.addArc(                                                     // 右下角
                center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
                radius: r,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))             // 下辺
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))             // 左辺

        case .right:
            // 右側フラット / 左側だけ上下角丸（左右ミラー）
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))                // 右上
            path.addLine(to: CGPoint(x: rect.minX + r, y: rect.minY))         // 上辺
            path.addArc(                                                     // 左上角
                center: CGPoint(x: rect.minX + r, y: rect.minY + r),
                radius: r,
                startAngle: .degrees(-90),
                endAngle: .degrees(-180),
                clockwise: true
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - r))         // 左辺
            path.addArc(                                                     // 左下角
                center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
                radius: r,
                startAngle: .degrees(180),
                endAngle: .degrees(90),
                clockwise: true
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))             // 下辺
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))             // 右辺
        }

        path.closeSubpath()
        return path
    }
}
