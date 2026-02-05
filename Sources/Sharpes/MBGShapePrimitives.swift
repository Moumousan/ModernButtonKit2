//  ShapePrimitives.swift
//  ModernButtonKit2
//
//  Core shape primitives used across MBG World.
//  These types describe geometry only; colours, strokes and shadows
//  are applied by higher-level styles / modifiers.

import SwiftUI

/// Vertical “D” shape panel: one straight side, one rounded side.
///
/// Typical usage:
/// ```swift
/// DSidePanel(cornerRadius: 32, side: .left)
///     .fill(Color.platformBackground)
/// ```
///
/// This shape knows nothing about colours or shadows; those are
/// handled by modifiers such as `mbgShadowBlock(…)`.
public struct DSidePanel: Shape {

    /// Side selection for “D-shaped” panels (one rounded side).
    public enum Side: Sendable {
        case left
        case right
    }

    public var cornerRadius: CGFloat
    public var side: Side

    public init(cornerRadius: CGFloat = 24, side: Side) {
        self.cornerRadius = cornerRadius
        self.side = side
    }

    public func path(in rect: CGRect) -> Path {
        let r = min(cornerRadius, rect.height / 2)
        var path = Path()

        switch side {
        case .left:
            // Start at top-right and walk counter-clockwise.
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))

            // Top edge towards left, stopping before the arc.
            path.addLine(to: CGPoint(x: rect.minX + r, y: rect.minY))

            // Left semi-circle (vertical “D”).
            path.addArc(
                center: CGPoint(x: rect.minX + r, y: rect.midY),
                radius: r,
                startAngle: .degrees(-90),
                endAngle: .degrees(90),
                clockwise: false
            )

            // Bottom edge back to the right side.
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

            // Close along the right edge.
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.closeSubpath()

        case .right:
            // Start at top-left and walk clockwise.
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))

            // Top edge towards right, stopping before the arc.
            path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))

            // Right semi-circle (vertical “D”).
            path.addArc(
                center: CGPoint(x: rect.maxX - r, y: rect.midY),
                radius: r,
                startAngle: .degrees(-90),
                endAngle: .degrees(90),
                clockwise: true
            )

            // Bottom edge back to the left side.
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

            // Close along the left edge.
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.closeSubpath()
        }

        return path
    }
}

/// Rounded rectangle frame with no top border.
///
/// Intended to be used with `stroke` to create “open-top” boxes
/// for titles / labels, similar to LaTeX packages that leave room
/// for a heading on the top edge.
public struct NoTopBorderBox: Shape {

    public var cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = 12) {
        self.cornerRadius = cornerRadius
    }

    public func path(in rect: CGRect) -> Path {
        let r = min(cornerRadius, min(rect.width, rect.height) / 2)
        var path = Path()

        // Start at bottom-left (after the radius).
        path.move(to: CGPoint(x: rect.minX + r, y: rect.maxY))

        // Bottom edge → bottom-right.
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.maxY))

        // Bottom-right corner.
        path.addArc(
            center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        // Right edge → top-right (just before the radius).
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + r))

        // Top-right corner, but *do not* draw the top edge.
        path.addArc(
            center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )

        // Leftwards along the (hidden) top edge to the other corner.
        path.addLine(to: CGPoint(x: rect.minX + r, y: rect.minY))

        // Top-left corner.
        path.addArc(
            center: CGPoint(x: rect.minX + r, y: rect.minY + r),
            radius: r,
            startAngle: .degrees(-90),
            endAngle: .degrees(-180),
            clockwise: true
        )

        // Left edge back down towards the start.
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - r))

        // Bottom-left corner.
        path.addArc(
            center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
            radius: r,
            startAngle: .degrees(-180),
            endAngle: .degrees(90),
            clockwise: true
        )

        return path
    }
}
