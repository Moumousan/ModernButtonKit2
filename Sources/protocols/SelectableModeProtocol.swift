//
//  SelectableModeProtocol.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/02.
//


//
//  MBGProtocols.swift
//  ModernButtonKit2
//
//  共通プロトコル置き場：
//  - SelectableModeProtocol
//  - MBGEnumProtocol
//  - MBGIconMode
//

import Foundation

// 必要なら SwiftUI も読み込んで OK（Text 表示の説明などで使う場合）。
import SwiftUI

// MARK: - 基本モードプロトコル

/// ModeButtonGroup などの「選択モード」が従うべき基本プロトコル。
/// - 必須:
///   - Identifiable / Hashable
///   - displayName: ボタンラベルに使う文字列
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public protocol SelectableModeProtocol: Identifiable, Hashable {
    /// ラベル表示に使う名前（タイトル）
    var displayName: String { get }
}

// MARK: - enum 用シンタックスシュガー

/// MBG 系で「enum をそのままモードとして使う」ためのプロトコル。
///
/// - SelectableModeProtocol を内包しているので、ModeButtonGroup などの
///   `Mode: Hashable & SelectableModeProtocol` 制約をそのまま満たせる。
/// - CaseIterable なので、必要なら `.allCases` も使える。
/// - `where ID == Self` によって、`id` は「自分自身」を返す前提になる。
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public protocol MBGEnumProtocol: SelectableModeProtocol, CaseIterable
where ID == Self { }

/// デフォルト実装:
/// - `id` は `self`
/// - `displayName` は `String(describing: self)`
///
/// RawValue を持たない enum でも、このまま ModeButtonGroup に渡して使える。
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension MBGEnumProtocol {
    /// Identifiable.ID は Self に固定
    var id: Self { self }

    /// デフォルトの表示名。
    /// RawValue が無い enum でも、それなりに読める文字列になる。
    var displayName: String {
        String(describing: self)
    }
}

// RawValue = String の enum のための「ごほうび」実装。
// 例: `enum Theme: String, MBGEnumProtocol { case light = "Light" }` の displayName が "Light" になる。
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension MBGEnumProtocol where Self: RawRepresentable, RawValue == String {
    var displayName: String { rawValue }
}

// RawValue = Int の enum 向け。
// 例: 0〜F の 16 進モードなどで、その数値を文字列化して使うケース。
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension MBGEnumProtocol where Self: RawRepresentable, RawValue == Int {
    var displayName: String { String(rawValue) }
}

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