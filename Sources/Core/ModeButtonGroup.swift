//  ModeButtonGroup.swift
//  ModernButtonKit2
//
//  Created by SNI on 2025/08/06.
//
//  Rereace.
//  reNewal on 2025/08/16.
//  Version 1.6 2025/11/06
//   - Segmentary: fit outer frame to content width/height
//   - Add labelColors (selected/unselected) for text foreground color
//   - Add chromeStyle enum (.none / .flat / .systemLike)
//   - Add cornerStyle enum (.fixed / .capsule) to auto radius = height/2
//

import SwiftUI
import Foundation

#if canImport(UIKit)
import UIKit
#endif
#if os(iOS)
import UIKit
public typealias PlatformFont = UIFont
#elseif os(macOS)
import AppKit
public typealias PlatformFont = NSFont
#endif


public enum MBGDefaults {
    @MainActor public static let font: PlatformFont = .systemFont(ofSize: 16)
    public static let spacing: CGFloat = 8
    public static let horizontalGap: CGFloat = 8
    public static let rightBarSpacing: CGFloat = 8
    public static let bottomBarSpacing: CGFloat = 8
    public static let revisionValue: CGFloat = 24
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public typealias ButtonBuilder<Mode> = (Mode, Bool, CGFloat, CGFloat, String) -> AnyView

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public typealias MBG = ModeButtonGroup
@available(macOS 10.15, *)
@available(iOS 13.0, *)
public typealias MBGColor = SwiftUI.Color

public enum ModeButtonLayout {
    case horizontal
    case vertical
    case multiRow(columns: Int, horizontalGap : CGFloat)
    case scrollableHorizontal(bottomBarSpacing: CGFloat)
    case scrollableVertical(rightBarSpacing: CGFloat)
    /// iOS の UISegmentedControl 風のレイアウト。
    ///
    /// - Parameters:
    ///   - separatorColor: セグメント間の区切り線カラー
    ///   - glow: セグメント全体の周囲に与えるハロー（光芒）エフェクト
    case segmentary(
        separatorColor: Color,
        glow: MBGSegmentGlow? = nil
    )
    case split(splitGap: CGFloat)
}

public enum SizeMode {
    case auto
    case fixed(CGFloat, CGFloat)
    case flexibleWidth(CGFloat)
    case flexibleHeight(CGFloat)
}

// NEW: Chrome style for visual chrome (outer background/border/look)
public enum ChromeStyle {
    case none       // no outer chrome/background/border
    case flat       // current flat style (default)
    case systemLike // material + subtle highlight/shadow
}

// NEW: Corner style (fixed radius or capsule = height/2)
public enum CornerStyle {
    case fixed(CGFloat)
    case capsule
}

// MARK: - Icon support

/// ボタンラベルに SF Symbols アイコンを添えるための配置指定。
public enum MBGIconPlacement {
    /// アイコンを使用しない（従来どおりテキストのみ）
    case none
    /// テキストの左側にアイコンを表示
    case leading
    /// テキストの右側にアイコンを表示
    case trailing
    /// アイコンのみを表示（テキストは非表示）
    case iconOnly
}


#if os(macOS)
// Provide a UIKit-like UIRectCorner for macOS
fileprivate struct UIRectCorner: OptionSet {
    let rawValue: Int
    static let topLeft     = UIRectCorner(rawValue: 1 << 0)
    static let topRight    = UIRectCorner(rawValue: 1 << 1)
    static let bottomLeft  = UIRectCorner(rawValue: 1 << 2)
    static let bottomRight = UIRectCorner(rawValue: 1 << 3)
    static let allCorners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}
#endif

@inline(__always)
private func segmentCornerSet(isFirst: Bool, isLast: Bool) -> UIRectCorner {
    switch (isFirst, isLast) {
    case (true, false):  return [.topLeft, .bottomLeft]
    case (false, true):  return [.topRight, .bottomRight]
    case (true, true):   return [.allCorners]
    default:             return []
    }
}

fileprivate struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        #if os(iOS)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
        #else
        // Build a path rounding only selected corners (NSBezierPath lacks corner-specific API)
        let r = min(radius, min(rect.width, rect.height) / 2)
        let minX = rect.minX, maxX = rect.maxX
        let minY = rect.minY, maxY = rect.maxY

