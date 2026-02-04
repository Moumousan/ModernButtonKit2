//
//  MBGProtocols.swift
//
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/04.
//


// MBGProtocols.swift
// Shared protocol foundations for MBG-style mode enums and arrays.
//
// Place this file inside the ModernButtonKit2 target.
// For example: Sources/ModernButtonKit2/MBGProtocols.swift

import Foundation

/// Core enumeration protocol for MBG-style mode enums.
///
/// Typical usage:
///
/// enum ThemeMode: String, CaseIterable, Sendable, MBGEnumProtocol {
///     case light, dark
/// }
///
/// // …or:
/// enum ThemeMode: String, CaseIterable, Sendable, SelectableModeProtocol { … }
public protocol MBGEnumProtocol: CaseIterable, Identifiable, Sendable where ID == Self {
    associatedtype ID = Self

    /// Human-friendly label used in buttons and menus.
    var displayName: String { get }

    /// Identifier for the mode – by default, the case itself.
    var id: Self { get }
}

public extension MBGEnumProtocol {
    var id: Self { self }

    /// Default implementation: prettify the case name.
    ///
    /// - Replaces "_" with " "
    /// - Capitalises each word
    var displayName: String {
        String(describing: self)
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}

/// Marker protocol for “selectable modes” used in MBG().
///
/// This is what most app-side enums should conform to.
public protocol SelectableModeProtocol: MBGEnumProtocol { }

/// Simple protocol for array-backed modes (non-enum).
///
/// Useful when the user wants to drive MBG() from arbitrary data models
/// instead of enums.
public protocol MBGArrayModeProtocol: Identifiable, Sendable, Hashable {
    /// A stable identifier – often a key, slug or raw value.
    var id: String { get }

    /// Human-friendly label.
    var displayName: String { get }
}

public extension MBGArrayModeProtocol {
    /// Default identifier: use the display name.
    var id: String { displayName }
}
