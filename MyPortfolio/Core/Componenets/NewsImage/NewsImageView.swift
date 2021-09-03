//
//  NewsImageView.swift
//  NewsImageView
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import SwiftUI

struct NewsImageView: View {
    
    @StateObject var vm: NewsImageViewModel
    
    init(news: NewsModel) {
        _vm = StateObject(wrappedValue: NewsImageViewModel(news: news))
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

struct NewsImageView_Previews: PreviewProvider {
    static var previews: some View {
        NewsImageView(news: dev.news)
            .scaledToFill()
            .frame(width: 100, height: 130)
            .cornerRadius(10)
            .previewLayout(.sizeThatFits)
    }
}

