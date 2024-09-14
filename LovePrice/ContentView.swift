//
//  ContentView.swift
//  LovePrice
//
//  Created by 古川貴史 on 2024/09/07.
//

import SwiftUI

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

    
    let buttonPositions: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    // スクロール位置の管理用
    @State private var sproxy: ScrollViewProxy?
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)-50
        let scroll_height = CGFloat(height/100*30)
        let keyboard_height = CGFloat(height/100*40)

        let item_height2 = CGFloat(height/100*5)
        let item_height = CGFloat(height/100*6)
        let item_width = CGFloat(width/100*38)
        let title_height = CGFloat(height/100*6)
        let title_width = CGFloat(width/100*15)
        let element_height = CGFloat(height/100*7)

        let button_weight =  CGFloat(width/100*22)
        let button_height =  CGFloat(height/100*8)
 
        VStack{
            
            VStack{
                /*===========================================================
                 上部
                 ===========================================================*/
                //単価
                HStack{
                    Label("120", systemImage: isWhitch == 0 ? "star.fill" : "" )
                        .foregroundColor(isWhitch == 0 ? Color.red : Color.gray)
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .font(.title)
                        .underline(true, color: isWhitch == 0 ? Color.red : Color.gray)
                    
                    VStack{
                        Text("お得")
                        Image(systemName: "yensign")
                    }
                    .frame(height: title_height )
                    .frame(width: title_width )
                    
                    Label("110", systemImage: isWhitch == 1 ? "star.fill" : "" )
                        .foregroundColor(isWhitch == 1 ? Color.red : Color.gray)
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .font(.title)
                        .underline(true, color: isWhitch == 1 ? Color.red : Color.gray)
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
                                    .id(buttonPositions[0])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 0 ? Color.orange : Color.gray, lineWidth: 3))
                            }
                            VStack{
                                Text("価格")
                                Image(systemName: "yensign.circle")
                            }
                            .frame(height: title_height )
                            .frame(width: title_width )
                            
                            Button(action: {
                                Price_B()
                            }){
                                Text(price_b)
                                    .id(buttonPositions[1])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 1 ? Color.orange : Color.gray, lineWidth: 3))
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
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 2 ? Color.orange : Color.gray, lineWidth: 3))
                            }
                            VStack{
                                Text("容量")
                                Image(systemName: "waterbottle")
                            }
                            .frame(height: title_height )
                            .frame(width: title_width )
                            
                            Button(action: {
                                Capacity_B()
                            }){
                                Text(capacity_b)
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 3 ? Color.orange : Color.gray, lineWidth: 3))
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
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 4 ? Color.orange : Color.gray, lineWidth: 3))
                            }
                            VStack{
                                Text("数量")
                                Image(systemName: "carrot")
                            }
                            .frame(height: title_height )
                            .frame(width: title_width )
                            
                            Button(action : {
                                Quantity_B()
                            }){
                                Text(quantity_b)
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(CurIndex == 5 ? Color.orange : Color.gray, lineWidth: 3))
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
                                    .id(buttonPositions[6])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 6 ? Color.orange : Color.gray, lineWidth: 3))
                            }
                            VStack{
                                Text("ﾎﾟｲﾝﾄ")
                                Image(systemName: "menucard")
                            }
                            .frame(height: title_height )
                            .frame(width: title_width )
                            
                            Button(action : {
                                Point_B()
                            }){
                                Text(point_b)
                                .id(buttonPositions[7])
                                .frame(height: item_height )
                                .frame(width: item_width )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(CurIndex == 7 ? Color.orange : Color.gray, lineWidth: 3))
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
                                    .id(buttonPositions[8])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 8 ? Color.orange : Color.gray, lineWidth: 3))
                                }
                            }
                            
                            VStack{
                                Text("割引")
                                Image(systemName: "minus.circle")
                            }
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
                                    .id(buttonPositions[9])
                                    .frame(height: item_height )
                                    .frame(width: item_width )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(CurIndex == 9 ? Color.orange : Color.gray, lineWidth: 3))
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
            .background(Color(red: 255/255, green: 255/255, blue: 220/255))
            .padding(.top, 10)
            .padding(.horizontal, 5)
