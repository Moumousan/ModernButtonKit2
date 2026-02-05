//
//  MBGTextMetrics.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/05.
//


//
//  MBGTextMetrics.swift
//  ModernButtonKit2
//
//  Shared helpers for measuring text sizes based on PlatformFont.
//

import Foundation

public enum MBGTextMetrics {

    /// Width of a single label string (in points).
    public static func textWidth(
        _ text: String,
        font: PlatformFont
    ) -> CGFloat {
        let nsString = text as NSString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        return nsString.size(withAttributes: attributes).width
    }

    /// Maximum label width for an array of strings.
    public static func maxTextWidth(
        _ texts: [String],
        font: PlatformFont
    ) -> CGFloat {
        let widths = texts.map { textWidth($0, font: font) }
        return widths.max() ?? 0
    }

    /// Maximum label width for an array of items with a `String` property.
    ///
    /// Example:
    /// ```swift
    /// let max = MBGTextMetrics.maxTextWidth(
    ///     in: modes,
    ///     text: \.displayName,
    ///     font: font
    /// )
    /// ```
    public static func maxTextWidth<T>(
        in items: [T],
        text keyPath: KeyPath<T, String>,
        font: PlatformFont
    ) -> CGFloat {
        let labels = items.map { $0[keyPath: keyPath] }
        return maxTextWidth(labels, font: font)
    }
}