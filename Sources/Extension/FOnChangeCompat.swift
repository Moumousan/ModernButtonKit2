//
//  OnChangeCompat.swift
//  ModernButtonKit2
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/10/24.
//

import SwiftUI

/// ⚠️ Deprecated: Use `MBGUtilityKit.mbgOnChange` instead.
///
/// This temporary compatibility version will be removed
/// once MBGUtilityKit becomes a required dependency for Kit2.
///
@available(*, deprecated, message: "Use MBGUtilityKit.mbgOnChange instead.")
@available(macOS 10.15, iOS 13.0, *)
public extension View {
    @ViewBuilder
    func mbgOnChange<Value: Equatable>(
        of value: Value,
        initial: Bool = false,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        if #available(macOS 14.0, iOS 17.0, *) {
            // ✅ SwiftUI 17以降では (oldValue, newValue) の2引数
            self.onChange(of: value, initial: initial) { _, newValue in
                action(newValue)
            }
        } else {
            // ✅ 旧バージョンでは (newValue) のみ
            self.onChange(of: value) { newValue in
                action(newValue)
            }
        }
    }
}
