//
//  MBGPanel.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/09.
//

import SwiftUI

// Cross-platform background color used for labels sitting on top of panels
private extension Color {
    static var platformBackground: Color {
        #if os(iOS) || os(tvOS) || os(visionOS)
        if #available(iOS 15.0, tvOS 15.0, visionOS 1.0, *) {
            return Color(uiColor: .systemBackground)
        } else {
            return Color.white
        }
        #elseif os(macOS)
        if #available(macOS 12.0, *) {
            return Color(nsColor: .windowBackgroundColor)
        } else {
            return Color(NSColor.windowBackgroundColor)
        }
        #else
        return Color.white
        #endif
    }
}

// Compatibility shim: provide default color and lineWidth for PanelBorderStyle
private extension PanelBorderStyle {
    var color: Color {
        // Provide a sensible default border color
        if #available(iOS 15.0, macOS 12.0, *) {
            return Color.secondary
        } else {
            return Color.gray
        }
    }
    var lineWidth: CGFloat {
        // Provide a sensible default border width
        1.0
    }
}

// Helper to conditionally apply fixedSize without changing the return type
private struct ConditionalFixedSize: ViewModifier {
    let apply: Bool
    func body(content: Content) -> some View {
        if apply {
            content.fixedSize(horizontal: false, vertical: false)
        } else {
            content
        }
    }
}

/// パネルの角の丸みを示すシグネチャ（外丸 / 内丸）
public enum PanelCornerKind :  Sendable{
    case convex(CGFloat)   // 外側に向かって丸める（標準）
    case concave(CGFloat)  // 内側に抉る（将来の concave 実装用）
}

private extension PanelCornerKind {
    /// 実際の cornerRadius 値（絶対値）
    var radius: CGFloat {
        switch self {
        case .convex(let r), .concave(let r):
            return r
        }
    }

    /// 符号付きの cornerRadius（+ = convex, - = concave）
    var signedRadius: CGFloat {
        switch self {
        case .convex(let r):
            return r
        case .concave(let r):
            return -r
        }
    }
}

/// パネルのベースシェイプ（四隅を convex / concave で描き分ける）
///
/// - convex: 通常の角丸矩形（RoundedRectangle 相当）
/// - concave: 四隅を内側に抉った矩形（最小実装版）
struct PanelBaseShape: InsettableShape {

    var cornerKind: PanelCornerKind
    var cornerRadius: CGFloat
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
        let baseR = min(cornerRadius, maxR)

        switch cornerKind {
        case .convex:
            // 外向き角丸は RoundedRectangle に委譲
            path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: baseR, height: baseR)
            )
            return path

        case .concave:
            // 四隅を内側に抉った矩形。各辺の中央を通る直線を基準に、
            // 角で内向き1/4円弧を描いて戻ってくる。
            let r = baseR

            let minX = rect.minX
            let maxX = rect.maxX
            let minY = rect.minY
            let maxY = rect.maxY

            // エッジの基準線（角のr分だけ内側に寄せた位置）
            let leftX   = minX + r
            let rightX  = maxX - r
            let topY    = minY + r
            let bottomY = maxY - r

            // 上辺中央から時計回りに一周
            path.move(to: CGPoint(x: leftX, y: minY))
            path.addLine(to: CGPoint(x: rightX, y: minY))

            // 右上 内向き1/4円
            path.addArc(
                center: CGPoint(x: maxX - r, y: minY + r),
                radius: r,
                startAngle: .degrees(270),
                endAngle: .degrees(0),
                clockwise: true
            )

            // 右辺中央へ
            path.addLine(to: CGPoint(x: maxX, y: bottomY))

            // 右下 内向き1/4円
            path.addArc(
                center: CGPoint(x: maxX - r, y: maxY - r),
                radius: r,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: true
            )

            // 下辺中央へ
            path.addLine(to: CGPoint(x: leftX, y: maxY))

            // 左下 内向き1/4円
            path.addArc(
                center: CGPoint(x: minX + r, y: maxY - r),
                radius: r,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: true
            )

            // 左辺中央へ
            path.addLine(to: CGPoint(x: minX, y: topY))

            // 左上 内向き1/4円
            path.addArc(
                center: CGPoint(x: minX + r, y: minY + r),
                radius: r,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: true
            )

            path.closeSubpath()
            return path
        }
    }
}

public struct MBGPanel<Content: View>: View {

    /// タイトルの有無と切り欠き幅
    public enum Title {
        case none
        case text(String, gapWidth: CGFloat = 120)
    }

