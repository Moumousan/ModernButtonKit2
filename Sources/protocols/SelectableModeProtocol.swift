//
//  SelectableModeProtocol.swift
//  ModernButtonKit2
//
//  Base protocol for selectable “modes” used by MBG buttons.
//  This covers both enum-based modes and array/struct-based modes.
//

import Foundation

/// Common requirements for any selectable mode used with MBG.
///
/// - `ID` is the stable identifier type used for selection.
/// - `displayName` is the human-readable label shown in the UI.
///
/// Types conforming to this protocol must also be `Hashable` and `Sendable`
/// so that they can safely participate in SwiftUI state and collections.
public protocol SelectableModeProtocol: Identifiable, Hashable, Sendable {
    associatedtype ID: Hashable

    /// Stable identifier for the mode.
    var id: ID { get }

    /// Human-readable label for the mode.
    var displayName: String { get }
}
