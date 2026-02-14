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
    let backgroundColor: Color
    let content: () -> Content

    public init(
        title: Title = .none,
        borderStyle: PanelBorderStyle, // = .standard,
        size: Size = .auto,
        backgroundColor: Color = .gray,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.borderStyle = borderStyle
        self.size = size
        self.backgroundColor = backgroundColor
        self.content = content
    }

    public var body: some View {
        let cornerRadius: CGFloat = 16   // とりあえず固定（必要なら引数に）

        // ベースとなるパネルビュー
        let panel = ZStack(alignment: .top) {
            Group {
                switch title {
                case .none:
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                case .text(_, let gapWidth):
                    TitleGapPanel(cornerRadius: cornerRadius, gapWidth: gapWidth)
                        .fill(backgroundColor)
                }
            }
            .overlay(
                ZStack {
                    switch title {
                    case .none:
                        // Fill already applied above. Draw borders according to style.
                        switch borderStyle.kind {
                        case .single:
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                                .padding(-borderStyle.outerWidth / 2)
                        case .double(let gap):
                            // Outer stroke (outside)
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                                .padding(-borderStyle.outerWidth / 2)
                            // Inner stroke (inside with gap)
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .stroke(borderStyle.innerColor, lineWidth: borderStyle.innerWidth)
                                .padding(gap + borderStyle.innerWidth / 2)
                        }
                    case .text(_, let gapWidth):
                        switch borderStyle.kind {
                        case .single:
                            TitleGapPanel(cornerRadius: cornerRadius, gapWidth: gapWidth)
                                .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                                .padding(-borderStyle.outerWidth / 2)
                        case .double(let gap):
                            TitleGapPanel(cornerRadius: cornerRadius, gapWidth: gapWidth)
                                .stroke(borderStyle.outerColor, lineWidth: borderStyle.outerWidth)
                                .padding(-borderStyle.outerWidth / 2)
                            TitleGapPanel(cornerRadius: cornerRadius, gapWidth: gapWidth)
                                .stroke(borderStyle.innerColor, lineWidth: borderStyle.innerWidth)
                                .padding(gap + borderStyle.innerWidth / 2)
                        }
                    }
                }
            )

            // タイトルラベル（切り欠きがあるときだけ）
            if case let .text(label, _) = title {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.platformBackground)
                    .offset(y: -10)
            }

            // コンテンツ本体
            VStack {
                Spacer(minLength: 16)
                content()
                    .padding(16)
                Spacer(minLength: 16)
            }
        }

        // サイズ指定（auto / fixed）を最後に一貫したモディファイアで適用
        let targetSize: CGSize? = {
            if case let .fixed(s) = size { return s } else { return nil }
        }()

        panel
            .frame(width: targetSize?.width, height: targetSize?.height)
            .modifier(
                ConditionalFixedSize(apply: {
                    if case .auto = size { return true } else { return false }
                }())
            )
    }
}