//            .background(Color(red: 240/255, green: 255/255, blue: 240/255))

            
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
                            .foregroundColor(Color(red: 55/255, green: 55/255, blue: 55/255))
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
                            .foregroundColor(Color(red: 200/255, green: 55/255, blue: 55/255))
                    }
                    .frame(height: item_height2 )
                    .frame(width: item_width/3 )
                    
                    
                    Button(action: {
                        Trash_B()
                
                    }){
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(Color(red: 55/255, green: 55/255, blue: 55/255))
                    }
                    .frame(height: item_height2 )
                    .frame(width: item_width )
                }
                .frame(height: item_height)
                .padding(.horizontal)
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
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))
                    
                    
                    Button("8") {
                        Num_8()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("9") {
                        Num_9()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("▶︎") {
                        Cursor_Next()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                }
                .padding(.horizontal)
                
                HStack{
                    Button("4") {
                        Num_4()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))
                    
                    
                    Button("5") {
                        Num_5()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("6") {
                        Num_6()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("◀︎") {
                        Cursor_Prev()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                }
                .padding(.horizontal)

                
                HStack{
                    Button("1") {
                        Num_1()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))
                    
                    
                    Button("2") {
                        Num_2()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("3") {
                        Num_3()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("Del") {
                        Num_Delete()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title2)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                }
                .padding(.horizontal)


                HStack{
                    Button("00") {
                        Num_00()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))
                    
                    
                    Button("0") {
                        Num_0()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button(".") {
                        Num_Dot()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                    Button("") {
                        Num_Empty()
                    }
                    .frame(width: button_weight)
                    .frame(height: button_height)
                    .font(.title2)
                    .foregroundColor(.white) // 文字色を白に
                    .background(Color(red: 75/255, green: 75/255, blue: 75/255))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 3))

                }
                .padding(.horizontal)

            }
            .frame(height: keyboard_height)
            .background(Color(red: 85/255, green: 85/255, blue: 85/255))
            .padding(.horizontal, 5)

            
            Text("広告スペース")
                .frame(height: 50)

        }
        
        Spacer()
    }
    func NumDataInput(){
        //cursorによってswitch caseでデータセット
        switch CurIndex {
        case 0: //価格A
            if input_data.contains(".") == true && price_a.contains(".") == true {
                return;
            }
            price_a += input_data
            break;
        case 1: //価格B
            if input_data.contains(".") == true && price_b.contains(".") == true {
                return;
            }
            price_b += input_data
            break;
        case 2: //容量A
            if input_data.contains(".") == true && capacity_a.contains(".") == true {
                return;
            }
            capacity_a += input_data
            break;
        case 3: //容量B
            if input_data.contains(".") == true && capacity_b.contains(".") == true {
                return;
            }
            capacity_b += input_data
            break;
        case 4: //数量A
            if input_data.contains(".") == true && quantity_a.contains(".") == true {
                return;
            }
            quantity_a += input_data
            break;
        case 5: //数量B
            if input_data.contains(".") == true && quantity_b.contains(".") == true {
                return;
            }
            quantity_b += input_data
            break;
        case 6: //ポイントA
            if input_data.contains(".") == true && point_a.contains(".") == true {
                return;
            }
            point_a += input_data
            break;
        case 7: //ポイントB
            if input_data.contains(".") == true && point_b.contains(".") == true {
                return;
            }
            point_b += input_data
            break;
        case 8: //割引きA
            if input_data.contains(".") == true && discount_a.contains(".") == true {
                return;
            }
            discount_a += input_data
            break;
        case 9: //割引きB
            if input_data.contains(".") == true && discount_b.contains(".") == true {
                return;
            }
            discount_b += input_data
            break;

        default:
            break;
            
        }
        
        input_data = ""

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
    }
    func Trash_B(){
        price_b = ""
        capacity_b = ""
        quantity_b = ""
        point_b = ""
        discount_b = ""
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
