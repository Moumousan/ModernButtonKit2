//
//  MBGPanel.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/09.
//
//  ChangeLog:
//  2026-02-23: Added TitleBackground API (color/material), fixed access for platformBackground, and corrected title background application to avoid ShapeStyle errors.
//  2026-02-23: Fix: Made Color.platformBackground accessible for default arguments; refactored title background application to avoid generic inference errors.
//  2026-02-23: Change: Apply option C - use .color(.clear) as default for titleBackground and replace with platformBackground inside init; moved helper into body.
//  2026-02-23: Feature: Added titleOffset (CGSize) to control title X/Y offset from callers.
//  2026-02-23: Feature: Introduced TitleDecoration to configure title background, corner radius, shadow, font, padding, stroke, and offset.
//  2026-02-23: Fix: Stabilized title view building to avoid generic inference errors across platforms by using a single builder chain and conditional modifiers.
//  2026-02-23: Fix: Resolved ViewBuilder return issues by avoiding local @ViewBuilder functions and using conditional modifiers inline.
//  2026-02-23: Fix: Split title label building into a dedicated subview to ease type-checking across platforms by using a single builder chain and conditional modifiers.
//  2026-02-23: Fix: Rewrote TitleLabelView to avoid reassigning view variables; now returns a composed view with conditional modifiers via helper extensions.
//  2026-02-23: Fix: Simplified title rendering by prebuilding Text and applying minimal stepwise modifiers to reduce type-checking complexity.
//  2026-02-23: Fix: Avoided reassigning views by composing title label in nested container (AnyView chain) to satisfy type system.
//  2026-02-24: Removal: Deleted standalone TitleGapPanelShape; gap rendering unified under MBGPanel via AlgorithmGapPanelShape to fix signature mismatch errors.

import SwiftUI

// Cross-platform background color used for labels sitting on top of panels
extension Color {
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

extension View {
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, condition: ((T) -> Bool)? = nil, transform: (Self, T) -> Content) -> some View {
        if let v = value, condition?(v) ?? true {
            transform(self, v)
        } else {
            self
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

public struct MBGPanel<PanelContent: View>: View {

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
    
    /// タイトル背景の指定（色 or マテリアル）
    public enum TitleBackground {
        case color(Color)
        case material(Material)
    }

    /// タイトルの装飾一式
    public struct TitleDecoration {
        public var background: TitleBackground
        public var cornerRadius: CGFloat
        public var shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)?
        public var font: Font
        public var fontWeight: Font.Weight?
        public var padding: EdgeInsets
        public var stroke: (color: Color, lineWidth: CGFloat)?
        public var offset: CGSize

        public init(background: TitleBackground,
                    cornerRadius: CGFloat = 0,
                    shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)? = nil,
                    font: Font = .system(size: 14, weight: .semibold),
                    fontWeight: Font.Weight? = nil,
                    padding: EdgeInsets = EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12),
                    stroke: (color: Color, lineWidth: CGFloat)? = nil,
                    offset: CGSize = .zero) {
            self.background = background
            self.cornerRadius = cornerRadius
            self.shadow = shadow
            self.font = font
            self.fontWeight = fontWeight
            self.padding = padding
            self.stroke = stroke
            self.offset = offset
        }
    }

    let title: Title
    let borderStyle: PanelBorderStyle
    let size: Size
    let cornerKind: PanelCornerKind
    let content: () -> PanelContent

    let outerCornerKind: PanelCornerKind
    let innerCornerKind: PanelCornerKind?
    let titleBackground: TitleBackground
    let titleOffset: CGSize
    let titleDecoration: TitleDecoration?

    @Binding var backgroundColor: Color
    @Environment(\.panelCornerAlgorithm) private var cornerAlg

       // Binding 版
       public init(
           title: Title = .none,
           borderStyle: PanelBorderStyle,
           size: Size = .auto,
           backgroundColor: Binding<Color>,
           titleBackground: TitleBackground = .color(.clear),
           titleOffset: CGSize = .zero,
           titleDecoration: TitleDecoration? = nil,
           cornerKind: PanelCornerKind = .convex(16),
           outerCornerKind: PanelCornerKind? = nil,
           innerCornerKind: PanelCornerKind? = nil,
           @ViewBuilder content: @escaping () -> PanelContent
       ) {
           self.title = title
           self.borderStyle = borderStyle
           self.size = size
           self._backgroundColor = backgroundColor
           switch titleBackground {
           case .color(let c) where c == .clear:
               self.titleBackground = .color(Color.platformBackground)
           default:
               self.titleBackground = titleBackground
           }
           self.titleOffset = titleOffset
           self.titleDecoration = titleDecoration
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
           titleBackground: TitleBackground = .color(.clear),
           titleOffset: CGSize = .zero,
           titleDecoration: TitleDecoration? = nil,
           cornerKind: PanelCornerKind = .convex(16),
           outerCornerKind: PanelCornerKind? = nil,
           innerCornerKind: PanelCornerKind? = nil,
           @ViewBuilder content: @escaping () -> PanelContent
       ) {
           self.init(
               title: title,
               borderStyle: borderStyle,
               size: size,
               backgroundColor: .constant(backgroundColor),
               titleBackground: titleBackground,
               titleOffset: titleOffset,
               titleDecoration: titleDecoration,
               cornerKind: cornerKind,
               outerCornerKind: outerCornerKind,
               innerCornerKind: innerCornerKind,
               content: content
           )
       }

