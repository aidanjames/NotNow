//
//  BaseView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 28/11/2020.
//

/*
 This will serve as the base view - all other views will sit on top of this view.
 */

import SwiftUI

struct BaseView: View {
    let color1 = Color(hex: "e8e8e8")
    let color2 = Color(hex: "f05454")
    let color3 = Color(hex: "30475e")
    let color4 = Color(hex: "222831")
    
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [color2, color1]), center: .center, startRadius: 2, endRadius: 650)
            .ignoresSafeArea()
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
