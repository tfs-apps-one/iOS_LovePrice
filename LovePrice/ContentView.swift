//
//  ContentView.swift
//  LovePrice
//
//  Created by 古川貴史 on 2024/09/07.
//

import SwiftUI
import GoogleMobileAds


struct ContentView: View {
    
    @State var CurIndex:Int = 0
    @State var isWhitch:Int = 0
    @State private var discount_type_A = "1"
    @State private var discount_type_B = "1"

    @State var input_data:String = "";
    @State var price_a:String = "";
    @State var price_b:String = "";
    @State var capacity_a:String = "";
    @State var capacity_b:String = "";
    @State var quantity_a:String = "";
    @State var quantity_b:String = "";
    @State var point_a:String = "";
    @State var point_b:String = "";
    @State var discount_a:String = "";
    @State var discount_b:String = "";
    @State var unit_price_a:String = "単位価格？";
    @State var unit_price_b:String = "単位価格？";

    // AR一発入力モード
    @State private var showARScanner = false
    // ARスキャンボタンのタップ回数（7回ごとに全面広告を1回表示するためのカウンタ）
    // @AppStorage で UserDefaults に永続化し、アプリを終了して再起動しても
    // 前回の続きからカウントを継続する。
    @AppStorage("arScanTapCount") private var arScanTapCount = 0
    @StateObject private var interstitialAdManager = InterstitialAdManager()

    // 使い方ガイド（？ボタン）
    @State private var showHelp = false

    let buttonPositions: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    // スクロール位置の管理用
    @State private var sproxy: ScrollViewProxy?
    
    var body: some View {
        let admob_height = CGFloat(50)
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)-Int(admob_height)
        let scroll_height = CGFloat(height/100*32)
        let keyboard_height = CGFloat(height/100*38)

        let item_height2 = CGFloat(height/100*5)
        let item_height = CGFloat(height/100*6)
        let item_width = CGFloat(width/100*38)
        let title_height = CGFloat(height/100*6)
        let title_width = CGFloat(width/100*15)
        let element_height = CGFloat(height/100*7)
        let ar_button_height = CGFloat(height/100*7)

        let button_weight =  CGFloat(width/100*22)
        let button_height =  CGFloat(height/100*8)

