//
//  MBGSegmentPreset.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/01/05.
//

import SwiftUI
 #if canImport(UIKit)
 import UIKit
 #endif

// Config/MBGSegmentPreset.swift
public enum MBGSegmentPreset: Sendable {
    case compact
    case standard
    case large

    public var buttonHeight: CGFloat {
        switch self {
        case .compact:  return 40   // とりあえず仮、後で調整
        case .standard: return 44
        case .large:    return 52
        }
    }

    public var baseCornerRadius: CGFloat {
        switch self {
        case .compact:  return 8
        case .standard: return 10
        case .large:    return 12
        }
    }

    public var font: PlatformFont {
        switch self {
        case .compact:  return .systemFont(ofSize: 11, weight: .medium)
        case .standard: return .systemFont(ofSize: 13, weight: .medium)
        case .large:    return .systemFont(ofSize: 15, weight: .medium)
        }
    }
}