    // Dedicated subview to simplify type-checking for the title label
    private struct TitleLabelView: View {
        let label: String
        let decoration: TitleDecoration?
        let legacyBackground: AnyShapeStyle
        let fallbackOffset: CGSize

        var body: some View {
            // Decide background style
            let bgStyle: AnyShapeStyle = {
                if let deco = decoration {
                    switch deco.background {
                    case .color(let c): return AnyShapeStyle(c)
                    case .material(let m): return AnyShapeStyle(m)
                    }
                }
                return legacyBackground
            }()

            // Prebuild base text
            let baseText: Text = {
                var t = Text(label)
                // font
                t = t.font(decoration?.font ?? .system(size: 14, weight: .semibold))
                // weight (only if provided)
                if let fw = decoration?.fontWeight {
                    t = t.fontWeight(fw)
                }
                return t
            }()

            // Compose inside a container to avoid reassigning view values
            return VStack(spacing: 0) {
                baseText
                    .padding(decoration?.padding ?? EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    .background(bgStyle)
                    .modifier(RoundedStrokeModifier(cornerRadius: decoration?.cornerRadius ?? 0, stroke: decoration?.stroke))
                    .modifier(ShadowModifier(shadow: decoration?.shadow))
            }
            .offset(decoration?.offset ?? fallbackOffset)
        }
    }

    private struct RoundedStrokeModifier: ViewModifier {
        let cornerRadius: CGFloat
        let stroke: (color: Color, lineWidth: CGFloat)?
        func body(content: Content) -> some View {
            var view = AnyView(content)
            if cornerRadius > 0 {
                view = AnyView(view.clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)))
                if let s = stroke {
                    view = AnyView(view.overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(s.color, lineWidth: s.lineWidth)))
                }
            } else if let s = stroke {
                view = AnyView(view.overlay(RoundedRectangle(cornerRadius: 0, style: .continuous).stroke(s.color, lineWidth: s.lineWidth)))
            }
            return view
        }
    }

    private struct ShadowModifier: ViewModifier {
        let shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)?
        func body(content: Content) -> some View {
            guard let sh = shadow else { return AnyView(content) }
            return AnyView(content.shadow(color: sh.color, radius: sh.radius, x: sh.x, y: sh.y))
        }
    }

       public var body: some View {
           // Helper to provide a ShapeStyle for title background
           let titleBackgroundBackgroundStyle: any ShapeStyle = {
               switch titleBackground {
               case .color(let c): return c
               case .material(let m): return m
               }
           }()

           // ここがポイント：cornerKind を PanelBaseShape に渡す
           let outerShape = AlgorithmPanelShape(
               algorithm: cornerAlg,
               cornerKind: outerCornerKind,
               cornerRadius: outerCornerKind.radius
           )
           let innerShape = AlgorithmPanelShape(
               algorithm: cornerAlg,
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
                   TitleLabelView(
                       label: label,
                       decoration: titleDecoration,
                       legacyBackground: AnyShapeStyle(titleBackgroundBackgroundStyle),
                       fallbackOffset: titleOffset
                   )
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
           outerShape: AlgorithmPanelShape,
           innerShape: AlgorithmPanelShape,
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
                   AlgorithmGapPanelShape(algorithm: cornerAlg,
                                          cornerKind: outerCornerKind,
                                          cornerRadius: outerCornerKind.radius,
                                          gapWidth: gw)
                       .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                       .padding(-borderStyle.outerWidth / 2)
               case (.double(let gap), let gw?):
                   AlgorithmGapPanelShape(algorithm: cornerAlg,
                                          cornerKind: outerCornerKind,
                                          cornerRadius: outerCornerKind.radius,
                                          gapWidth: gw)
                       .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                       .padding(-borderStyle.outerWidth / 2)
                   AlgorithmGapPanelShape(algorithm: cornerAlg,
                                          cornerKind: (innerCornerKind ?? outerCornerKind),
                                          cornerRadius: (innerCornerKind ?? outerCornerKind).radius,
                                          gapWidth: gw)
                       .stroke(borderStyle.innerColor, lineWidth: borderStyle.innerWidth)
                       .padding(gap + borderStyle.innerWidth / 2)
               }
           }
       }
   }
