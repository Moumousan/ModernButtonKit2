//
//  MBGRadioGroup.swift
//  ModernButtonKit2
//
//  Created by SNI on 2025/10/25.
//


//
//  MBGRadioGroup.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/25.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct MBGRadioGroup<Mode: CaseIterable & Identifiable & Hashable>: View {
    public let modes: [Mode]
    @Binding public var selected: Mode
    @Binding public var freeComment: String

    public let themeColor: Color
    public let showFreeComment: Bool
    public let font: Font
    public let spacing: CGFloat

    public init(
        modes: [Mode],
        selected: Binding<Mode>,
        freeComment: Binding<String> = .constant(""),
        themeColor: Color = .accentColor,
        showFreeComment: Bool = true,
        font: Font = .system(size: 13),
        spacing: CGFloat = 10
    ) {
        self.modes = modes
        self._selected = selected
        self._freeComment = freeComment
        self.themeColor = themeColor
        self.showFreeComment = showFreeComment
        self.font = font
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(modes, id: \.id) { mode in
                HStack(spacing: 8) {
                    Circle()
                        .strokeBorder(themeColor, lineWidth: 1.5)
                        .background(Circle().fill(mode == selected ? themeColor : .clear))
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selected = mode
                            }
                        }

                    Text(verbatim: "\(mode.id)")
                        .font(font)
                }
            }

            if showFreeComment {
                TextField("その他の意見を入力...", text: $freeComment)
                    .textFieldStyle(.roundedBorder)
                    .font(font)
                    .padding(.top, 6)
            }
        }
    }
}