//
//  XMarkButton.swift
//  XMarkButton
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct XMarkButton: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented = false
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(.theme.accent)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(isPresented: .constant(true))
    }
}
