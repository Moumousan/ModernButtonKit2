//
//  MBGActionBar.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/11/13.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public enum MBGActionBarStyle {
    case one     // Done
    case two     // Done + Cancel
    case three   // Done + Cancel + More
}

@available(iOS 13.0, macOS 10.15, *)
public enum MBGActionBarSizeMode {
    case fixed(width: CGFloat, height: CGFloat)
    case flexibleWidth(_ height: CGFloat)
}

@available(iOS 13.0, macOS 10.15, *)
public struct MBGActionBar: View {

    // MARK: - Config
    public let style: MBGActionBarStyle
    public let spacing: CGFloat
    public let cornerRadius: CGFloat
    public let font: Font
    public let sizeMode: MBGActionBarSizeMode

    // Titles / Icons / Colors（呼び出し側で自由に上書き可能）
    public let doneTitle: String
    public let doneIcon: String?
    public let doneColor: Color

    public let cancelTitle: String
    public let cancelIcon: String?
    public let cancelColor: Color

    public let extraTitle: String
    public let extraIcon: String?
    public let extraColor: Color

    // Actions
    public let onDone: (() -> Void)?
    public let onCancel: (() -> Void)?
    public let onExtra: (() -> Void)?

    // MARK: - Init
    public init(
        style: MBGActionBarStyle,
        spacing: CGFloat = 12,
        cornerRadius: CGFloat = 12,
        font: Font = .system(size: 18, weight: .semibold),
        sizeMode: MBGActionBarSizeMode = .fixed(width: 240, height: 44),
        doneTitle: String = "Done",
        doneIcon: String? = "checkmark.circle.fill",
        doneColor: Color = .blue,
        cancelTitle: String = "Cancel",
        cancelIcon: String? = "xmark.circle.fill",
        cancelColor: Color = .gray,
        extraTitle: String = "More",
        extraIcon: String? = "ellipsis.circle.fill",
        extraColor: Color = .orange,
        onDone: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        onExtra: (() -> Void)? = nil
    ) {
        self.style = style
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.font = font
        self.sizeMode = sizeMode
        self.doneTitle = doneTitle
        self.doneIcon = doneIcon
        self.doneColor = doneColor
        self.cancelTitle = cancelTitle
        self.cancelIcon = cancelIcon
        self.cancelColor = cancelColor
        self.extraTitle = extraTitle
        self.extraIcon = extraIcon
        self.extraColor = extraColor
        self.onDone = onDone
        self.onCancel = onCancel
        self.onExtra = onExtra
    }

    // MARK: - Body
    public var body: some View {
        HStack(spacing: spacing) {
            switch style {
            case .one:
                button(title: doneTitle, icon: doneIcon, bg: doneColor) { onDone?() }

            case .two:
                button(title: cancelTitle, icon: cancelIcon, bg: cancelColor) { onCancel?() }
                button(title: doneTitle, icon: doneIcon, bg: doneColor) { onDone?() }

            case .three:
                button(title: cancelTitle, icon: cancelIcon, bg: cancelColor) { onCancel?() }
                button(title: doneTitle, icon: doneIcon, bg: doneColor) { onDone?() }
                button(title: extraTitle, icon: extraIcon, bg: extraColor) { onExtra?() }
            }
        }
    }

    @ViewBuilder
    private func button(title: String, icon: String?, bg: Color, action: @escaping () -> Void) -> some View {
        let label = HStack(spacing: 8) {
            if let icon {
                Image(systemName: icon)
                    .imageScale(.medium)
            }
            Text(title)
        }
        .font(font)
        .foregroundColor(.white)

        switch sizeMode {
        case .fixed(let w, let h):
            Button(action: action) {
                label
                    .frame(width: w, height: h)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(bg) // 完全不透明
                    )
            }
            .buttonStyle(.plain)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))

        case .flexibleWidth(let h):
            Button(action: action) {
                label
                    .padding(.horizontal, 16)
                    .frame(height: h)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(bg)
                    )
            }
            .buttonStyle(.plain)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
