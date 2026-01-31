// The Swift Programming Language
// https://docs.swift.org/swift-book

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

