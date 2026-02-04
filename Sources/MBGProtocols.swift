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

/// Protocol for struct- or array-based mode definitions.
///
/// This is useful when you want to construct modes dynamically
/// (e.g. from configuration) instead of hard-coding enum cases.
///
/// Example:
///
/// ```swift
/// let modes: [MBGIconArrayMode] = [
///     .init(id: 0, title: "Edit",  systemImageName: "rectangle.and.pencil.and.ellipsis"),
///     .init(id: 1, title: "Share", systemImageName: "square.and.arrow.up")
/// ]
/// ```
public protocol MBGArrayModeProtocol: SelectableModeProtocol {
    /// Optional SF Symbols name to use as an icon.
    var systemImageName: String? { get }
}

// MARK: - Simple icon mode implementation

/// Simple “id + title + optional system image” mode.
///
/// This is a lightweight helper struct that already conforms to
/// `MBGArrayModeProtocol` and (optionally) your icon style protocol
/// such as `MBGIconMode`.
///
/// Recommended for quick prototypes and QAC-style tools.
public struct MBGIconArrayMode: MBGArrayModeProtocol, MBGIconMode {
    public typealias ID = Int

    public let id: Int
    public let displayName: String
    public let systemImageName: String?

    /// Create a new icon mode.
    ///
    /// - Parameters:
    ///   - id: Stable integer identifier.
    ///   - title: Label text shown in the button.
    ///   - systemImageName: Optional SF Symbol name to display next to the title.
    public init(id: Int,
                title: String,
                systemImageName: String? = nil) {
        self.id = id
        self.displayName = title
        self.systemImageName = systemImageName
    }
}
