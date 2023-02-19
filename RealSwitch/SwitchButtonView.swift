//
//  SwitchButtonView.swift
//  RealSwitch
//
//  Created by Cafe on 2023/02/19.
//

import SwiftUI

struct SwitchButtonView: View {
    
    let isOn: Bool
    @State var yOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            //　スイッチの土台
            SwitchFoundationView()
            // スイッチの側面
            SwitchSideView()
            // スイッチの表面
            SwitchToggleView(isOn: isOn)
                .offset(y: isOn ? -6 : 6)
        }
    }
}


struct SwitchBaseColor {
    // 加工したカラー
    let baseColor: Color
    let blackColor: Color
    let darkColor: Color
    let lightColor: Color
    // スイッチのカラー
    let colorSideTop: LinearGradient
    let colorSideBottom: Color
    let colorLighting: Color
    let colorOn: LinearGradient
    let colorOff: LinearGradient
    let colorSwitchEdge: Color
    // スイッチの土台のカラー
    let colorBase : LinearGradient
    let colorFoundationEdge: Color
    
    init () {
        baseColor = Color(red: 1.0, green: 0.0, blue: 0.0)
        blackColor = Color(red: 0.5, green: 0.0, blue: 0.0)
        darkColor = Color(red: 0.7, green: 0.0, blue: 0.0)
        lightColor = Color(red: 1.0, green: 0.5, blue: 0.5)
        colorSideTop = LinearGradient(
            gradient: Gradient(colors: [darkColor, lightColor, darkColor]),
            startPoint: .leading, endPoint: .trailing
        )
        colorSideBottom = blackColor
        colorLighting = lightColor
        colorOn = LinearGradient(
            gradient: Gradient(colors: [lightColor, darkColor]),
            startPoint: .top, endPoint: .bottomTrailing
        )
        colorOff = LinearGradient(
            gradient: Gradient(colors: [blackColor, baseColor]),
            startPoint: .top, endPoint: .bottomTrailing
        )
        colorBase = LinearGradient(
            gradient: Gradient(colors: [Color(UIColor.darkGray), .black]),
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        colorSwitchEdge = Color.white
        colorFoundationEdge = Color.secondary
    }
}

// スイッチの表面
struct SwitchToggleView: View{
    
    let isOn: Bool
    
    private let baseColor = SwitchBaseColor()
    
    private let width: CGFloat = 70
    private let height: CGFloat = 140
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            if isOn {
                Circle()  // ボタンの明かり
                    .fill(baseColor.colorLighting)
                    .frame(width: 100, height: 100)
                    .offset(x: 0, y: -height / 2.5)
                    .blur(radius: 30)
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(baseColor.colorSwitchEdge)
                        .offset(x: 0, y: 1)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(baseColor.colorOn)
                    VStack {
                        Text("ON")
                            .fontWeight(.heavy)
                            .padding()
                            .foregroundColor(baseColor.colorSwitchEdge)
                            .shadow(color: baseColor.colorSwitchEdge, radius: 8, x: 0, y: 0)
                        Spacer()
                        Text("OFF")
                            .fontWeight(.heavy)
                            .padding()
                            .foregroundColor(baseColor.blackColor)
                    }
                }
                .frame(width: width, height: height)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.white)
                        .offset(x: 0, y: -1)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(baseColor.colorOff)
                    VStack {
                        Text("ON")
                            .padding()
                            .fontWeight(.heavy)
                            .foregroundColor(baseColor.blackColor)
                        Spacer()
                        Text("OFF")
                            .padding()
                            .fontWeight(.heavy)
                            .foregroundColor(baseColor.blackColor)
                    }
                }
                .frame(width: width, height: height)
            }
        }
    }
}

// スイッチの側面
struct SwitchSideView: View{
    
    private let width: CGFloat = 70
    private let height: CGFloat = 150
    private let cornerRadius: CGFloat = 10
    private let baseColor = SwitchBaseColor()
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(baseColor.colorSideTop)
                .frame(width: width, height: height / 2)
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(baseColor.colorSideBottom)
                .frame(width: width, height: height / 2)
        }
    }
}

// スイッチの土台
struct SwitchFoundationView: View{
    
    private let width: CGFloat = 120
    private let height: CGFloat = 200
    private let cornerRadius: CGFloat = 10
    
    private let baseColor = SwitchBaseColor()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(baseColor.colorFoundationEdge)
                .frame(width: width + 2, height: height + 2)
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(baseColor.colorBase)
                .frame(width:width, height: height)
        }
    }
}

struct SwitchButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchButtonView(isOn: true)
    }
}
