//
//  EllipticalCornerAlgorithm.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/23.
//


import SwiftUI

public struct EllipticalCornerAlgorithm: PanelCornerAlgorithm {
    public var aspect: CGFloat // ry/rx ratio, 1.0 == circle
    public init(aspect: CGFloat = 1.15) { self.aspect = max(aspect, 0.01) }

    public func panelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat) -> Path {
        // Use the existing circular path and scale Y to achieve ellipse (simple, stable)
        // For convex: scale the coordinate system around each corner. For simplicity and stability,
        // we approximate by scaling the entire rect vertically around its center, then reuse PanelBaseShape.
        // Note: This keeps concave behavior consistent as well.
        var scaled = rect
        // Compute vertical scaling: ry = aspect * rx => scaleY = aspect
        let scaleY = aspect
        // Apply vertical scaling by transforming the path.
        let base = PanelBaseShape(cornerKind: cornerKind, cornerRadius: cornerRadius).path(in: rect)
        var t = CGAffineTransform.identity
        // Scale around rect center to maintain layout
        t = t.translatedBy(x: rect.midX, y: rect.midY)
        t = t.scaledBy(x: 1.0, y: scaleY)
        t = t.translatedBy(x: -rect.midX, y: -rect.midY)
        return base.applying(t)
    }

    public func gapPanelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat, gapWidth: CGFloat) -> Path {
        let base = TitleGapPanelShape(cornerKind: cornerKind, cornerRadius: cornerRadius, gapWidth: gapWidth).path(in: rect)
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: rect.midX, y: rect.midY)
        t = t.scaledBy(x: 1.0, y: aspect)
        t = t.translatedBy(x: -rect.midX, y: -rect.midY)
        return base.applying(t)
    }
}
