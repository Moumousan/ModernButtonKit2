// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  ModernButtonKit2.swift
//  ModernButtonKit2
//
//  Kyoto Denno Kogei Kobo-sha, 2025
//

#if canImport(MBGWorldStandardKit)
@_exported import MBGWorldStandardKit
#else
// Fallback shim when MBGWorldStandardKit is unavailable so clients still compile.
@_exported import Foundation

// Define minimal placeholders that your package expects from MBGWorldStandardKit (if any).
// Add more shims here as needed to satisfy references when the module is absent.
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

