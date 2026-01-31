//
//  MBGSwapToggle.swift
//  ModernButtonKit2
//
//  Created by SNI on 2025/10/25.
//


//
//  MBGSwapToggle.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/26.
//
//  🔄 Swap専用トグルボタン
//  ────────────────────────────────
//  ・上下矢印と “Swap” ラベルを組み合わせたデザイン
//  ・枠線なし、シグネチャのみで完結
//  ・MBGToggleと同様、onTapedクロージャで挙動を定義
//

import SwiftUI

@available(macOS 12.0, iOS 15.0, *)
public struct MBGSwapToggle: View {
    // MARK: - プロパティ
    @State private var isOn: Bool = false

    public let colorOn: Color
    public let colorOff: Color
    public let iconSize: CGFloat
    public let spacing: CGFloat
    public let label: String
    public var onTaped: ((Bool) -> Void)?

    // MARK: - イニシャライザ
    public init(
        colorOn: Color = .accentColor,
        colorOff: Color = .gray.opacity(0.5),
        iconSize: CGFloat = 20,
        spacing: CGFloat = 6,
        label: String = "Swap",
        onTaped: ((Bool) -> Void)? = nil
    ) {
        self.colorOn = colorOn
        self.colorOff = colorOff
        self.iconSize = iconSize
        self.spacing = spacing
        self.label = label
        self.onTaped = onTaped
    }

    // MARK: - ビュー本体
    public var body: some View {
        Button {
            isOn.toggle()
            onTaped?(isOn)
        } label: {
            HStack(spacing: spacing) {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(isOn ? colorOn : colorOff)
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isOn ? colorOn : colorOff)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.25), value: isOn)
    }
}