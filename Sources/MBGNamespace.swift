//
//  MBGNamespace.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/04.
//


// MBGNamespace.swift
// Root namespace for shared MBG configuration types.
//
// Place this file inside the ModernButtonKit2 target.

import SwiftUI

/// Root namespace for shared MBG configuration types.
///
/// Example usage:
///
/// MBG(
///     modes: ThemeMode.allCases,
///     selected: $theme,
///     iconPlacement: .leading,
///     pressEffect: .standard,
///     themeColor: .green
/// )
public enum MBG {

    // MARK: - Press effect

    /// Press / tap behaviour for MBG buttons.
    public enum PressEffect: Equatable, Sendable {
        /// No visual feedback on tap (not recommended in most UIs).
        case none

        /// Scale the button down slightly while pressed.
        case scaleDown(factor: CGFloat = 0.96)

        /// Blink the glow on and off over the given duration.
        ///
        /// If you set the duration to `0`, the glow will not blink.
        case blink(duration: Double = 0.4)
    }

    // MARK: - Icon placement

    /// Placement of the SF Symbol icon relative to the label.
    public enum IconPlacement: Equatable, Sendable {
        /// No icon at all – label only.
        case labelOnly

        /// Icon leading, label trailing.
        case leading

        /// Label leading, icon trailing.
        case trailing

        /// Icon only – no label.
        case iconOnly
    }
}