    /// サイズ指定
    public enum Size {
        case auto                  // コンテンツに合わせる
        case fixed(CGSize)         // 明示的に幅・高さを指定
    }

    let title: Title
    let borderStyle: PanelBorderStyle
    let size: Size
    let cornerKind: PanelCornerKind
    let content: () -> Content

    let outerCornerKind: PanelCornerKind
    let innerCornerKind: PanelCornerKind?

    @Binding var backgroundColor: Color

       // Binding 版
       public init(
           title: Title = .none,
           borderStyle: PanelBorderStyle,
           size: Size = .auto,
           backgroundColor: Binding<Color>,
           cornerKind: PanelCornerKind = .convex(16),
           outerCornerKind: PanelCornerKind? = nil,
           innerCornerKind: PanelCornerKind? = nil,
           @ViewBuilder content: @escaping () -> Content
       ) {
           self.title = title
           self.borderStyle = borderStyle
           self.size = size
           self._backgroundColor = backgroundColor
           self.cornerKind = cornerKind
           self.outerCornerKind = outerCornerKind ?? cornerKind
           self.innerCornerKind = innerCornerKind
           self.content = content
       }

       // Color 直指定版（従来互換）
       public init(
           title: Title = .none,
           borderStyle: PanelBorderStyle,
           size: Size = .auto,
           backgroundColor: Color = .gray,
           cornerKind: PanelCornerKind = .convex(16),
           outerCornerKind: PanelCornerKind? = nil,
           innerCornerKind: PanelCornerKind? = nil,
           @ViewBuilder content: @escaping () -> Content
       ) {
           self.init(
               title: title,
               borderStyle: borderStyle,
               size: size,
               backgroundColor: .constant(backgroundColor),
               cornerKind: cornerKind,
               outerCornerKind: outerCornerKind,
               innerCornerKind: innerCornerKind,
               content: content
           )
       }

       public var body: some View {
           // ここがポイント：cornerKind を PanelBaseShape に渡す
           let outerShape = PanelBaseShape(
               cornerKind: outerCornerKind,
               cornerRadius: outerCornerKind.radius
           )
           let innerShape = PanelBaseShape(
               cornerKind: (innerCornerKind ?? outerCornerKind),
               cornerRadius: (innerCornerKind ?? outerCornerKind).radius
           )

           // ベースの塗り + 枠線（title 有無で上辺だけ処理を変える）
           let panelBackground: some View = Group {
               switch title {
               case .none:
                   outerShape
                       .fill(backgroundColor)
                       .overlay(borderOverlay(outerShape: outerShape, innerShape: innerShape, gapWidth: nil))

               case .text(_, let gapWidth):
                   outerShape
                       .fill(backgroundColor)
                       .overlay(borderOverlay(outerShape: outerShape, innerShape: innerShape, gapWidth: gapWidth))
               }
           }

           // タイトルラベル
           let titleView: some View = Group {
               if case let .text(label, _) = title {
                   Text(label)
                       .font(.system(size: 14, weight: .semibold))
                       .padding(.horizontal, 12)
                       .padding(.vertical, 4)
                       .background(Color.platformBackground)
                       .offset(y: -10)
               }
           }

           // コンテンツ本体
           let contentView: some View = VStack {
               Spacer(minLength: 16)
               content()
                   .padding(16)
               Spacer(minLength: 16)
           }

           let rawPanel = ZStack(alignment: .top) {
               panelBackground
               contentView
               titleView
           }

           // サイズ指定
           let targetSize: CGSize? = {
               if case let .fixed(s) = size { return s } else { return nil }
           }()

           rawPanel
               .frame(width: targetSize?.width, height: targetSize?.height)
               .modifier(
                   ConditionalFixedSize(apply: {
                       if case .auto = size { return true } else { return false }
                   }())
               )
       }

