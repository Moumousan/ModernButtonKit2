//
//  SelectableModeProtocol.swift
//  ModernButtonKit2
//
//  Created by SNI on 2026/02/02.
//

//  共通プロトコル拡張Bar系UI：
//  - MBGIconTextStyle
//
//
// - MBGIconTextStyle
//

import Foundation

/// Text–icon relationship for MBG buttons / bars.
///
/// - `titleOnly`     : テキストだけ
/// - `iconOnly`      : アイコンだけ
/// - `iconLeading`   : アイコン＋テキスト（アイコンが先頭）
/// - `iconTrailing`  : テキスト＋アイコン（アイコンが末尾）
public enum MBGIconTextStyle: Sendable {
    case titleOnly
    case iconOnly
    case iconLeading
    case iconTrailing
}
extension MBGIconTextStyle {
    var showsTitle: Bool {
        switch self {
        case .titleOnly:      return true
        case .iconOnly:       return false
        case .iconLeading,
             .iconTrailing:   return true
        }
    }

    var showsIcon: Bool {
        switch self {
        case .titleOnly:      return false
        case .iconOnly,
             .iconLeading,
             .iconTrailing:   return true
        }
    }

    /// MBG の `iconPlacement` にブリッジ
    var iconPlacement: MBGIconPlacement {
        switch self {
        case .titleOnly:
            return .leading    // 何でもいいが未使用想定
        case .iconOnly:
            return .leading    // 同上
        case .iconLeading:
            return .leading
        case .iconTrailing:
            return .trailing
        }
    }
}
