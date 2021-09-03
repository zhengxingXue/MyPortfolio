//
//  BrowseTabView.swift
//  BrowseTabView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI
import BetterSafariView

struct BrowseTabView: View {
    
    @EnvironmentObject private var browseVM: BrowseTabViewModel
    
    @State private var showOnSafari = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                ForEach(browseVM.allNews) { news in
                    NewsRowView(news: news)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showOnSafari.toggle()
                        }
                        // Sheet or fullScreenCover
                        .fullScreenCover(isPresented: $showOnSafari, content: {
                            loadNews(for: news)
                        })
                }
            }
            .refreshable {
                browseVM.refreshNews()
            }
            .navigationTitle("Browse")
        }
    }
    
    private func loadNews(for news: NewsModel) -> some View {
        SafariView(url: URL(string: news.url.replacingOccurrences(of: "http://", with: "https://"))!)
    }
}

struct BrowseTabView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseTabView()
            .preferredColorScheme(.light)
            .environmentObject(dev.browseVM)
    }
}
