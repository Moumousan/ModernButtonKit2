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
