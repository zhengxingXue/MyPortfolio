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
    
    init() {
        UITabBar.appearance().barStyle = .black
        UITabBar.appearance().barTintColor = UIColor(Color.theme.background)
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        UITabBar.appearance().clipsToBounds = true
        
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
        }
    }
}
