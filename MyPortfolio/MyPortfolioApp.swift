//
//  MyPortfolioApp.swift
//  MyPortfolio
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

@main
struct MyPortfolioApp: App {
    
    @StateObject private var marketVM = InvestTabViewModel()
    @StateObject private var browseVM = BrowseTabViewModel()
    @StateObject private var accountVM = AccountTabViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent), .font: UIFont.preferredFont(forTextStyle: .largeTitle)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent), .font: UIFont.preferredFont(forTextStyle: .body)]
        UINavigationBar.appearance().barTintColor = UIColor(Color.theme.background)
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some Scene {
        WindowGroup {
            MyPortfolioView()
                .environmentObject(marketVM)
                .environmentObject(browseVM)
                .environmentObject(accountVM)
        }
    }
}
