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

public enum MBGIconTextStyle: String, CaseIterable, MBGEnumProtocol {
    case titleOnly      // テキストだけ
    case iconOnly       // アイコンだけ
    case iconLeading    // アイコン + テキスト（左アイコン）
    case iconTrailing   // テキスト + アイコン（右アイコン）
    // 将来:
    // case iconTop, iconBottom などもアリ
}

// MARK: - 配列ベースのモード用プロトコル

/// enum ではなく「配列で Mode のリストを持ちたい」場合のためのプロトコル。
///
/// - SelectableModeProtocol を継承するだけの薄いラッパー。
/// - CaseIterable や RawRepresentable を要求しないので、
///   struct / class / String ラッパーなどにも自由に使える。
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public protocol MBGArrayModeProtocol: SelectableModeProtocol { }


// MARK: - 汎用の配列モード型（id + displayName）

/// 単純な「id + displayName」を持つ配列モード用のデフォルト実装。
///
/// 例:
/// ```swift
/// let labels = ["One", "Two", "Three"]
/// let modes  = labels.asMBGModes()
/// ```
///
/// そのまま:
/// ```swift
/// @State private var selected = modes.first!
/// MBG(modes: modes, selected: $selected, themeColor: .red)
/// ```
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct MBGArrayMode: MBGArrayModeProtocol {
    public typealias ID = Int

    public let id: Int
    public let displayName: String

    public init(id: Int, title: String) {
        self.id = id
        self.displayName = title
    }
}


// MARK: - String 配列 → MBGArrayMode 配列 変換ヘルパー

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Array where Element == String {
    /// 文字列配列をそのまま MBG 用モード配列に変換するユーティリティ。
    ///
    /// 例:
    /// ```swift
    /// let modes = ["One", "Two", "Three"].asMBGModes()
    /// ```
    func asMBGModes() -> [MBGArrayMode] {
        self.enumerated().map { index, title in
            MBGArrayMode(id: index, title: title)
        }
    }
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
