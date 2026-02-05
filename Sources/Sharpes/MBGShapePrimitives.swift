import SwiftUI

/// 左右どちらか片側だけが丸い「D字型」パネル。
/// - `side == .right`  : 左が直線 / 右が上下だけ角丸
/// - `side == .left`   : 右が直線 / 左が上下だけ角丸
public struct DSidePanel: Shape, Sendable {

    public enum Side: Sendable {
        case left
        case right
    }

    /// 丸める角の半径
    public var cornerRadius: CGFloat

    /// どちら側を丸めるか
    public var side: Side

    public init(cornerRadius: CGFloat = 32, side: Side = .right) {
        self.cornerRadius = cornerRadius
        self.side = side
    }

    public func path(in rect: CGRect) -> Path {
        // パネルのサイズに収まるように R をクランプ
        let r = max(0, min(cornerRadius,
                           rect.width / 2,
                           rect.height / 2))

        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        var path = Path()

        switch side {
        case .right:
            // 左がまっすぐ・右だけ上下が丸い
            path.move(to: CGPoint(x: minX, y: minY))                 // 左上
            path.addLine(to: CGPoint(x: maxX - r, y: minY))          // 上辺（右手前まで）

            // 右上角の 1/4 円弧
            path.addArc(
                center: CGPoint(x: maxX - r, y: minY + r),
                radius: r,
                startAngle: .degrees(-90),
                endAngle: .degrees(0),
                clockwise: false
            )

            path.addLine(to: CGPoint(x: maxX, y: maxY - r))          // 右辺（下手前まで）

            // 右下角の 1/4 円弧
            path.addArc(
                center: CGPoint(x: maxX - r, y: maxY - r),
                radius: r,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )

            path.addLine(to: CGPoint(x: minX, y: maxY))              // 下辺
            path.addLine(to: CGPoint(x: minX, y: minY))              // 左辺で上へ戻る

        case .left:
            // 右がまっすぐ・左だけ上下が丸い
            path.move(to: CGPoint(x: maxX, y: minY))                 // 右上
            path.addLine(to: CGPoint(x: minX + r, y: minY))          // 上辺（左手前まで）

            // 左上角の 1/4 円弧
            path.addArc(
                center: CGPoint(x: minX + r, y: minY + r),
                radius: r,
                startAngle: .degrees(-90),
                endAngle: .degrees(-180),
                clockwise: true
            )

            path.addLine(to: CGPoint(x: minX, y: maxY - r))          // 左辺

            // 左下角の 1/4 円弧
            path.addArc(
                center: CGPoint(x: minX + r, y: maxY - r),
                radius: r,
                startAngle: .degrees(-180),
                endAngle: .degrees(-90),
                clockwise: true
            )

            path.addLine(to: CGPoint(x: maxX, y: maxY))              // 下辺
            path.addLine(to: CGPoint(x: maxX, y: minY))              // 右辺で上へ戻る
        }

        path.closeSubpath()
        return path
    }
}
