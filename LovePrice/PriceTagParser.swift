//
//  PriceTagParser.swift
//  LovePrice
//
//  値札OCRテキスト（行単位）から「価格」と「容量」を抽出するパーサー。
//  Android版 (tfsapps.lovepriceplus.PriceArAnalyzer) の正規表現ロジックを
//  Swift / NSRegularExpression へ移植したもの。
//

import Foundation
import CoreGraphics

enum PriceTagParser {

    /// OCRで検出された1件のテキスト（金額 or 容量）とその画面上の位置。
    struct DetectedBox: Identifiable {
        let id = UUID()
        /// Vision座標系（原点:左下、0...1に正規化）のバウンディングボックス
        let boundingBox: CGRect
        /// true = 金額、false = 容量
        let isPrice: Bool
        /// 抽出した数値
        let value: Int
    }

    // MARK: - 正規表現パターン

    /// 金額: 数字 + (税抜|税別|本体価格)? + 円
    /// 例: 198円 / 1,280円 / 898 税抜円 / 1,480税別円
    private static let priceSuffixYen = try! NSRegularExpression(
        pattern: "([1-9][0-9,]{0,6})\\s*(?:税抜|税別|本体価格)?\\s*円"
    )

    /// 金額: ¥/￥ + 数字 （例: ¥198, ￥1280）
    private static let pricePrefixYen = try! NSRegularExpression(
        pattern: "[¥￥]\\s*([1-9][0-9,]{0,6})"
    )

    /// 税込/税抜/本体価格 が同一行にある場合の数字抽出
    private static let priceTaxLine = try! NSRegularExpression(
        pattern: "([1-9][0-9,]{0,6})"
    )

    /// 容量: 数字 + 単位
    /// 例: 500g / 350ml / 12個入り / 5本
    private static let volumePattern = try! NSRegularExpression(
        pattern: "([1-9][0-9]{0,5})\\s*(?:g|ｇ|Ｇ|グラム|ml|ｍｌ|ミリリットル|mL|ｍＬ|㎖|㎝|cc|ｃｃ|個|本|枚|袋|食|人前|パック|切)"
    )

    /// 金額認識行判定: 税関連キーワード
    private static let taxKeywords = try! NSRegularExpression(
        pattern: "税込|税抜|本体価格|税別|消費税"
    )

    /// 日付パターン。この行を含む場合は金額抽出をスキップする。
    /// 例: 「6月30日」の「30」を価格と誤認識するのを防ぐ。
    private static let datePattern = try! NSRegularExpression(
        pattern: "[0-9]+月[0-9]+日"
    )

    // MARK: - Public API

    /// 1行のテキストから金額を抽出する。
    /// 優先順位: ①「円」サフィックス ②「¥/￥」プレフィックス ③税関連キーワード行
    static func extractPrice(from text: String) -> Int? {
        if firstMatch(datePattern, in: text) != nil { return nil }

        if let value = bestNumericMatch(priceSuffixYen, in: text, group: 1, validate: isPriceInRange) {
            return value
        }
        if let value = bestNumericMatch(pricePrefixYen, in: text, group: 1, validate: isPriceInRange) {
            return value
        }
        if firstMatch(taxKeywords, in: text) != nil,
           let value = bestNumericMatch(priceTaxLine, in: text, group: 1, validate: isPriceInRange) {
            return value
        }
        return nil
    }

    /// 1行のテキストから容量を抽出する。
    static func extractVolume(from text: String) -> Int? {
        bestNumericMatch(volumePattern, in: text, group: 1, validate: isVolumeInRange)
    }

    /// 金額として妥当な範囲: 100〜999999円
    private static func isPriceInRange(_ value: Int) -> Bool {
        value >= 100 && value <= 999_999
    }

    /// 容量として妥当な範囲: 1〜99999
    private static func isVolumeInRange(_ value: Int) -> Bool {
        value >= 1 && value <= 99_999
    }

    // MARK: - 正規表現ヘルパー

    private static func firstMatch(_ regex: NSRegularExpression, in text: String) -> NSTextCheckingResult? {
        regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
    }

    /// マッチした候補のうち、範囲チェックを通過した最大値を返す（Android実装と同じ「最大値優先」ロジック）。
    private static func bestNumericMatch(
        _ regex: NSRegularExpression,
        in text: String,
        group: Int,
        validate: (Int) -> Bool
    ) -> Int? {
        let range = NSRange(text.startIndex..., in: text)
        var best: Int?
        regex.enumerateMatches(in: text, range: range) { match, _, _ in
            guard let match, let groupRange = Range(match.range(at: group), in: text) else { return }
            let raw = text[groupRange].replacingOccurrences(of: ",", with: "")
            guard let value = Int(raw), validate(value) else { return }
            if best == nil || value > best! { best = value }
        }
        return best
    }

    /// 2つの数値が「同じ値とみなせるか」を判定する（安定性フィルタ・同一商品チェックで使用）。
    /// Android版 isSimilarValue と同じロジック。
    static func isSimilarValue(_ a: Int, _ b: Int?) -> Bool {
        guard let b else { return false }
        if a == b { return true }
        let diff = abs(a - b)
        let base = min(a, b)
        return diff <= max(1, base / 20)
    }
}
