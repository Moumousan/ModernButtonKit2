//
//  MBGNamespace.swift
//  ModernButtonKit2
//
//  Logical namespace and documentation for the MBG API family.
//
//  IMPORTANT:
//  This file must NOT declare another type named `MBG`, because the
//  core builder is already defined elsewhere as:
//
//      public struct MBG<Mode, Layout, SizeMode>: View { ... }
//
//  If you want a logical namespace, use `MBGNamespace` (this type)
//  and keep the `MBG` identifier reserved for the generic builder.
//

import Foundation

/// Logical namespace for MBG-related helpers and presets.
///
/// This is intentionally lightweight. It exists mainly as a place to hang
/// documentation and future “catalogue-style” APIs without colliding with
/// the main `MBG` builder type.
public enum MBGNamespace {

    // MARK: - Design manifesto (summary)

    /// MBG buttons are built around three ideas:
    ///
    /// 1. **Modes** – What choices the user can make.
    /// 2. **Layout** – How those choices are arranged (horizontal, vertical,
    ///    segmented, scrollable, etc.).
    /// 3. **Size** – How big each button appears (standard, compact, large).
    ///
    /// The generic builder:
    ///
    /// ```swift
    /// MBG(modes:  ThemeMode.allCases,
    ///     selected: $theme,
    ///     iconPlacement: .leading,
    ///     pressEffect: .scaleDown(),
    ///     themeColor: .green)
    /// ```
    ///
    /// glues these concepts together in a predictable way.  Protocols such as
    /// `MBGEnumModeProtocol` and `MBGArrayModeProtocol` keep the call-sites
    /// tidy while remaining fully type-safe.
    public static func manifesto() {
        // This function is intentionally empty.
        // It exists only as an anchor for documentation.
    }
}
