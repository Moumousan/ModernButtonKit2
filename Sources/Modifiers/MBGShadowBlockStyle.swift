//
//  MBGShadowBlockStyle.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/05.
//


//  MBGShapeStyleModifiers.swift
//  ModernButtonKit2
//
//  Shared style helpers for applying filled shapes and shadows
//  behind arbitrary content.

import SwiftUI

/// Simple description of a drop shadow for MBG blocks.
///
/// Designed to be driven by slider-based playgrounds:
/// you tweak these values interactively, then copy the resulting
/// initialiser into your app code.
public struct MBGShadowBlockStyle: Sendable {

    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    public var opacity: Double

    public init(
        radius: CGFloat = 8,
        x: CGFloat = 0,
        y: CGFloat = 4,
        opacity: Double = 0.25
    ) {
        self.radius = radius
        self.x = x
        self.y = y
        self.opacity = opacity
    }

    /// A slightly stronger shadow suitable for inspector-style panels.
    public static let inspectorDefault = MBGShadowBlockStyle(
        radius: 12,
        x: 0,
        y: 6,
        opacity: 0.30
    )
}

/// ViewModifier that draws a filled shape with a drop shadow
/// behind the modified content.
///
/// The content itself is *not* clipped by the shape; clipping can be
/// applied separately if desired.
public struct MBGShadowBlockModifier<S: Shape>: ViewModifier {

    public var shape: S
    public var fill: Color
    public var shadow: MBGShadowBlockStyle

    public init(shape: S,
                fill: Color,
                shadow: MBGShadowBlockStyle) {
        self.shape = shape
        self.fill = fill
        self.shadow = shadow
    }

    public func body(content: Content) -> some View {
        content
            .background(
                shape
                    .fill(fill)
                    .shadow(
                        color: .black.opacity(shadow.opacity),
                        radius: shadow.radius,
                        x: shadow.x,
                        y: shadow.y
                    )
            )
    }
}

public extension View {
    /// Convenience helper to place a filled, shadowed shape behind this view.
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     Text("Area 1")
    ///         .font(.headline)
    ///         .padding()
    /// }
    /// .mbgShadowBlock(
    ///     shape: DSidePanel(cornerRadius: 32, side: .left),
    ///     fill: Color.platformBackground,
    ///     shadow: .inspectorDefault
    /// )
    /// ```
    func mbgShadowBlock<S: Shape>(
        shape: S,
        fill: Color = .clear,
        shadow: MBGShadowBlockStyle = .init()
    ) -> some View {
        modifier(
            MBGShadowBlockModifier(
                shape: shape,
                fill: fill,
                shadow: shadow
            )
        )
    }
}
