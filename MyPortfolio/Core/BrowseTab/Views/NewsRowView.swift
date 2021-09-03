//
//  NewsRowView.swift
//  NewsRowView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI
import BetterSafariView

struct NewsRowView: View {
    
    let news: NewsModel
    
    @State private var showOnSafari = false
    
    var body: some View {
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
        .padding(.top, 2)
        .onTapGesture {
            showOnSafari.toggle()
        }
        // Sheet or fullScreenCover
        .fullScreenCover(isPresented: $showOnSafari, content: {
            loadNews(for: news)
        })
    }
    
    private func loadNews(for news: NewsModel) -> some View {
        SafariView(url: URL(string: news.url.replacingOccurrences(of: "http://", with: "https://"))!)
    }
}


struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(news: dev.news)
    }
}
