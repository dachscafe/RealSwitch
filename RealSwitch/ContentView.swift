//
//  ContentView.swift
//  RealSwitch
//
//  Created by Cafe on 2023/02/19.
//

import SwiftUI

struct ContentView: View {

    @State var isOn: Bool = true
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            Button {
                isOn.toggle()
                // ここに触覚FBのモジュールとか入れるといい。
            } label: {
                SwitchButtonView(isOn: isOn)
            }
            .buttonStyle(.plain)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
