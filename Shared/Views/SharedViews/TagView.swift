//
//  TagView.swift
//  NotNow (iOS)
//
//  Created by Aidan Pendlebury on 02/12/2020.
//

import SwiftUI

struct TagView: View {
    var tagName: String
    var font: Font
    var body: some View {
        Text(tagName)
            .font(font)
            .padding(7)
            .background(Color.blue.opacity(0.5))
            .cornerRadius(16)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tagName: "Email", font: .body)
    }
}
