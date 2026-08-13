//
//  HelpView.swift
//  LovePrice
//
//  「？」ボタンから開く、アプリ全般の使い方ガイド。
//   ・「どちらがお得」アプリの概要
//   ・手入力の使い方
//   ・ARスキャンの使い方
//  の3セクションで構成する。
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    section(icon: "questionmark.circle.fill", title: "「どちらがお得」とは？", color: AppTheme.amber) {
                        Text("2つの商品の「価格」「容量（内容量）」「数量」「ポイント還元」「割引」を入力すると、実際の単位価格（例：100gあたりの価格）を自動で計算し、どちらの商品がよりお得かをひと目で比較できるアプリです。")
                    }

                    section(icon: "hand.tap.fill", title: "手入力の使い方", color: AppTheme.indigo) {
                        VStack(alignment: .leading, spacing: 10) {
                            bullet("上部の「価格」「容量」「数量」「ﾎﾟｲﾝﾄ」「割引」のボックスをタップして、入力したい項目を選びます。オレンジ色の枠が現在選択中の項目です。")
                            bullet("下のテンキーで数字を入力します。「▶︎」「◀︎」ボタンで次・前の項目へ移動できます。")
                            bullet("商品A・商品Bともに「価格」と「容量」または「数量」を入力すると、自動的に単位価格が計算され、お得な方が色付きでハイライトされます。")
                            bullet("ポイント還元や割引がある場合は、それぞれの欄に入力すると計算に反映されます。")
                            bullet("ゴミ箱アイコンで、商品Aのみ・商品Bのみ・または全体をまとめて消去できます。")
                        }
                    }

                    section(icon: "camera.viewfinder", title: "ARスキャンの使い方", color: AppTheme.coral) {
                        VStack(alignment: .leading, spacing: 10) {
                            bullet("「ARスキャン」ボタンをタップし、カメラへのアクセスを許可してください。")
                            bullet("商品Aの値札にカメラを向けると、価格・容量を自動で読み取ります。")
                            bullet("同じ数値が3回連続で認識されると自動的に確定し、続けて商品Bのスキャンに進みます。")
                            bullet("うまく読み取れない場合は「スキップ」で手入力に切り替えられます。確定後も「再スキャン」でやり直せます。")
                            bullet("⚠️ POPなどの大きな装飾文字は、性能上うまく読み取れない場合があります。その場合は手入力をご利用ください。")
                        }
                    }
                }
                .padding(20)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("使い方ガイド")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.indigo)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    @ViewBuilder
    private func section<Content: View>(
        icon: String,
        title: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            content()
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textPrimary)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.cardBorder, lineWidth: 1)
        )
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("・")
            Text(text)
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    HelpView()
}
