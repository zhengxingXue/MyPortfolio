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
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { news in
                    NewsRowView(news: news)
                }
            }
            .refreshable { browseVM.refreshNews() }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(.plain)
            .navigationTitle("Browse")
        }
    }
    
    private var searchResults: [NewsModel] {
        if searchText.isEmpty {
            return browseVM.allNews
        } else {
            let lowercasedText = searchText.lowercased()
            return browseVM.allNews.filter { $0.title.lowercased().contains(lowercasedText) || $0.source.name.lowercased().contains(lowercasedText) }
        }
    }
}

struct BrowseTabView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseTabView()
            .preferredColorScheme(.light)
            .environmentObject(dev.browseVM)
    }
}
