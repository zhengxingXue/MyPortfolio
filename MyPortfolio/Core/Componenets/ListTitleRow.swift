//
//  ListTitleRow.swift
//  ListTitleRow
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import SwiftUI

struct ListTitleRow: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .foregroundColor(.theme.accent)
            .listRowSeparator(.hidden)
            .padding(.bottom)
    }
}

struct ListTitleRow_Previews: PreviewProvider {
    static var previews: some View {
        List(0 ..< 1) { _ in
            ListTitleRow(title: "Hello")
        }
        .listStyle(.plain)
    }
}
