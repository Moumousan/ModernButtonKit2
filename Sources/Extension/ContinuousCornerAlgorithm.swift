//
//  ContinuousCornerAlgorithm.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/23.
//

import SwiftUI

public struct ContinuousCornerAlgorithm: PanelCornerAlgorithm {
    public var softness: CGFloat // 0..1, where 0->circle, higher->more continuous-like
    public init(softness: CGFloat = 0.35) { self.softness = max(0, min(softness, 1)) }

    public func panelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat) -> Path {
        switch cornerKind {
        case .concave:
            // Defer to existing concave for now
            return PanelBaseShape(cornerKind: cornerKind, cornerRadius: cornerRadius).path(in: rect)
        case .convex:
            return continuousRoundedRect(rect: rect, radius: cornerRadius)
        }
    }

    public func gapPanelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat, gapWidth: CGFloat) -> Path {
        switch cornerKind {
        case .concave:
            return TitleGapPanelShape(cornerKind: cornerKind, cornerRadius: cornerRadius, gapWidth: gapWidth).path(in: rect)
        case .convex:
            // Build path like continuous rect, but leave a gap on the top edge
            return continuousRoundedRect(rect: rect, radius: cornerRadius, gapWidth: gapWidth)
        }
    }

    // A simple continuous-like rounded rectangle using tuned Bezier control distance
    private func continuousRoundedRect(rect: CGRect, radius: CGFloat, gapWidth: CGFloat? = nil) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        guard w > 0, h > 0 else { return p }
        let maxR = min(w, h) / 2
        let r = min(radius, maxR)
        let kCircle: CGFloat = 0.5522847498307936 // circle
        let k = kCircle * (1 - 0.35 * softness)   // pull control points inward for smoother entry

        let minX = rect.minX, maxX = rect.maxX, minY = rect.minY, maxY = rect.maxY
        let gap: CGFloat? = gapWidth.map { min($0, max(0, w - 2*r)) }
        let gapLeft = gap.map { rect.midX - $0/2 }
        let gapRight = gap.map { rect.midX + $0/2 }

        // Start at top-left arc start
        p.move(to: CGPoint(x: minX + r, y: minY))
        // Top edge to gap or to top-right start
        if let gL = gapLeft {
            p.addLine(to: CGPoint(x: gL, y: minY))
            if let gR = gapRight { p.move(to: CGPoint(x: gR, y: minY)) }
        }
        p.addLine(to: CGPoint(x: maxX - r, y: minY))
        // Top-right continuous corner (to right edge)
        p.addCurve(to: CGPoint(x: maxX, y: minY + r),
                   control1: CGPoint(x: maxX - r + k*r, y: minY),
                   control2: CGPoint(x: maxX, y: minY + r - k*r))
        // Right edge
        p.addLine(to: CGPoint(x: maxX, y: maxY - r))
        // Bottom-right
        p.addCurve(to: CGPoint(x: maxX - r, y: maxY),
                   control1: CGPoint(x: maxX, y: maxY - r + k*r),
                   control2: CGPoint(x: maxX - r + k*r, y: maxY))
        // Bottom edge
        p.addLine(to: CGPoint(x: minX + r, y: maxY))
        // Bottom-left
        p.addCurve(to: CGPoint(x: minX, y: maxY - r),
                   control1: CGPoint(x: minX + r - k*r, y: maxY),
                   control2: CGPoint(x: minX, y: maxY - r + k*r))
        // Left edge
        p.addLine(to: CGPoint(x: minX, y: minY + r))
        // Top-left
        p.addCurve(to: CGPoint(x: minX + r, y: minY),
                   control1: CGPoint(x: minX, y: minY + r - k*r),
                   control2: CGPoint(x: minX + r - k*r, y: minY))
        p.closeSubpath()
        return p
    }
}

