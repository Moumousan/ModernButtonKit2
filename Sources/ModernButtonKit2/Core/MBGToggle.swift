//
//  MBGLayout+ToggleSignature.swift
//  ModernButtonKit2FinalExtension
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/23.
//

import SwiftUI

// MARK: - 🟢 MBGToggle: 枠なしトグルボタン（Kit2Final拡張）

/// 枠を持たないトグル型ボタン。
/// MBG()のようにシグネチャだけで完結する構成。
///
/// ```swift
/// MBGToggle(
///     toggleOn: .eyeFill,
///     toggleOff: .eyeSlash,
///     colorOn: .yellow,
///     colorOff: .gray
/// )
/// .onTaped { isOn in
///     visibleSettings.isVisibleEnabled = isOn
/// }
/// ```
@available(macOS 10.15, *)
public struct MBGToggle: View {
    // MARK: - パラメータ
    public let toggleOn: String
    public let toggleOff: String
    public let colorOn: Color
    public let colorOff: Color
    public let size: CGFloat
    public let animation: Animation

    // MARK: - 状態管理
    @State private var isOn: Bool = false
    private var onTapAction: ((Bool) -> Void)? = nil

    // MARK: - 初期化
    @available(macOS 10.15, *)
    public init(
        toggleOn: String,
        toggleOff: String,
        colorOn: Color = .accentColor,
        colorOff: Color = .gray,
        size: CGFloat = 18,
        animation: Animation = .easeInOut(duration: 0.25)
    ) {
        self.toggleOn = toggleOn
        self.toggleOff = toggleOff
        self.colorOn = colorOn
        self.colorOff = colorOff
        self.size = size
        self.animation = animation
    }

    // MARK: - ビュー本体
    @available(macOS 10.15, *)
    public var body: some View {
        Image(systemName: isOn ? toggleOn : toggleOff)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(isOn ? colorOn : colorOff)
            .contentShape(Rectangle()) // クリック範囲拡張
            .onTapGesture {
                withAnimation(animation) {
                    isOn.toggle()
                    onTapAction?(isOn)
                }
            }
            .accessibilityLabel(Text(isOn ? "On" : "Off"))
    }

    // MARK: - アクション付与
    @available(macOS 10.15, *)
    public func onTaped(_ action: @escaping (Bool) -> Void) -> some View {
        var copy = self
        copy.onTapAction = action
        return copy
    }
}
