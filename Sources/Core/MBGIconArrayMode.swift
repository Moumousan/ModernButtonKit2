//
//  MBGIconArrayMode.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/05.
//

import Foundation

/// Simple “id + title + optional system image” mode.
///
/// Lightweight helper for toolbars / tab bars / QAC-style UIs.
public struct MBGIconArrayMode: MBGArrayModeProtocol, MBGIconModeProtocol {
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

