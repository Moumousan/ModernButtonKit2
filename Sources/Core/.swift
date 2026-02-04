//
//  that.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/05.
//


// MARK: - Simple icon mode implementation

/// Simple “id + title + optional system image” mode.
///
/// This is a lightweight helper struct that already conforms to
/// `MBGArrayModeProtocol` and (optionally) your icon style protocol
/// such as `MBGIconMode`.
///
/// Recommended for quick prototypes and QAC-style tools.
/// Simple “id + title + optional system image” mode.
///
/// Lightweight helper for toolbars / tab bars / QAC-style UIs.
public struct MBGIconArrayMode: MBGArrayModeProtocol, MBGIconMode {
    public typealias ID = Int

    public let id: Int
    public let displayName: String
    public let systemImageName: String?
    public let iconTextStyle: MBGIconTextStyle

    public init(id: Int,
                title: String,
                systemImageName: String? = nil,
                iconTextStyle: MBGIconTextStyle = .iconLeading) {
        self.id = id
        self.displayName = title
        self.systemImageName = systemImageName
        self.iconTextStyle = iconTextStyle
    }
}
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