       // 単線/二重線の描画ロジック
       private func borderOverlay(
           outerShape: PanelBaseShape,
           innerShape: PanelBaseShape,
           gapWidth: CGFloat?
       ) -> some View {
           Group {
               switch (borderStyle.kind, gapWidth) {
               case (.single, nil):
                   outerShape
                       .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                       .padding(-borderStyle.outerWidth / 2)
               case (.double(let gap), nil):
                   outerShape
                       .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                       .padding(-borderStyle.outerWidth / 2)
                   innerShape
                       .stroke(borderStyle.innerColor, lineWidth: borderStyle.innerWidth)
                       .padding(gap + borderStyle.innerWidth / 2)
               case (.single, let gw?):
                   TitleGapPanelShape(cornerKind: outerCornerKind,
                                      cornerRadius: outerCornerKind.radius,
                                      gapWidth: gw)
                       .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                       .padding(-borderStyle.outerWidth / 2)
               case (.double(let gap), let gw?):
                   TitleGapPanelShape(cornerKind: outerCornerKind,
                                      cornerRadius: outerCornerKind.radius,
                                      gapWidth: gw)
                       .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                       .padding(-borderStyle.outerWidth / 2)
                   TitleGapPanelShape(cornerKind: (innerCornerKind ?? outerCornerKind),
                                      cornerRadius: (innerCornerKind ?? outerCornerKind).radius,
                                      gapWidth: gw)
                       .stroke(borderStyle.innerColor, lineWidth: borderStyle.innerWidth)
                       .padding(gap + borderStyle.innerWidth / 2)
               }
           }
       }
   }

private struct TitleGapPanelShape: InsettableShape {
    var cornerKind: PanelCornerKind
    var cornerRadius: CGFloat
    var gapWidth: CGFloat
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var c = self
        c.insetAmount += amount
        return c
    }

    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        var p = Path()
        guard rect.width > 0, rect.height > 0 else { return p }

        let w = rect.width
        let h = rect.height
        let maxR = min(w, h) / 2
        let r = min(cornerRadius, maxR)

        // Gap on the top edge centered
        let gap = min(gapWidth, max(0, w - 2*r))
        let midX = rect.midX
        let gapLeft = midX - gap/2
        let gapRight = midX + gap/2

        switch cornerKind {
        case .convex:
            // Same as rounded rect but with a gap on top edge
            // Left arc start
            p.move(to: CGPoint(x: rect.minX + r, y: rect.minY))
            // Top-left arc to top-left corner
            p.addArc(center: CGPoint(x: rect.minX + r, y: rect.minY + r),
                     radius: r,
                     startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
            // Left edge down
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - r))
            // Bottom-left arc
            p.addArc(center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
                     radius: r,
                     startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
            // Bottom edge
            p.addLine(to: CGPoint(x: rect.maxX - r, y: rect.maxY))
            // Bottom-right arc
            p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
                     radius: r,
                     startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
            // Right edge up
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + r))
            // Top-right arc
            p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
                     radius: r,
                     startAngle: .degrees(0), endAngle: .degrees(315), clockwise: true)
            // Top edge to gap right
            p.addLine(to: CGPoint(x: gapRight, y: rect.minY))
            // Move to gap left and continue to top-left start
            p.move(to: CGPoint(x: gapLeft, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX + r, y: rect.minY))
            p.closeSubpath()
            return p

        case .concave:
            // Concave corners with a gap on top edge
            let minX = rect.minX
            let maxX = rect.maxX
            let minY = rect.minY
            let maxY = rect.maxY

            let leftX   = minX + r
            let rightX  = maxX - r
            let topY    = minY + r
            let bottomY = maxY - r

            // Start at left of gap on the top edge
            p.move(to: CGPoint(x: leftX, y: minY))
            // Top edge to gap left
            p.addLine(to: CGPoint(x: gapLeft, y: minY))
            // Move to gap right and continue to rightX
            p.move(to: CGPoint(x: gapRight, y: minY))
            p.addLine(to: CGPoint(x: rightX, y: minY))

            // Top-right concave arc
            p.addArc(center: CGPoint(x: maxX - r, y: minY + r),
                     radius: r,
                     startAngle: .degrees(270), endAngle: .degrees(0), clockwise: true)
            // Right edge
            p.addLine(to: CGPoint(x: maxX, y: bottomY))
            // Bottom-right concave arc
            p.addArc(center: CGPoint(x: maxX - r, y: maxY - r),
                     radius: r,
                     startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
            // Bottom edge
            p.addLine(to: CGPoint(x: leftX, y: maxY))
            // Bottom-left concave arc
            p.addArc(center: CGPoint(x: minX + r, y: maxY - r),
                     radius: r,
                     startAngle: .degrees(90), endAngle: .degrees(180), clockwise: true)
            // Left edge
            p.addLine(to: CGPoint(x: minX, y: topY))
            // Top-left concave arc
            p.addArc(center: CGPoint(x: minX + r, y: minY + r),
                     radius: r,
                     startAngle: .degrees(180), endAngle: .degrees(270), clockwise: true)
            p.closeSubpath()
            return p
        }
    }
}