        VStack(spacing: 6){
            
            VStack{
                /*===========================================================
                 上部
                 ===========================================================*/
                //単価
                HStack{
                    Group {
                        if #available(iOS 16.0, *) {
                            Label(unit_price_a, systemImage: "")
                                .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textSecondary)
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .font(.title2)
                                .underline(true, color: isWhitch == 1 ? AppTheme.coral : AppTheme.textSecondary)
                        } else {
                            // Fallback on earlier versions
                            Label(unit_price_a, systemImage: "")
                                .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textSecondary)
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .font(.title2)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isWhitch == 1 ? AppTheme.coralLight : Color.clear))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(AppTheme.coral, lineWidth: isWhitch == 1 ? 3 : 0))
                    .shadow(color: isWhitch == 1 ? AppTheme.coral.opacity(0.45) : .clear, radius: 8, x: 0, y: 2)
                    .scaleEffect(isWhitch == 1 ? 1.08 : 1.0)
                    .overlay(
                        Group {
                            if isWhitch == 1 {
                                dealBadge(color: AppTheme.coral)
                                    .offset(x: -8, y: -10)
                            }
                        },
                        alignment: .topLeading)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isWhitch)

                    VStack{
                        Text("お得")
                        Image(systemName: "yensign")
                    }
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(height: title_height )
                    .frame(width: title_width )

                    Group {
                        if #available(iOS 16.0, *) {
                            Label(unit_price_b, systemImage: "")
                                .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textSecondary)
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .font(.title2)
                                .underline(true, color: isWhitch == 2 ? AppTheme.indigo : AppTheme.textSecondary)
                        } else {
                            // Fallback on earlier versions
                            Label(unit_price_b, systemImage: "")
                                .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textSecondary)
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .font(.title2)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isWhitch == 2 ? AppTheme.indigoLight : Color.clear))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(AppTheme.indigo, lineWidth: isWhitch == 2 ? 3 : 0))
                    .shadow(color: isWhitch == 2 ? AppTheme.indigo.opacity(0.45) : .clear, radius: 8, x: 0, y: 2)
                    .scaleEffect(isWhitch == 2 ? 1.08 : 1.0)
                    .overlay(
                        Group {
                            if isWhitch == 2 {
                                dealBadge(color: AppTheme.indigo)
                                    .offset(x: 8, y: -10)
                            }
                        },
                        alignment: .topTrailing)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isWhitch)
                }
                .frame(height: element_height)
                .padding(.horizontal)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        //価格
                        HStack{
                            Button(action: {
                                Price_A()
                            }){
                                Text(price_a)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textPrimary)
                                    .id(buttonPositions[0])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 0 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 0 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 0 ? 3 : 1.5))
                            }
                            VStack{
                                Text("価格")
                                Image(systemName: "yensign.circle")
                            }
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(height: title_height )
                            .frame(width: title_width )

                            Button(action: {
                                Price_B()
                            }){
                                Text(price_b)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textPrimary)
                                    .id(buttonPositions[1])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 1 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 1 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 1 ? 3 : 1.5))
                            }
                        }
                        .frame(height: element_height)
                        .padding(.horizontal)
                        
                        //容量
                        HStack{
                            Button(action : {
                                Capacity_A()
                            }){
                                Text(capacity_a)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textPrimary)
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 2 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 2 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 2 ? 3 : 1.5))
                            }
                            VStack{
                                Text("容量")
                                Image(systemName: "waterbottle")
                            }
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(height: title_height )
                            .frame(width: title_width )

                            Button(action: {
                                Capacity_B()
                            }){
                                Text(capacity_b)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textPrimary)
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 3 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 3 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 3 ? 3 : 1.5))
                            }
                        }
                        .frame(height: element_height)
                        .padding(.horizontal)
                        
                        //数量
                        HStack{
                            Button(action: {
                                Quantity_A()
                                
                            }){
                                Text(quantity_a)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textPrimary)
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 4 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 4 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 4 ? 3 : 1.5))
                            }
                            VStack{
                                Text("数量")
                                Image(systemName: "carrot")
                            }
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(height: title_height )
                            .frame(width: title_width )

                            Button(action : {
                                Quantity_B()
                            }){
                                Text(quantity_b)
                                .font(.title2)
                                .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textPrimary)
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(CurIndex == 5 ? AppTheme.amberLight : AppTheme.background))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(CurIndex == 5 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 5 ? 3 : 1.5))
                            }
                        }
                        .frame(height: element_height)
                        .padding(.horizontal)
                        
                        //ポイント
                        HStack{
                            Button(action : {
                                Point_A()
                            }){
                                Text(point_a)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textPrimary)
                                    .id(buttonPositions[6])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 6 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 6 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 6 ? 3 : 1.5))
                            }
                            VStack{
                                Text("ﾎﾟｲﾝﾄ")
                                Image(systemName: "menucard")
                            }
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(height: title_height )
                            .frame(width: title_width )

                            Button(action : {
                                Point_B()
                            }){
                                Text(point_b)
                                .font(.title2)
                                .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textPrimary)
                                .id(buttonPositions[7])
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(CurIndex == 7 ? AppTheme.amberLight : AppTheme.background))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(CurIndex == 7 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 7 ? 3 : 1.5))
                            }
                        }
                        .frame(height: element_height)
                        .padding(.horizontal)
                        
                        //割引き
                        
                        HStack{
                            VStack {
                                // ラジオボタン風のPicker
                                Picker("割引き", selection: $discount_type_A) {
                                    Text("％").tag("1")
                                    Text("ー円").tag("2")
                                }
                                .frame(width: item_width )
                                .pickerStyle(SegmentedPickerStyle())
                                
                                // ラジオボタンスタイルを適用
                                // 選択された値を表示
                                //                Text("選択中: \(discount_type_A)")
                                //                    .padding()
                                
                                Button(action : {
                                    Discount_A()
                                }){
                                    Text(discount_a)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 1 ? AppTheme.coral : AppTheme.textPrimary)
                                    .id(buttonPositions[8])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 8 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 8 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 8 ? 3 : 1.5))
                                }
                            }

                            VStack{
                                Text("割引")
                                Image(systemName: "minus.circle")
                            }
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(height: title_height * 1.5 )
                            .frame(width: title_width )
                            
                            
                            VStack {
                                // ラジオボタン風のPicker
                                Picker("割引き", selection: $discount_type_B) {
                                    Text("％").tag("1")
                                    Text("ー円").tag("2")
                                }
                                .frame(width: item_width )
                                .pickerStyle(SegmentedPickerStyle()) // ラジオボタンスタイルを適用
                                // 選択された値を表示
                                //                Text("選択中: \(discount_type_A)")
                                //                    .padding()
                                
                                Button(action : {
                                    Discount_B()
                                }){
                                    Text(discount_b)
                                    .font(.title2)
                                    .foregroundColor(isWhitch == 2 ? AppTheme.indigo : AppTheme.textPrimary)
                                    .id(buttonPositions[9])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(CurIndex == 9 ? AppTheme.amberLight : AppTheme.background))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 9 ? AppTheme.amber : AppTheme.cardBorder, lineWidth: CurIndex == 9 ? 3 : 1.5))
                                }
                            }
                            
                        }
                        .frame(height: element_height * 1.5)
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        
                    }
                    .frame(height: scroll_height)
                    .onAppear{
                        sproxy = proxy
                    }
                }
                
                
            }
            .background(
                // カード状の白背景。ステータスバー裏まで伸ばし、上部の余白を目立たなくする。
                // ※ タップ可能なボタン類はセーフエリアの外に置けない仕様のため、背景色のみ拡張。
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.cardSurface)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                    .ignoresSafeArea(edges: .top)
            )
            .padding(.top, 4)
            .padding(.horizontal, 5)

            
            /*===========================================================
             中部
             ===========================================================*/
            VStack {
                HStack{
                    Button(action: {
                        Trash_A()

                    }){
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(height: item_height2 )
                    .frame(width: item_width )

//                    VStack{
//                        Text("")
//                            .font(.title3)
//                    }
//                    .frame(height: title_height )
//                    .frame(width: title_width )

                    Button(action: {
                        Trash_ALL()

                    }){
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(AppTheme.coral)
                    }
                    .frame(height: item_height2 )
                    .frame(width: item_width/3 )


                    Button(action: {
                        Trash_B()

                    }){
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(height: item_height2 )
                    .frame(width: item_width )
                }
                .frame(height: item_height2)
                .padding(.horizontal)
            }

            /*===========================================================
             ARスキャン（カメラで値札を読み取り、価格・容量を自動入力）
             ===========================================================*/
            Button(action: {
                // 7回タップするごとに、AR画面を開く前に全面広告を1回表示する。
                arScanTapCount += 1
                if arScanTapCount % 7 == 0 {
                    interstitialAdManager.showAd {
                        showARScanner = true
                    }
                } else {
                    showARScanner = true
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "camera.viewfinder")
                    Text("ARスキャン")
                }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: ar_button_height)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.indigo, AppTheme.indigoDark],
                            startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(14)
                    .shadow(color: AppTheme.indigoDark.opacity(0.35), radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal, 24)
            .fullScreenCover(isPresented: $showARScanner) {
                PriceTagScannerView(onFinished: handleARScanResult)
            }

            /*===========================================================
             下部
             ===========================================================*/
            VStack {
                HStack{
                    Button("7") {
                        Num_7()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)


                    Button("8") {
                        Num_8()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button("9") {
                        Num_9()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button("▶︎") {
                        Cursor_Next()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.indigo)
                    .cornerRadius(14)

                }
                .padding(.horizontal)
                
                HStack{
                    Button("4") {
                        Num_4()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)


                    Button("5") {
                        Num_5()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button("6") {
                        Num_6()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button("◀︎") {
                        Cursor_Prev()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.indigo)
                    .cornerRadius(14)

                }
                .padding(.horizontal)

                
                HStack{
                    Button("1") {
                        Num_1()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)


                    Button("2") {
                        Num_2()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button("3") {
                        Num_3()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button("Del") {
                        Num_Delete()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title2)
                    .foregroundColor(.white)
                    .background(AppTheme.coral)
                    .cornerRadius(14)

                }
                .padding(.horizontal)


                HStack{
                    Button("00") {
                        Num_00()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)


                    Button("0") {
                        Num_0()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button(".") {
                        Num_Dot()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(AppTheme.keypadKey)
                    .cornerRadius(14)

                    Button(action: {
                        showHelp = true
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title)
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .foregroundColor(.white)
                    .background(AppTheme.amber)
                    .cornerRadius(14)
                    .sheet(isPresented: $showHelp) {
                        HelpView()
                    }

                }
                .padding(.horizontal)

            }
            .frame(height: keyboard_height)
            .background(AppTheme.keypadBackground)
            .cornerRadius(20)
            .padding(.horizontal, 5)


            //広告
            BannerAdView()
            .frame(width: GADAdSizeBanner.size.width, height:
                  GADAdSizeBanner.size.height)

//            Text("  ")
//                .frame(height: admob_height)

        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    /**************************************************
     * お得判定バッジ
     *  勝っている側の単位価格ボックスの角に添えるリボン状バッジ。
     *************************************************/
    private func dealBadge(color: Color) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
            Text("お得!")
        }
        .font(.system(size: 11, weight: .heavy))
        .foregroundColor(.white)
        .padding(.horizontal, 7)
        .padding(.vertical, 3)
        .background(color)
        .clipShape(Capsule())
        .shadow(color: color.opacity(0.5), radius: 3, x: 0, y: 2)
    }

    func Calculation(){
        var pri_a:Double = 0
        var pri_b:Double = 0
        var capa_a:Double = 0
        var capa_b:Double = 0
        var quan_a:Double = 0
        var quan_b:Double = 0
        var poi_a:Double = 0
        var poi_b:Double = 0
        var dis_a:Double = 0
        var dis_b:Double = 0
        var tmp_a:Double = 0
        var tmp_b:Double = 0
        
                
        if price_a.isEmpty == false {
            if let tmp = Double(price_a){
                pri_a = tmp
            }
            else{
                pri_a = 0;
            }
        }
        if price_b.isEmpty == false {
            if let tmp = Double(price_b){
                pri_b = tmp
            }
            else{
                pri_b = 0;
            }
        }
        if capacity_a.isEmpty == false {
            if let tmp = Double(capacity_a){
                capa_a = tmp
            }
            else{
                capa_a = 0;
            }
        }
        if capacity_b.isEmpty == false {
            if let tmp = Double(capacity_b){
                capa_b = tmp
            }
            else{
                capa_b = 0;
            }
        }
        if quantity_a.isEmpty == false {
            if let tmp = Double(quantity_a){
                quan_a = tmp
            }
            else{
                quan_a = 0;
            }
        }
        if quantity_b.isEmpty == false {
            if let tmp = Double(quantity_b){
                quan_b = tmp
            }
            else{
                quan_b = 0;
            }
        }
        if point_a.isEmpty == false {
            if let tmp = Double(point_a){
                poi_a = tmp
            }
            else{
                poi_a = 0;
            }
        }
        if point_b.isEmpty == false {
            if let tmp = Double(point_b){
                poi_b = tmp
            }
            else{
                poi_b = 0;
            }
        }
        if discount_a.isEmpty == false {
            if let tmp = Double(discount_a){
                dis_a = tmp
            }
            else{
                dis_a = 0;
            }
        }
        if discount_b.isEmpty == false {
            if let tmp = Double(discount_b){
                dis_b = tmp
            }
            else{
                dis_b = 0;
            }
        }

        //計算に必要な入力必須項目のチェック
        if pri_a <= 0 || (capa_a <= 0 && quan_a <= 0) ||
            pri_b <= 0 || (capa_b <= 0 && quan_b <= 0) {
            unit_price_a = "単位価格？"
            unit_price_b = "単位価格？"
            isWhitch = 0
            return
        }
        
        tmp_a = pri_a
        tmp_b = pri_b
        
        //数量を計算に考慮
        if quan_a > 0 {
            tmp_a = (tmp_a / quan_a)
        }
        if quan_b > 0 {
            tmp_b = (tmp_b / quan_b)
        }

//        if tmp_a <= 0 || tmp_b <= 0 {
//            return
//        }
        //容量を計算に考慮
        if capa_a > 0 {
            tmp_a = (tmp_a / capa_a)
        }
        if capa_b > 0 {
            tmp_b = (tmp_b / capa_b)
        }
        
        var tmp_dis_a:Double = 0
        var tmp_dis_b:Double = 0

        //割引き
        if dis_a > 0 {
            if discount_type_A == "1" {
                tmp_dis_a = pri_a * dis_a
                tmp_dis_a = tmp_dis_a / 100
                tmp_a = tmp_a - tmp_dis_a
            }
            else if discount_type_A == "2" {
                tmp_a = tmp_a - dis_a
            }
        }
        if dis_b > 0 {
            if discount_type_B == "1" {
                tmp_dis_b = pri_b * dis_b
                tmp_dis_b = tmp_dis_b / 100
                tmp_b = tmp_b - tmp_dis_b
            }
            else if discount_type_B == "2" {
                tmp_b = tmp_b - dis_b
            }
        }

        
        //ポイントを計算に考慮
        if poi_a > 0 {
            tmp_a = tmp_a - poi_a
        }
        if poi_b > 0 {
            tmp_b = tmp_b - poi_b
        }
        
        let tmp_a_str = String(format: "%.2f", tmp_a)
        unit_price_a = tmp_a_str
        let tmp_b_str = String(format: "%.2f", tmp_b)
        unit_price_b = tmp_b_str

        //結果
        if tmp_a < tmp_b {
            isWhitch = 1
        }
        else if tmp_b < tmp_a {
            isWhitch = 2
        }
        else {
            isWhitch = 0
        }

    }

    /**************************************************
     * ARスキャン結果の反映
     *  Android版 MainActivity.onArResult() に相当。
     *  取得できた値だけをセットし（未取得はnilのまま既存値を保持）、
     *  自動的に単価計算を行う。
     *************************************************/
    func handleARScanResult(_ result: PriceTagScanResult?) {
        // スキャナー側のdismissに加えて、こちらからも確実にfullScreenCoverを閉じる。
        showARScanner = false

        guard let result else { return } // キャンセル時はここで終了

        if let priceA = result.priceA {
            price_a = String(priceA)
        }
        if let volumeA = result.volumeA {
            capacity_a = String(volumeA)
        }
        if let priceB = result.priceB {
            price_b = String(priceB)
        }
        if let volumeB = result.volumeB {
            capacity_b = String(volumeB)
        }

        Calculation()
    }

    func NumDataInput(){
        //cursorによってswitch caseでデータセット
        switch CurIndex {
        case 0: //価格A
            if input_data.contains(".") == true && price_a.contains(".") == true {
                break;
            }
            price_a += input_data
            break;
        case 1: //価格B
            if input_data.contains(".") == true && price_b.contains(".") == true {
                break;
            }
            price_b += input_data
            break;
        case 2: //容量A
            if input_data.contains(".") == true && capacity_a.contains(".") == true {
                break;
            }
            capacity_a += input_data
            break;
        case 3: //容量B
            if input_data.contains(".") == true && capacity_b.contains(".") == true {
                break;
            }
            capacity_b += input_data
            break;
        case 4: //数量A
            if input_data.contains(".") == true && quantity_a.contains(".") == true {
                break;
            }
            quantity_a += input_data
            break;
        case 5: //数量B
            if input_data.contains(".") == true && quantity_b.contains(".") == true {
                break;
            }
            quantity_b += input_data
            break;
        case 6: //ポイントA
            if input_data.contains(".") == true && point_a.contains(".") == true {
                break;
            }
            point_a += input_data
            break;
        case 7: //ポイントB
            if input_data.contains(".") == true && point_b.contains(".") == true {
                break;
            }
            point_b += input_data
            break;
        case 8: //割引きA
            if input_data.contains(".") == true && discount_a.contains(".") == true {
                break;
            }
            discount_a += input_data
            break;
        case 9: //割引きB
            if input_data.contains(".") == true && discount_b.contains(".") == true {
                break;
            }
            discount_b += input_data
            break;

        default:
            break;
            
        }
        
        input_data = ""

        Calculation()
        //画面表示更新
        //計算処理
        
    }
    
    func Capacity_A(){
        Cursor_Change(type:0, tmpindex:2)
    }
    func Capacity_B(){
        Cursor_Change(type:0, tmpindex:3)
    }
    func Quantity_A(){
        Cursor_Change(type:0, tmpindex:4)
    }
    func Quantity_B(){
        Cursor_Change(type:0, tmpindex:5)
    }
    func Price_A(){
        Cursor_Change(type:0, tmpindex:0)
    }
    func Price_B(){
        Cursor_Change(type:0, tmpindex:1)
    }
    func Point_A(){
        Cursor_Change(type:0, tmpindex:6)
    }
    func Point_B(){
        Cursor_Change(type:0, tmpindex:7)
    }
    func Discount_A(){
        Cursor_Change(type:0, tmpindex:8)
    }
    func Discount_B(){
        Cursor_Change(type:0, tmpindex:9)
    }
    func Trash_A(){
        price_a = ""
        capacity_a = ""
        quantity_a = ""
        point_a = ""
        discount_a = ""
        unit_price_a = "単位価格？"
        isWhitch = 0
    }
    func Trash_B(){
        price_b = ""
        capacity_b = ""
        quantity_b = ""
        point_b = ""
        discount_b = ""
        unit_price_b = "単位価格？"
        isWhitch = 0
    }
    func Trash_ALL(){
        Trash_B()
        Trash_A()
        CurIndex = 0
    }

    func Num_00(){
        input_data += "00"
        NumDataInput()
    }
    func Num_0(){
        input_data += "0"
        NumDataInput()
    }
    func Num_1(){
        input_data += "1"
        NumDataInput()
    }
    func Num_2(){
        input_data += "2"
        NumDataInput()
    }
    func Num_3(){
        input_data += "3"
        NumDataInput()
    }
    func Num_4(){
        input_data += "4"
        NumDataInput()
    }
    func Num_5(){
        input_data += "5"
        NumDataInput()
    }
    func Num_6(){
        input_data += "6"
        NumDataInput()
    }
    func Num_7(){
        input_data += "7"
        NumDataInput()
    }
    func Num_8(){
        input_data += "8"
        NumDataInput()
    }
    func Num_9(){
        input_data += "9"
        NumDataInput()
    }
    func Cursor_Change(type:Int, tmpindex:Int){
        switch type {
        case 0:  CurIndex = tmpindex 
            break;
        case 1: CurIndex = CurIndex + 1
            break;
        case 2: CurIndex = CurIndex - 1
            break
        default:
            break;
        }
        if CurIndex > 9 {
            CurIndex = 0
        }
        else if (CurIndex < 0){
            CurIndex = 9
        }
        
        if CurIndex < 6 {
            withAnimation {
                sproxy?.scrollTo(buttonPositions[0], anchor: .center)
            }
        }
//        else if CurIndex < 8 {
//            withAnimation {
//                sproxy?.scrollTo(buttonPositions[6], anchor: .center)
//            }
//        }
        else{
            withAnimation {
                sproxy?.scrollTo(buttonPositions[8], anchor: .center)
            }
        }
        
    }
    func Cursor_Next(){
        Cursor_Change(type:1, tmpindex:0)
    }
    func Cursor_Prev(){
        Cursor_Change(type:2, tmpindex:0)
    }
    func Num_Dot(){
        input_data += "."
        NumDataInput()
    }
    func Num_Delete(){
        
        var tmpstr = ""
        
        switch CurIndex {
        case 0: //価格A
            if price_a.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(price_a.dropLast())
                price_a = tmpstr
            }
            break;
        case 1: //価格B
            if price_b.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(price_b.dropLast())
                price_b = tmpstr
            }
            break;
        case 2: //容量A
            if capacity_a.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(capacity_a.dropLast())
                capacity_a = tmpstr
            }
            break;
        case 3: //容量B
            if capacity_b.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(capacity_b.dropLast())
                capacity_b = tmpstr
            }
            break;
        case 4: //数量A
            if quantity_a.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(quantity_a.dropLast())
                quantity_a = tmpstr
            }
            break;
        case 5: //数量B
            if quantity_b.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(quantity_b.dropLast())
                quantity_b = tmpstr
            }
            break;
        case 6: //ポイントA
            if point_a.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(point_a.dropLast())
                point_a = tmpstr
            }
            break;
        case 7: //ポイントB
            if point_b.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(point_b.dropLast())
                point_b = tmpstr
            }
            break;
        case 8: //ポイントA
            if discount_a.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(discount_a.dropLast())
                discount_a = tmpstr
            }
            break;
        case 9: //ポイントB
            if discount_b.isEmpty == true {
                return;
            }
            else{
                tmpstr = String(discount_b.dropLast())
                discount_b = tmpstr
            }
            break;

        default:
            break;
        }
        
        Calculation()
    }
    
    func Num_Empty(){
        
    }
    


}

//extension ContentView {
//    
//
//    @ViewBuilder
//    private var PriceArea : some View {
//        
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//#Preview {
//    ContentView()
//}
