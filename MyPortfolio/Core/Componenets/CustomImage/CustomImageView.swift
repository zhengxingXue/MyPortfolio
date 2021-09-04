//
//  CustomImageView.swift
//  CustomImageView
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import SwiftUI

struct CustomImageView: View {
    
    @StateObject var vm: CustomImageViewModel
    
    init(news: NewsModel) {
        _vm = StateObject(wrappedValue: CustomImageViewModel(news: news))
    }
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CustomImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryText)
            }
        }
    }
}

struct CustomImageView_Previews: PreviewProvider {
    static var previews: some View {
        CustomImageView(news: dev.news)
            .scaledToFill()
            .frame(width: 100, height: 130)
            .cornerRadius(10)
            .previewLayout(.sizeThatFits)
    }
}

