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

    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        let scroll_height = CGFloat(height/100*35)
        let keyboard_height = CGFloat(height/100*50)

        let item_height = CGFloat(height/100*6)
        let item_width = CGFloat(width/100*40)
        let title_height = CGFloat(height/100*6)
        let title_width = CGFloat(width/100*25)
        let element_height = CGFloat(height/100*7)

        let button_weight =  CGFloat(width/100*25)
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
                
                ScrollView {
                    //価格
                    HStack{
                        Button("") {
                            Price_A()
                            
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 0 ? Color.orange : Color.gray, lineWidth: 3))
                        
                        VStack{
                            Text("価格")
                            Image(systemName: "yensign.circle")
                        }
                        .frame(height: title_height )
                        .frame(width: title_width )
                        
                        Button("") {
                            Price_B()
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 1 ? Color.orange : Color.gray, lineWidth: 3))
                    }
                    .frame(height: element_height)
                    .padding(.horizontal)
                    
                    //容量
                    HStack{
                        Button("") {
                            Capacity_A()
                            
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 2 ? Color.orange : Color.gray, lineWidth: 3))
                        
                        VStack{
                            Text("容量")
                            Image(systemName: "waterbottle")
                        }
                        .frame(height: title_height )
                        .frame(width: title_width )
                        
                        Button("") {
                            Capacity_B()
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 3 ? Color.orange : Color.gray, lineWidth: 3))
                    }
                    .frame(height: element_height)
                    .padding(.horizontal)
                    
                    //数量
                    HStack{
                        Button("") {
                            Quantity_A()
                            
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 4 ? Color.orange : Color.gray, lineWidth: 3))
                        
                        VStack{
                            Text("数量")
                            Image(systemName: "carrot")
                        }
                        .frame(height: title_height )
                        .frame(width: title_width )
                        
                        Button("") {
                            Quantity_B()
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 5 ? Color.orange : Color.gray, lineWidth: 3))
                    }
                    .frame(height: element_height)
                    .padding(.horizontal)
                    
                    //ポイント
                    HStack{
                        Button("") {
                            Point_A()
                            
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 4 ? Color.orange : Color.gray, lineWidth: 3))
                        
                        VStack{
                            Text("ﾎﾟｲﾝﾄ")
                            Image(systemName: "menucard")
                        }
                        .frame(height: title_height )
                        .frame(width: title_width )
                        
                        Button("") {
                            Point_B()
                        }
                        .frame(height: item_height )
                        .frame(width: item_width )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(CurIndex == 5 ? Color.orange : Color.gray, lineWidth: 3))
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
                            
                            Button("") {
                                Discount_A()
                            }
                            .frame(height: item_height )
                            .frame(width: item_width )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(CurIndex == 6 ? Color.orange : Color.gray, lineWidth: 3))
                            
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
                            
                            Button("") {
                                Discount_B()
                            }
                            .frame(height: item_height )
                            .frame(width: item_width )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(CurIndex == 7 ? Color.orange : Color.gray, lineWidth: 3))
                            
                        }
                        
                    }
                    .frame(height: element_height * 1.5)
                    .padding(.horizontal)
                }
                .frame(height: scroll_height)
                
            }
            .background(Color(red: 240/255, green: 250/255, blue: 240/255))

            
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
                        Cursor_Prev()
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
            }
            .frame(height: keyboard_height)
            
        }
        
        Spacer()
    }
    
    func Capacity_A(){
        
    }
    func Capacity_B(){
        
    }
    func Quantity_A(){
        
    }
    func Quantity_B(){
        
    }
    func Price_A(){
        
    }
    func Price_B(){
        
    }
    func Point_A(){
        
    }
    func Point_B(){
        
    }
    func Discount_A(){
        
    }
    func Discount_B(){
        
    }
    func Num_00(){
        
    }
    func Num_0(){
        
    }
    func Num_1(){
        
    }
    func Num_2(){
        
    }
    func Num_3(){
        
    }
    func Num_4(){
        
    }
    func Num_5(){
        
    }
    func Num_6(){
        
    }
    func Num_7(){
        
    }
    func Num_8(){
        
    }
    func Num_9(){
        
    }
    func Cursor_Next(){
        
    }
    func Cursor_Prev(){
        
    }
    func Num_Dot(){
        
    }
    func Num_Delete(){
        
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
