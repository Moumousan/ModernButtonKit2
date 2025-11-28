//
//  MBGLayoutProtocol.swift
//  ModernButtonKit2Core
//

import SwiftUI

/// 🧩 レイアウト構造定義（UI非依存）
public protocol MBGLayoutProtocol: View {
    // コーナー半径
    var cornerRadius: CGFloat { get }
    // スペーシング
    var spacing: CGFloat { get }
    // サイズ
    var size: CGSize { get }
    // 配置方向
    var orientation: Axis { get }
    // テキスト切り詰め上限
    var truncationLimit: Int? { get }
    // 区切り線の色（UI層で使われるがCoreではColor型を保持）
    var separatorColor: Color { get }
}

/// デフォルト値（UIを含まない）
public extension MBGLayoutProtocol {
    var cornerRadius: CGFloat { 8 }
    var spacing: CGFloat { 8 }
    var size: CGSize { CGSize(width: 80, height: 30) }
    var orientation: Axis { .horizontal }
    var truncationLimit: Int? { nil }
    var separatorColor: Color { .gray.opacity(0.25) }
}
