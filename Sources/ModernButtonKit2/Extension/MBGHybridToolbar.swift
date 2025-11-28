//
//  MBGHybridToolbar.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/25.
//
/*
import SwiftUI

/// 🌗 MBGHybridToolbar — トグル群＋セグメント群の統合ツールバー
@available(macOS 10.15, iOS 13.0, *)
public struct MBGHybridToolbar<
    ToggleMode: CaseIterable & Identifiable & Hashable,
    SegmentMode: CaseIterable & Identifiable & Hashable & RawRepresentable
>: View where SegmentMode.RawValue == String {

    // MARK: - パラメータ
    public let toggleModes: [ToggleMode]
    public let segmentModes: [SegmentMode]
    @Binding public var selectedToggle: ToggleMode
    @Binding public var selectedSegment: SegmentMode
    public let themeColor: Color
    public let spacing: CGFloat

    // Bool -> ToggleMode へのマッピング（例：true => .swap, false => .colour）
    private let toggleMapper: (Bool) -> ToggleMode
    // 初期ON/OFF状態を決めるためのクロージャ（省略時は false）
    private let initialToggleState: () -> Bool

    // MARK: - イニシャライザ
    public init(
        toggleModes: [ToggleMode],
        segmentModes: [SegmentMode],
        selectedToggle: Binding<ToggleMode>,
        selectedSegment: Binding<SegmentMode>,
        themeColor: Color = .accentColor,
        spacing: CGFloat = 160,
        // 追加: トグルのON/OFFからToggleModeへ変換するマッパー
        toggleMapper: @escaping (Bool) -> ToggleMode,
        // 追加: 初期のトグルON/OFF状態（省略可）
        initialToggleState: @escaping () -> Bool = { false }
    ) {
        self.toggleModes = toggleModes
        self.segmentModes = segmentModes
        self._selectedToggle = selectedToggle
        self._selectedSegment = selectedSegment
        self.themeColor = themeColor
        self.spacing = spacing
        self.toggleMapper = toggleMapper
        self.initialToggleState = initialToggleState
    }

    // MARK: - ビュー本体
    public var body: some View {
        HStack(spacing: spacing) {
            // 左：トグル群（Swap / Colour など）
            MBGToggle(
                toggleOn: "arrow.left.arrow.right.circle.fill",  // ONアイコン
                toggleOff: "arrow.left.arrow.right.circle",      // OFFアイコン
                colorOn: themeColor,
                colorOff: .gray.opacity(0.4),
                size: 20
            )
            .onTaped { isOn in
                selectedToggle = toggleMapper(isOn)
            }
            // 初期状態反映のために、初回描画時に一度だけ設定
            .onAppear {
                selectedToggle = toggleMapper(initialToggleState())
            }

            // 右：セグメント群（Zoom / Reset / Visible）
            MBGSegmentaryV2(
                modes: segmentModes,
                selected: $selectedSegment,
                themeColor: themeColor,
                orientation: .horizontal,
                cornerRadius: 6,
                separatorColor: .gray.opacity(0.25),
                size: CGSize(width: 72, height: 28)
            )
        }
    }
}
*/
