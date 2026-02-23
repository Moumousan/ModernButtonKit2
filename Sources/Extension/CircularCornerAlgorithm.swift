//
//  CircularCornerAlgorithm.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/23.
//

import SwiftUI

/// Default circular (current) algorithm reusing existing shapes
/// This preserves the existing behavior and includes the earlier top-right corner fix.
public struct CircularCornerAlgorithm: PanelCornerAlgorithm {
    public init() {}

    public func panelPath(
        rect: CGRect,
        cornerKind: PanelCornerKind,
        cornerRadius: CGFloat
    ) -> Path {
        PanelBaseShape(cornerKind: cornerKind, cornerRadius: cornerRadius).path(in: rect)
    }

    public func gapPanelPath(
        rect: CGRect,
        cornerKind: PanelCornerKind,
        cornerRadius: CGFloat,
        gapWidth: CGFloat
    ) -> Path {
        TitleGapPanelShape(cornerKind: cornerKind, cornerRadius: cornerRadius, gapWidth: gapWidth).path(in: rect)
    }
}

