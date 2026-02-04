//
//  MBGProtocols.swift
//  ModernButtonKit2
//
//  Higher-level protocols and helper types used by MBG buttons.
//  These build on top of `SelectableModeProtocol` to support
//  enum-based and array/struct-based mode definitions.
//

import Foundation

// MARK: - Enum-based modes

/// Convenience protocol for enum-based modes used with MBG.
///
/// Recommended usage:
///
/// ```swift
/// enum ThemeMode: String, MBGEnumModeProtocol {
///     case light
///     case dark
///     case system
/// }
/// ```
///
/// Requirements:
/// - The type is an `enum`.
/// - It is `CaseIterable` so you can use `ThemeMode.allCases`.
/// - It conforms to `SelectableModeProtocol`.
///
/// The default extension below provides `id` and `displayName`
/// automatically when the enum has a `String` raw value.
public protocol MBGEnumModeProtocol: SelectableModeProtocol, CaseIterable
where ID == Self { }

public extension MBGEnumModeProtocol where Self: RawRepresentable, RawValue == String {
    /// Use the enum case itself as the identifier.
    var id: Self { self }

    /// Use the raw string value as the display name.
    var displayName: String { rawValue }
}

// MARK: - Array / struct-based modes

/// Base protocol for struct- or array-backed MBG modes.
///
/// This is useful when you want to construct modes dynamically
/// (for example from configuration) instead of hard-coding enum cases.
///
/// Example:
///
/// ```swift
/// let modes: [MBGIconArrayMode] = [
///     .init(id: 0,
///           title: "Edit",
///           systemImageName: "rectangle.and.pencil.and.ellipsis"),
///     .init(id: 1,
///           title: "Share",
///           systemImageName: "square.and.arrow.up")
/// ]
/// ```
///
/// Conforming types:
/// - use `Int` identifiers (stable within the array)
/// - provide a human-readable `displayName`
public protocol MBGArrayModeProtocol: SelectableModeProtocol, Hashable
where ID == Int { }

public extension MBGArrayModeProtocol {
    // At the moment we do not need extra defaults here.
    // This extension exists for future convenience methods.
}

// MARK: - Icon-aware modes

/// Additional requirements for modes that also carry SF Symbol information.
///
/// A type that conforms to `MBGIconModeProtocol`:
/// - is an array/struct-backed mode (`MBGArrayModeProtocol`)
/// - optionally exposes an SF Symbol name
/// - tells MBG how to arrange title and icon via `iconTextStyle`.
public protocol MBGIconModeProtocol: MBGArrayModeProtocol {
    /// Optional SF Symbol name (e.g. "rectangle.and.pencil.and.ellipsis").
    var systemImageName: String? { get }

    /// How to combine the title text and the icon.
    var iconTextStyle: MBGIconTextStyle { get }
}

/// For quick prototypes and QAC-style tools you can use `MBGIconArrayMode`,
/// a lightweight struct defined in `Core/MBGIconArrayMode.swift` that already
/// conforms to `MBGIconModeProtocol`.


/// Optional SF Symbol を提供できるモード用のプロトコル。
/// ModeButtonGroup は、これに準拠していれば `systemImageName` を拾って
/// アイコン付きラベルを自動で作ってくれます。
public protocol MBGIconMode {
    /// SF Symbols 名。アイコン不要な場合は `nil`。
    var systemImageName: String? { get }
}
