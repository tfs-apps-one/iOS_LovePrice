//
//  AppTheme.swift
//  LovePrice
//
//  アプリ全体で使うカラーパレット・デザイントークンを一箇所に集約したもの。
//  「カラー配分」の一貫性を保つため、画面側は原則としてここで定義した色だけを使う。
//
//  色の役割分担:
//   - indigo系 … ブランドカラー。商品B・ARボタン・ナビゲーション系キーに使用
//   - coral系  … 商品Aのハイライト。削除(全消去)・DELキーなど「注意を引く」操作にも使用
//   - amber系  … 現在選択中の入力欄（フォーカス状態）
//   - neutral系… 背景・カード面・枠線・テキスト
//

import SwiftUI

enum AppTheme {

    // MARK: - ブランド / アクセントカラー

    static let indigo      = Color(red: 61/255,  green: 90/255,  blue: 164/255)
    static let indigoDark  = Color(red: 33/255,  green: 48/255,  blue: 90/255)
    static let indigoLight = Color(red: 228/255, green: 234/255, blue: 248/255)

    static let coral      = Color(red: 224/255, green: 90/255,  blue: 90/255)
    static let coralLight = Color(red: 253/255, green: 231/255, blue: 231/255)

    static let amber      = Color(red: 224/255, green: 156/255, blue: 46/255)
    static let amberLight = Color(red: 255/255, green: 241/255, blue: 219/255)

    // MARK: - ニュートラル（背景・カード・テキスト）

    static let background  = Color(red: 244/255, green: 246/255, blue: 250/255)
    static let cardSurface = Color.white
    static let cardBorder  = Color(red: 226/255, green: 229/255, blue: 235/255)

    static let textPrimary   = Color(red: 30/255,  green: 33/255,  blue: 40/255)
    static let textSecondary = Color(red: 138/255, green: 144/255, blue: 154/255)

    // MARK: - キーパッド

    static let keypadBackground = Color(red: 27/255, green: 29/255, blue: 35/255)
    static let keypadKey        = Color(red: 45/255, green: 48/255, blue: 57/255)
}
