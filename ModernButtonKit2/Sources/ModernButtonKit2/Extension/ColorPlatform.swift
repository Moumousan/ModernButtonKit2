#if canImport(SwiftUI)
//
//  ColorPlatform.swift
//  ModernButtonKit
//

import SwiftUI
import Combine

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Color {
    
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    static var platformBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    static var platformSecondaryBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #else
        return Color(nsColor: .underPageBackgroundColor)
        #endif
    }
    
    @available(iOS 13.0, macOS 12.0, watchOS 6.0, tvOS 13.0, *)
    static var platformLabel: Color {
        #if os(iOS)
        return Color(uiColor: .label)
        #else
        return Color(nsColor: .labelColor)
        #endif
    }
    
    @available(iOS 13.0, macOS 12.0, watchOS 6.0, tvOS 13.0, *)
    static var platformSecondaryLabel: Color {
        #if os(iOS)
        return Color(uiColor: .secondaryLabel)
        #else
        return Color(nsColor: .secondaryLabelColor)
        #endif
    }
    
    @available(iOS 13.0, macOS 12.0, watchOS 6.0, tvOS 13.0, *)
    static var platformSeparator: Color {
        #if os(iOS)
        return Color(uiColor: .separator)
        #else // macOS only
        return Color(nsColor: .separatorColor)
        #endif
    }
    
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static var platformAccent: Color {
        return Color.accentColor
    }
    
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static var platformButtonBackground: Color {
        Color.accentColor.opacity(0.8)
    }

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static var platformButtonText: Color {
        Color.white
    }

    @available(iOS 13.0, macOS 12.0, watchOS 6.0, tvOS 13.0, *)
    static var platformTapHighlight: Color {
        #if os(iOS)
        return Color(uiColor: .systemGray4)
        #else
        return Color(nsColor: .quaternaryLabelColor)
        #endif
    }
    
    /// 背景用グレー（旧appGray相当）
    @available(iOS 13.0, macOS 10.15, *)
    static var appGrayBackground: Color {
        #if os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color(uiColor: .systemBackground)
        #endif
    }
    
    /// よりニュートラルな灰色バリエーション
    @available(iOS 13.0, macOS 10.15, *)
    static var appBackground: Color {
        #if os(macOS)
        return Color(nsColor: .underPageBackgroundColor)
        #else
        return Color(uiColor: .secondarySystemBackground)
        #endif
    }
}

#endif