        let path = CGMutablePath()
        // Start at left-bottom edge
        path.move(to: CGPoint(x: minX + (corners.contains(.bottomLeft) ? r : 0), y: minY))

        // bottom edge to bottom-right corner
        path.addLine(to: CGPoint(x: maxX - (corners.contains(.bottomRight) ? r : 0), y: minY))
        if corners.contains(.bottomRight) {
            path.addRelativeArc(center: CGPoint(x: maxX - r, y: minY + r), radius: r, startAngle: .pi * 1.5, delta: .pi/2)
        }

        // right edge to top-right corner
        path.addLine(to: CGPoint(x: maxX, y: maxY - (corners.contains(.topRight) ? r : 0)))
        if corners.contains(.topRight) {
            path.addRelativeArc(center: CGPoint(x: maxX - r, y: maxY - r), radius: r, startAngle: 0, delta: .pi/2)
        }

        // top edge to top-left corner
        path.addLine(to: CGPoint(x: minX + (corners.contains(.topLeft) ? r : 0), y: maxY))
        if corners.contains(.topLeft) {
            path.addRelativeArc(center: CGPoint(x: minX + r, y: maxY - r), radius: r, startAngle: .pi/2, delta: .pi/2)
        }

        // left edge to bottom-left corner
        path.addLine(to: CGPoint(x: minX, y: minY + (corners.contains(.bottomLeft) ? r : 0)))
        if corners.contains(.bottomLeft) {
            path.addRelativeArc(center: CGPoint(x: minX + r, y: minY + r), radius: r, startAngle: .pi, delta: .pi/2)
        }

