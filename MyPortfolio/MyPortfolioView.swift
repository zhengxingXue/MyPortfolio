//
//  MyPortfolioView.swift
//  MyPortfolio
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct MyPortfolioView: View {
    
    @EnvironmentObject private var marketVM: InvestTabViewModel
    @EnvironmentObject private var browseVM: BrowseTabViewModel
    
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            InvestTabView()
                .environmentObject(marketVM)
                .tabItem {
                    Image(systemName: "heart.fill")
                }
                .tag(0)
            
            BrowseTabView()
                .environmentObject(browseVM)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            
            Text("The content of the third view")
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.theme.accent)
    }
}

struct MyPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        MyPortfolioView()
            .preferredColorScheme(.light)
        MyPortfolioView()
            .preferredColorScheme(.dark)
    }
}
