//
//  SelectableModeProtocol.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/02.
//
//  - MBGIconMode
//

import Foundation
import SwiftUI

// MARK: - アイコン付きモード

/// ボタンラベルに SF Symbols アイコンを持たせたいモード用の任意プロトコル。
///
/// Mode がこれに準拠していれば、ModeButtonGroup 側で
/// `systemImageName` を拾ってアイコン付きラベルを描画する。
///
/// 例:
/// ```swift
/// enum EditorMode: String, MBGEnumProtocol, MBGIconMode {
///     case edit   = "Edit"
///     case view   = "View"
///
///     var systemImageName: String? {
///         switch self {
///         case .edit: return "rectangle.and.pencil.and.ellipsis"
///         case .view: return "eye"
///         }
///     }
/// }
/// ```
public protocol MBGIconMode {
    /// SF Symbols 名（例: "rectangle.and.pencil.and.ellipsis"）。
    /// アイコン不要なケースでは `nil` を返してもよい。
    var systemImageName: String? { get }
}

public enum MBGIconTextStyle: String, CaseIterable, MBGEnumProtocol {
    case titleOnly      // テキストだけ
    case iconOnly       // アイコンだけ
    case iconLeading    // アイコン + テキスト（左アイコン）
    case iconTrailing   // テキスト + アイコン（右アイコン）
    // 将来:
    // case iconTop, iconBottom などもアリ
}


// MARK: - おまけ: アイコン付き配列モード

/// 配列ベースでも SF Symbols アイコンを使いたい場合のラッパー。
///
/// 例:
/// ```swift
/// let modes: [MBGIconArrayMode] = [
///     .init(id: 0, title: "Edit", systemImageName: "rectangle.and.pencil.and.ellipsis"),
///     .init(id: 1, title: "View", systemImageName: "eye")
/// ]
/// ```
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct MBGIconArrayMode: MBGArrayModeProtocol, MBGIconMode {
    public typealias ID = Int

    public let id: Int
    public let displayName: String
    public let systemImageName: String?

    public init(id: Int, title: String, systemImageName: String? = nil) {
        self.id = id
        self.displayName = title
        self.systemImageName = systemImageName
    }
}
