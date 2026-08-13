//
//  ScanOverlayView.swift
//  LovePrice
//
//  OCR認識結果を、カメラプレビュー上に半透明のハイライトボックスとして描画する
//  オーバーレイ。金額 → 緑、容量 → 水色（Android版 ArOverlayView と同系色）。
//
//  座標変換は Android版 ArOverlayView.transformRect() と同じ考え方（正立画像サイズと
//  プレビュー表示サイズから scale + offset を計算する fillCenter/aspectFill 相当の変換）を
//  そのまま採用している。AVFoundationの `layerRectConverted(fromMetadataOutputRect:)` は
//  カメラ接続の向き設定に依存して挙動が変わりやすいため、あえて使わず自前で計算する。
//

import SwiftUI

// MARK: - ハイライトボックスの配色
// アプリ全体のカラーパレット(AppTheme)に合わせ、金額=amber(注目色)、容量=indigo(ブランドカラー)で統一。
private extension PriceTagParser.DetectedBox {
    var highlightColor: Color { isPrice ? AppTheme.amber : AppTheme.indigo }
}

struct ScanOverlayView: View {
    @ObservedObject var viewModel: PriceTagScannerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(viewModel.boxes) { box in
                    if let rect = Self.viewRect(for: box, frameSize: viewModel.frameSize, viewSize: geometry.size) {
                        boxView(for: box)
                            .frame(width: rect.width, height: rect.height)
                            .position(x: rect.midX, y: rect.midY)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .allowsHitTesting(false)
    }

    /// Vision正規化座標(原点:左下, 0...1) を、`.resizeAspectFill` 表示されたプレビュー上の
    /// 実座標(pt, 原点:左上) へ変換する。
    private static func viewRect(
        for box: PriceTagParser.DetectedBox,
        frameSize: CGSize,
        viewSize: CGSize
    ) -> CGRect? {
        guard frameSize.width > 0, frameSize.height > 0,
              viewSize.width > 0, viewSize.height > 0 else { return nil }

        // fillCenter/aspectFill相当のスケール・オフセット計算
        let scale = max(viewSize.width / frameSize.width, viewSize.height / frameSize.height)
        let offsetX = (viewSize.width - frameSize.width * scale) / 2
        let offsetY = (viewSize.height - frameSize.height * scale) / 2

        // Visionの正規化座標(原点:左下) → 正立画像のpx座標(原点:左上)
        let boxLeftPx = box.boundingBox.origin.x * frameSize.width
        let boxWidthPx = box.boundingBox.width * frameSize.width
        let boxTopPx = (1 - box.boundingBox.origin.y - box.boundingBox.height) * frameSize.height
        let boxHeightPx = box.boundingBox.height * frameSize.height

        var rect = CGRect(
            x: boxLeftPx * scale + offsetX,
            y: boxTopPx * scale + offsetY,
            width: boxWidthPx * scale,
            height: boxHeightPx * scale
        )

        // 画面外にはみ出た分をクリップ（Android版 transformRect と同様）
        rect = rect.intersection(CGRect(origin: .zero, size: viewSize))
        guard !rect.isNull, rect.width > 0, rect.height > 0 else { return nil }
        return rect
    }

    @ViewBuilder
    private func boxView(for box: PriceTagParser.DetectedBox) -> some View {
        let color: Color = box.highlightColor

        ZStack(alignment: .topLeading) {
            Rectangle().fill(color.opacity(0.35))
            Rectangle().strokeBorder(color, lineWidth: 3)

            Text(box.isPrice ? "金額" : "容量")
                .font(.caption2.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.75))
                .cornerRadius(3)
                .offset(y: -20)
        }
    }
}
