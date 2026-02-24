//
//  AlgorithmPanelShape.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/23.
//


import SwiftUI

/// A shape that delegates path creation to a PanelCornerAlgorithm for panels.
struct AlgorithmPanelShape: InsettableShape {
    var algorithm: any PanelCornerAlgorithm
    var cornerKind: PanelCornerKind
    var cornerRadius: CGFloat
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    func path(in rect: CGRect) -> Path {
        algorithm.panelPath(
            rect: rect.insetBy(dx: insetAmount, dy: insetAmount),
            cornerKind: cornerKind,
            cornerRadius: cornerRadius
        )
    }
}

/// A shape that delegates path creation to a PanelCornerAlgorithm for gap panels.
struct AlgorithmGapPanelShape: InsettableShape {
    var algorithm: any PanelCornerAlgorithm
    var cornerKind: PanelCornerKind
    var cornerRadius: CGFloat
    var gapWidth: CGFloat
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    func path(in rect: CGRect) -> Path {
        algorithm.gapPanelPath(
            rect: rect.insetBy(dx: insetAmount, dy: insetAmount),
            cornerKind: cornerKind,
            cornerRadius: cornerRadius,
            gapWidth: gapWidth
        )
    }
}
struct TitleGapPanelShape: InsettableShape {
    var cornerKind: PanelCornerKind
    var cornerRadius: CGFloat
    var gapWidth: CGFloat
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var c = self
        c.insetAmount += amount
        return c
    }

    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        var p = Path()
        guard rect.width > 0, rect.height > 0 else { return p }

        let w = rect.width
        let h = rect.height
        let maxR = min(w, h) / 2
        let r = min(cornerRadius, maxR)

        // Gap on the top edge centered
        let gap = min(gapWidth, max(0, w - 2*r))
        let midX = rect.midX
        let gapLeft = midX - gap/2
        let gapRight = midX + gap/2

        switch cornerKind {
        case .convex:
            // Rounded rect with a gap on the top edge
            // Start at top-left arc start
            p.move(to: CGPoint(x: rect.minX + r, y: rect.minY))
            // Top-left arc
            p.addArc(center: CGPoint(x: rect.minX + r, y: rect.minY + r),
                     radius: r,
                     startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
            // Left edge
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - r))
            // Bottom-left arc
            p.addArc(center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
                     radius: r,
                     startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
            // Bottom edge
            p.addLine(to: CGPoint(x: rect.maxX - r, y: rect.maxY))
            // Bottom-right arc
            p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
                     radius: r,
                     startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
            // Right edge
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + r))
            // Top-right arc
            p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
                     radius: r,
                     startAngle: .degrees(0), endAngle: .degrees(270), clockwise: true)
            // Top edge up to gap right
            p.addLine(to: CGPoint(x: gapRight, y: rect.minY))
            // Skip gap: move to gap left and close to start
            p.move(to: CGPoint(x: gapLeft, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX + r, y: rect.minY))
            p.closeSubpath()
            return p

        case .concave:
            // Concave corners with a gap on top edge
            let minX = rect.minX
            let maxX = rect.maxX
            let minY = rect.minY
            let maxY = rect.maxY

            let leftX   = minX + r
            let rightX  = maxX - r
            let topY    = minY + r
            let bottomY = maxY - r

            // Top edge split by gap
            p.move(to: CGPoint(x: leftX, y: minY))
            p.addLine(to: CGPoint(x: gapLeft, y: minY))
            p.move(to: CGPoint(x: gapRight, y: minY))
            p.addLine(to: CGPoint(x: rightX, y: minY))

            // Top-right concave arc
            p.addArc(center: CGPoint(x: maxX - r, y: minY + r),
                     radius: r,
                     startAngle: .degrees(270), endAngle: .degrees(0), clockwise: true)
            // Right edge
            p.addLine(to: CGPoint(x: maxX, y: bottomY))
            // Bottom-right concave arc
            p.addArc(center: CGPoint(x: maxX - r, y: maxY - r),
                     radius: r,
                     startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
            // Bottom edge
            p.addLine(to: CGPoint(x: leftX, y: maxY))
            // Bottom-left concave arc
            p.addArc(center: CGPoint(x: minX + r, y: maxY - r),
                     radius: r,
                     startAngle: .degrees(90), endAngle: .degrees(180), clockwise: true)
            // Left edge
            p.addLine(to: CGPoint(x: minX, y: topY))
            // Top-left concave arc
            p.addArc(center: CGPoint(x: minX + r, y: minY + r),
                     radius: r,
                     startAngle: .degrees(180), endAngle: .degrees(270), clockwise: true)
            p.closeSubpath()
            return p
        }
    }
}

