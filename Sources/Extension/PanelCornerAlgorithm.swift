//
//  PanelCornerAlgorithm.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/23.
//

import SwiftUI

/// A protocol defining the algorithm for creating panel corner paths.
public protocol PanelCornerAlgorithm: Sendable {
    func panelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat) -> Path
    func gapPanelPath(rect: CGRect, cornerKind: PanelCornerKind, cornerRadius: CGFloat, gapWidth: CGFloat) -> Path
}

// Environment key for storing the current panel corner algorithm.
// Defaults to CircularCornerAlgorithm.
private struct PanelCornerAlgorithmKey: EnvironmentKey {
    static let defaultValue: any PanelCornerAlgorithm = CircularCornerAlgorithm()
}

extension EnvironmentValues {
    /// The panel corner algorithm used to draw panel corners.
    public var panelCornerAlgorithm: any PanelCornerAlgorithm {
        get { self[PanelCornerAlgorithmKey.self] }
        set { self[PanelCornerAlgorithmKey.self] = newValue }
    }
}

public extension View {
    /// Sets the panel corner algorithm environment value.
    func panelCornerAlgorithm(_ algorithm: some PanelCornerAlgorithm) -> some View {
        environment(\.panelCornerAlgorithm, algorithm)
    }
}

