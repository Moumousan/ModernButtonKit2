//
//  MBGToggleGroup.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/24.
//

import SwiftUI

/// 複数のトグルを一括で管理する汎用コンポーネント。
/// Swap / Colour / Visible などの切替を1列で表示可能。
@available(macOS 10.15, iOS 13.0, *)
public struct MBGToggleGroup<Mode: CaseIterable & Identifiable & RawRepresentable>: View where Mode.RawValue == String {
    
    // MARK: - Parameters
    public let modes: [Mode]
    @Binding public var selected: Mode
    public let themeColor: Color
    public let colorOff: Color
    public let size: CGFloat
    public let spacing: CGFloat
    public let cornerRadius: CGFloat
    public let animation: Animation
    public let onTap: ((Mode) -> Void)?
    
    // MARK: - Init
    public init(
        modes: [Mode],
        selected: Binding<Mode>,
        themeColor: Color = .accentColor,
        colorOff: Color = .gray.opacity(0.4),
        size: CGFloat = 20,
        spacing: CGFloat = 160,
        cornerRadius: CGFloat = 0,
        animation: Animation = .easeInOut(duration: 0.25),
        onTap: ((Mode) -> Void)? = nil
    ) {
        self.modes = modes
        self._selected = selected
        self.themeColor = themeColor
        self.colorOff = colorOff
        self.size = size
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.animation = animation
        self.onTap = onTap
    }
    
    // MARK: - Body
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(modes, id: \.id) { mode in
                let isSelected = (mode == selected)
                
                Image(systemName: mode.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundColor(isSelected ? themeColor : colorOff)
                    .padding(6)
                    .background(
                        Circle()
                            .fill(isSelected ? themeColor.opacity(0.12) : .clear)
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(animation) {
                            selected = mode
                            onTap?(mode)
                        }
                    }
                    .accessibilityLabel(Text(mode.rawValue))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
