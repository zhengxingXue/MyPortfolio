//
//  NewsRowView.swift
//  NewsRowView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct NewsRowView: View {
    
    let news: NewsModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(news.source.name)
                            .bold()
                            .font(.body)
                            .lineLimit(1)
                        Text(news.publishedToNow)
                    }
                    Text(news.titleWithoutSource)
                        .font(.body)
                        .lineLimit(3)
                    Text("")
                        .font(.body)
                }
                .foregroundColor(.theme.accent)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                NewsImageView(news: news)
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding()
                
            }
            .padding(.horizontal)
        }
        .padding(.top, 2)
    }
}


struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(news: dev.news)
    }
}