        path.closeSubpath()
        return Path(path)
        #endif
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct ModeButtonGroup<Mode: Hashable & SelectableModeProtocol>: View {
    let modes: [Mode]
    @Binding var selected: Mode
    let themeColor: Color
    // keep for backward compatibility; used when cornerStyle == .fixed
    let cornerRadius: CGFloat
    let font: PlatformFont
    let iconPlacement: MBGIconPlacement
    let spacing: CGFloat
    let layout: ModeButtonLayout
    let sizeMode: SizeMode
    private let truncationLimit: Int?
    private let showsEllipsis: Bool   // ← 新しい名前＆Bool

    public var backgroundColors: (normal: Color, unselected: Color)? = nil
    public var labelColors: (selected: Color, unselected: Color)? = nil
    public var chromeStyle: ChromeStyle = .flat
    // NEW: corner style
    public var cornerStyle: CornerStyle = .fixed(12)

    public var label: ButtonBuilder<Mode>? = nil

    private let buttonBuilder: ButtonBuilder<Mode>
    private let buttonWidth: CGFloat
    private let buttonHeight: CGFloat

    private let middleContent: AnyView?

    // MARK: - Inits
    public init(
        modes: [Mode],
        selected: Binding<Mode>,
        themeColor: Color = .blue,
        cornerRadius: CGFloat = 12,
        font: PlatformFont = MBGDefaults.font,
        /// アイコンの配置指定（.none なら従来どおりテキストのみ）
        iconPlacement: MBGIconPlacement = .none,
        spacing: CGFloat = MBGDefaults.spacing,
        layout: ModeButtonLayout = .horizontal,
        sizeMode: SizeMode = .auto,
        truncationLimit: Int? = nil,
        showsEllipsis: Bool = true,
        backgroundColors: (normal: Color, unselected: Color)? = nil,
        labelColors: (selected: Color, unselected: Color)? = nil,
        chromeStyle: ChromeStyle = .flat,
        cornerStyle: CornerStyle = .fixed(12),
        buttonBuilder: ButtonBuilder<Mode>? = nil
    ) {
        self.modes = modes
        self._selected = selected
        self.themeColor = themeColor
        self.cornerRadius = cornerRadius
        self.font = font
        self.iconPlacement = iconPlacement
        self.spacing = spacing
        self.layout = layout
        self.sizeMode = sizeMode
        self.truncationLimit = truncationLimit
        self.showsEllipsis = showsEllipsis
        self.backgroundColors = backgroundColors
        self.labelColors = labelColors
        self.chromeStyle = chromeStyle
        self.cornerStyle = cornerStyle
        self.middleContent = nil

        let (w, h) = Self.resolveSize(modes: modes, font: font, sizeMode: sizeMode)
        self.buttonWidth = w
        self.buttonHeight = h

        if let customBuilder = buttonBuilder {
            self.buttonBuilder = customBuilder
        } else {
            self.buttonBuilder = Self.defaultButton(
                themeColor: themeColor,
                cornerRadius: Self.effectiveCornerRadius(base: cornerRadius, style: cornerStyle, height: h),
                font: font,
                backgroundColors: self.backgroundColors ?? (normal: .gray.opacity(0.2), unselected: .gray.opacity(0.2)),
                labelColors: self.labelColors,
                chromeStyle: self.chromeStyle,
                iconPlacement: iconPlacement
            )
        }
    }

    public init<Middle: View>(
        modes: [Mode],
        selected: Binding<Mode>,
        themeColor: Color = .blue,
        cornerRadius: CGFloat = 12,
        font: PlatformFont = MBGDefaults.font,
        /// アイコンの配置指定（.none なら従来どおりテキストのみ）
        iconPlacement: MBGIconPlacement = .none,
        spacing: CGFloat = MBGDefaults.spacing,
        layout: ModeButtonLayout = .horizontal,
        sizeMode: SizeMode = .auto,
        truncationLimit: Int? = nil,
        showsEllipsis: Bool = true,
        backgroundColors: (normal: Color, unselected: Color)? = nil,
        labelColors: (selected: Color, unselected: Color)? = nil,
        chromeStyle: ChromeStyle = .flat,
        cornerStyle: CornerStyle = .fixed(12),
        buttonBuilder: ButtonBuilder<Mode>? = nil,
        @ViewBuilder middleContent: () -> Middle
    ) {
        self.modes = modes
        self._selected = selected
        self.themeColor = themeColor
        self.cornerRadius = cornerRadius
        self.font = font
        self.iconPlacement = iconPlacement
        self.spacing = spacing
        self.layout = layout
        self.sizeMode = sizeMode
        self.truncationLimit = truncationLimit
        self.showsEllipsis = showsEllipsis
        self.backgroundColors = backgroundColors
        self.labelColors = labelColors
        self.chromeStyle = chromeStyle
        self.cornerStyle = cornerStyle
        self.middleContent = AnyView(middleContent())

        let (w, h) = Self.resolveSize(modes: modes, font: font, sizeMode: sizeMode)
        self.buttonWidth = w
        self.buttonHeight = h

        if let customBuilder = buttonBuilder {
            self.buttonBuilder = customBuilder
        } else {
            self.buttonBuilder = Self.defaultButton(
                themeColor: themeColor,
                cornerRadius: Self.effectiveCornerRadius(base: cornerRadius, style: cornerStyle, height: h),
                font: font,
                backgroundColors: self.backgroundColors ?? (normal: .gray.opacity(0.2), unselected: .gray.opacity(0.2)),
                labelColors: self.labelColors,
                chromeStyle: self.chromeStyle,
                iconPlacement: iconPlacement
            )
        }
    }

    public var body: some View {
        layoutView()
            .accessibilityElement(children: .contain)
    }

    // compute effective radius from style + height
    private static func effectiveCornerRadius(base: CGFloat, style: CornerStyle, height: CGFloat) -> CGFloat {
        switch style {
        case .fixed(let r): return r
        case .capsule: return height / 2
        }
    }

    @ViewBuilder
    private func layoutView() -> some View {
        switch layout {
        case .horizontal:
            HStack(spacing: spacing) { buttons() }

        case .vertical:
            VStack(spacing: spacing) { buttons() }

        case .multiRow(let columns, let horizontalGap):
            let rows = Int(ceil(Double(modes.count) / Double(columns)))
            let totalWidth = buttonWidth * CGFloat(columns)
                + horizontalGap * CGFloat(max(columns - 1, 0))
            let totalHeight = buttonHeight * CGFloat(rows)
                + spacing * CGFloat(max(rows - 1, 0))

            if #available(iOS 14.0, macOS 11.0, *) {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(minimum: buttonWidth), spacing: horizontalGap), count: columns),
                    spacing: spacing
                ) { buttons() }
                .frame(width: totalWidth, height: totalHeight)
            } else {
                VStack(spacing: spacing) { buttons() }
                    .frame(width: totalWidth, height: totalHeight)
            }

        case .scrollableHorizontal(let bottomBarSpacing):
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: spacing) {
                    if #available(iOS 14.0, macOS 11.0, *) {
                        LazyHGrid(rows: [GridItem(.flexible())], spacing: spacing) { buttons() }
                    } else {
                        HStack(spacing: spacing) { buttons() }
                    }
                }
                .frame(height: buttonHeight + bottomBarSpacing * 2)
            }

        case .scrollableVertical(let rightBarSpacing):
            ScrollView(.vertical, showsIndicators: true) {
                HStack(spacing: spacing) {
                    if #available(iOS 14.0, macOS 11.0, *) {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: spacing) { buttons() }
                    } else {
                        VStack(spacing: spacing) { buttons() }
                    }
                }
                .frame(width: buttonWidth + rightBarSpacing * 2)
            }

        case .segmentary(let separatorColor, let glow):
            segmentaryLayout(separatorColor: separatorColor, glow: glow)

        case .split(let splitGap):
            let count = modes.count
            let splitIndex = max(0, min(count, count / 2))

            let gap = max(splitGap, 0)

            HStack(spacing: 0) {
                buttons(for: modes.prefix(splitIndex))

                if let middleContent {
                    Spacer().frame(width: gap / 2)
                    middleContent.fixedSize()
                    Spacer().frame(width: gap / 2)
                } else {
                    Spacer().frame(width: gap)
                }

                buttons(for: modes.suffix(count - splitIndex))
            }
        }
    }

    /// Segment-style layout implementation extracted to avoid `@ViewBuilder` local declaration issues。
    private func segmentaryLayout(separatorColor: Color, glow: MBGSegmentGlow?) -> some View {
        let separatorWidth: CGFloat = 1
        let totalWidth = buttonWidth * CGFloat(modes.count)
            + separatorWidth * CGFloat(max(modes.count - 1, 0))

        let effRadius = Self.effectiveCornerRadius(
            base: cornerRadius,
            style: cornerStyle,
            height: buttonHeight
        )

        // ループで使い回すためにあらかじめ配列化
        let enumerated = Array(modes.enumerated())

        // 各モードごとの表示テキストを先に計算しておく
        let titles: [String] = enumerated.map { pair in
            let raw = pair.element.displayName
            if let limit = truncationLimit {
                return truncatedText(raw, limit: limit, showsEllipsis: showsEllipsis)
            } else {
                return raw
            }
        }

        // MARK: - 1. 背景・枠レイヤー（Glow 対象）

        let backgroundCore = AnyView(
            HStack(spacing: 0) {
                ForEach(enumerated, id: \.offset) { pair in
                    let index = pair.offset
                    let mode = pair.element
                    let isSelected = (mode == selected)

                    let isFirst = index == 0
                    let isLast = index == modes.count - 1

                    let segShape = RoundedCornerShape(
                        radius: effRadius,
                        corners: segmentCornerSet(isFirst: isFirst, isLast: isLast)
                    )

                    ZStack {
                        segShape
                            .fill(themeFill(isSelected: isSelected))
                            .overlay(
                                segShape.stroke(
                                    themeColor,
                                    lineWidth: isSelected ? 2 : 0.6
                                )
                            )
                    }
                    .frame(width: buttonWidth, height: buttonHeight)
                    .zIndex(isSelected ? 1 : 0)

                    // セパレータ（こちらは背景側で描画）
                    if !isLast {
                        Rectangle()
                            .fill(separatorColor)
                            .frame(width: separatorWidth)
                            .frame(height: buttonHeight)
                            .padding(.vertical, 4)
                    }
                }
            }
        )

        // MARK: - 2. ラベルレイヤー（Glow から守る）

        let labelCore = AnyView(
            HStack(spacing: 0) {
                ForEach(enumerated, id: \.offset) { pair in
                    let index = pair.offset
                    let mode = pair.element
                    let isSelected = (mode == selected)
                    let display = titles[index]

                    // MBGIconMode に準拠していれば SF Symbols 名を拾う
                    let iconName = (mode as? MBGIconMode)?.systemImageName

                    let fgColor = isSelected
                        ? (labelColors?.selected ?? Color.primary)
                        : (labelColors?.unselected ?? Color.primary)

                    let isLast = index == modes.count - 1

                    ZStack {
                        Self.buildLabel(
                            title: display,
                            iconName: iconName,
                            iconPlacement: iconPlacement,
                            font: font
                        )
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .foregroundColor(fgColor)
                        .contentShape(Rectangle())
                    }
                    .zIndex(isSelected ? 1 : 0)
                    .accessibilityLabel(Text(display))
                    .onTapGesture { selected = mode }

                    // 背景と横位置を合わせるための“透明セパレータ”
                    if !isLast {
                        Color.clear
                            .frame(width: separatorWidth)
                            .frame(height: buttonHeight)
                            .padding(.vertical, 4)
                    }
                }
            }
        )

        // MARK: - 3. Glow は背景だけに掛け、その上にラベルを重ねる

        let glowingBackground = applySegmentGroupGlowIfNeeded(
            backgroundCore,
            glow: glow,
            cornerRadius: effRadius
        )
        .allowsHitTesting(false)   // タップはラベル側で取る

        return ZStack {
            glowingBackground
            labelCore
        }
        .frame(width: totalWidth, height: buttonHeight)
        .background(outerBackground(cornerRadius: effRadius))
        .overlay(outerOverlay(cornerRadius: effRadius))
        .compositingGroup()   // 角の欠け防止用（従来どおり）
    }

    // MARK: - Helpers for chrome style
    @ViewBuilder
    private func outerBackground(cornerRadius: CGFloat? = nil) -> some View {
        let r = cornerRadius ?? self.cornerRadius
        switch chromeStyle {
        case .none:
            Color.clear
        case .flat:
            RoundedRectangle(cornerRadius: r)
                .fill(Color.gray.opacity(0.1))
        case .systemLike:
            if #available(iOS 15.0, macOS 12.0, *) {
                RoundedRectangle(cornerRadius: r)
                    .fill(.ultraThinMaterial)
            } else {
                RoundedRectangle(cornerRadius: r)
                    .fill(Color.white.opacity(0.06))
            }
        }
    }

    @ViewBuilder
    private func outerOverlay(cornerRadius: CGFloat? = nil) -> some View {
        let r = cornerRadius ?? self.cornerRadius
        switch chromeStyle {
        case .none:
            EmptyView()
        case .flat:
            RoundedRectangle(cornerRadius: r)
                .stroke(themeColor.opacity(0.3), lineWidth: 0.6)
        case .systemLike:
            ZStack {
                RoundedRectangle(cornerRadius: r)
                    .stroke(themeColor.opacity(0.35), lineWidth: 0.6)
                LinearGradient(
                    colors: [Color.white.opacity(0.18), Color.white.opacity(0.02)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: r))
                .allowsHitTesting(false)
            }
        }
    }

    private func themeFill(isSelected: Bool) -> Color {
        switch chromeStyle {
        case .none, .flat:
            return isSelected ? themeColor.opacity(0.25) : .clear
        case .systemLike:
            return isSelected ? themeColor.opacity(0.30) : Color.white.opacity(0.04)
        }
    }

    // MARK: - Label builder (text + optional icon)

    /// モードに MBGIconMode が実装されている場合、そのアイコンとテキストを組み合わせたラベルを生成する。
    @ViewBuilder
    private static func buildLabel(
        title: String,
        iconName: String?,
        iconPlacement: MBGIconPlacement,
        font: PlatformFont
    ) -> some View {
        let text = Text(title)
        switch iconPlacement {
        case .none:
            text.font(Font(font))

        case .iconOnly:
            if let iconName {
                Image(systemName: iconName)
                    .font(Font(font))
            } else {
                text.font(Font(font))
            }

        case .leading:
            if let iconName {
                HStack(spacing: 4) {
                    Image(systemName: iconName)
                    text
                }
                .font(Font(font))
            } else {
                text.font(Font(font))
            }

        case .trailing:
            if let iconName {
                HStack(spacing: 4) {
                    text
                    Image(systemName: iconName)
                }
                .font(Font(font))
            } else {
                text.font(Font(font))
            }
        }
    }

    // MARK: - Segment glow helpers

    /// セグメントグループ全体に対して、必要であれば glow（ハロー）を適用する。
    @ViewBuilder
    private func applySegmentGroupGlowIfNeeded<Content: View>(
        _ content: Content,
        glow: MBGSegmentGlow?,
        cornerRadius: CGFloat
    ) -> some View {
        switch glow {
        case .some(.halo(let color, let strength, let spread, let tuning)):
            haloGroup(
                content: content,
                color: color,
                cornerRadius: cornerRadius,
                strength: strength,
                spread: spread,
                tuning: tuning
            )

        case .some(.none), nil:
            content
        }
    }

    /// ハロー型 glow の実装。外周に沿ってぼかし + シャドウを重ねる。
   
    @ViewBuilder
    private func haloGroup<Content: View>(
        content: Content,
        color: Color,
        cornerRadius: CGFloat,
        strength: MBGSegmentGlow.Strength,
        spread: MBGSegmentGlow.Spread,
        tuning: MBGGlowTuning
    ) -> some View {

        // 1. 強度ごとの fill / stroke を取り出す
        let (fillOpacity, strokeOpacity): (Double, Double) = {
            switch strength {
            case .subtle:
                return (tuning.fillSubtle, tuning.strokeSubtle)
            case .normal:
                return (tuning.fillNormal, tuning.strokeNormal)
            case .strong:
                return (tuning.fillStrong, tuning.strokeStrong)
            }
        }()

        // 2. ぼかし半径
        let baseBlur = cornerRadius * tuning.baseBlurScale

        let spreadFactor: CGFloat = {
            switch spread {
            case .tight:   return tuning.spreadTight
            case .medium:  return tuning.spreadMedium
            case .wide:    return tuning.spreadWide
            }
        }()

        let blurRadius = baseBlur * spreadFactor

        ZStack {
            // 内側の「ふわっと光る塗り」
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(color.opacity(fillOpacity))
                // 内側からにじむ光
                .shadow(color: color.opacity(fillOpacity * 0.7),
                        radius: blurRadius)
                .shadow(color: color.opacity(fillOpacity * 0.4),
                        radius: blurRadius * 1.4)

            // 外枠の輪郭線
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(color.opacity(strokeOpacity), lineWidth: 1.5)
        }
    }
    
    // MARK: - Button Builder
    @ViewBuilder
    private func buttons() -> some View { buttons(for: modes[...]) }

    @ViewBuilder
    private func buttons(for slice: ArraySlice<Mode>) -> some View {
        let effRadius = Self.effectiveCornerRadius(base: cornerRadius, style: cornerStyle, height: buttonHeight)
        ForEach(Array(slice), id: \.self) { mode in
            let raw = mode.displayName
            let display = truncationLimit.map { limit in
                truncatedText(raw, limit: limit, showsEllipsis: showsEllipsis)
            } ?? raw

            if #available(iOS 17.0, macOS 11.0, *) {
                buttonBuilder(mode, selected == mode, buttonWidth, buttonHeight, display)
                    .buttonStyle(.plain)
                    .focusable(false)
                    .clipShape(RoundedRectangle(cornerRadius: effRadius)) // ensure same corner on default buttons
                    .zIndex(selected == mode ? 1 : 0)
                    .accessibilityLabel(Text(display))
                    .onTapGesture { selected = mode }
            } else {
                let base = buttonBuilder(mode, selected == mode, buttonWidth, buttonHeight, display)
                    .buttonStyle(.plain)
                    .clipShape(RoundedRectangle(cornerRadius: effRadius))
                    .onTapGesture { selected = mode }

                base.accessibilityLabel(Text(display))
            }
        }
    }

    // MARK: - Size Calculation
    private static func resolveSize(
        modes: [Mode], font: PlatformFont, sizeMode: SizeMode
    ) -> (CGFloat, CGFloat) {
        let autoWidth = calculateMaxWidth(modes: modes, font: font)
        let autoHeight = calculateButtonHeight(font: font)

        switch sizeMode {
        case .auto: return (autoWidth, autoHeight)
        case .fixed(let w, let h): return (w, h)
        case .flexibleWidth(let w): return (w, autoHeight)
        case .flexibleHeight(let h): return (autoWidth, h)
        }
    }

    // MARK: - Default Button Builder
    private static func defaultButton(
        themeColor: Color,
        cornerRadius: CGFloat,
        font: PlatformFont,
        backgroundColors: (normal: Color, unselected: Color)?,
        labelColors: (selected: Color, unselected: Color)?,
        chromeStyle: ChromeStyle,
        iconPlacement: MBGIconPlacement
    ) -> ButtonBuilder<Mode> {
        return { mode, isSelected, width, height, label in
            let baseNormal = backgroundColors?.normal ?? Color.gray.opacity(0.2)
            let bgFlat = isSelected ? themeColor : baseNormal
            let bgSystem = isSelected ? themeColor.opacity(0.95) : Color.white.opacity(0.08)
            let bgColor: Color = {
                switch chromeStyle {
                case .none, .flat: return bgFlat
                case .systemLike: return bgSystem
                }
            }()

            let fgColor = isSelected
                ? (labelColors?.selected ?? Color.primary)
                : (labelColors?.unselected ?? Color.primary)

            // モードが MBGIconMode を実装していれば、そのアイコン名を拾う
            let iconName = (mode as? MBGIconMode)?.systemImageName

            let base = AnyView(
                Self.buildLabel(
                    title: label,
                    iconName: iconName,
                    iconPlacement: iconPlacement,
                    font: font
                )
                .frame(width: width, height: height)
                .background(bgColor)
                .foregroundColor(fgColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(themeColor, lineWidth: isSelected ? 2 : 1)
                )
            )

            if chromeStyle == .systemLike {
                return AnyView(
                    base
                        .shadow(
                            color: Color.black.opacity(0.25),
                            radius: isSelected ? 2 : 1,
                            x: 0,
                            y: isSelected ? 1 : 0
                        )
                )
            } else {
                return base
            }
        }
    }

    public static func calculateMaxWidth(modes: [Mode], font: PlatformFont) -> CGFloat {
        let widths = modes.map { mode in
            let label = mode.displayName as NSString
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            return label.size(withAttributes: attributes).width
        }
        return (widths.max() ?? 44) + MBGDefaults.revisionValue
    }

    public static func calculateButtonHeight(font: PlatformFont) -> CGFloat {
#if os(iOS)
        return font.lineHeight + 16
#elseif os(macOS)
        return (font.ascender - font.descender) + 16
#endif
    }

    func truncatedText(_ text: String, limit: Int, showsEllipsis: Bool) -> String {
        guard limit > 0 else { return text }
        guard text.count > limit else { return text }
        let head = String(text.prefix(limit))
        return showsEllipsis ? head + "…" : head   // ← Bool で分岐
        }
    }


// End of ModeButtonGroup version 1.6

