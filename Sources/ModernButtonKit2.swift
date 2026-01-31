// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  Kyoto Denno Kogei Kobo-sha, 2025
//
import Foundation

// Import MBGWorldStandardKit only when it is both present and the platform version supports it.
// This avoids build-time errors when the package/app targets macOS versions earlier than the
// module's minimum deployment target (macOS 15.0).
#if canImport(MBGWorldStandardKit)
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public enum _MBGWorldStandardKitAvailabilityGate {
    // The static property is used to force type-checkers to consider availability before use.
    public static func load() {}
}

// Only export the module on supported platforms to prevent the compiler from attempting
// to resolve the module when the deployment target is lower than the module supports.
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@_exported import MBGWorldStandardKit
#else
// Fallback shim when MBGWorldStandardKit is unavailable so clients still compile.
// Define minimal placeholders your package expects from MBGWorldStandardKit below.
public enum _MBGWorldStandardKitAvailabilityGate {
    public static func load() {}
}
#endif

// Example usage pattern within the package (keep references guarded by availability):
// @available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
// func useWorldStandardKitFeature() {
//     _MBGWorldStandardKitAvailabilityGate.load()
//     // Use MBGWorldStandardKit symbols here.
// }

/*

//
//  ModernButtonKit2.swift
//  ModernButtonKit2
//
//  Kyoto Denno Kogei Kobo-sha, 2025
//

// This source file is part of the MBGWorld project.
// See the LICENSE file for licensing information.

// Swift Package support
// Only attempt to import MBGWorldStandardKit when it is available to the build.
#if canImport(MBGWorldStandardKit)
  #if os(macOS)
    // Gate usage on macOS 15+ to avoid deployment target mismatch.
    @available(macOS 15, *)
    @_exported import MBGWorldStandardKit
  #else
    // On non-macOS platforms, just export the module when it exists.
    @_exported import MBGWorldStandardKit
  #endif
#else
  // Provide minimal shims so clients compile if MBGWorldStandardKit isn't present.
  public enum MBGWorldStandardKitUnavailable: Error { case missing }
#endif

@_exported import SwiftUI
@_exported import Foundation
@_exported import Combine

// Note:
// Do not import ModernButtonKit2 from within the ModernButtonKit2 module.
// Public types declared in this target (e.g., MBG, MBGToggle, MBGHybridToolbar,
// SelectableModeProtocol, SizeMode) are automatically available to clients
// when marked public in their own files.

*/
