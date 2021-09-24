//
//  CoinDetailNewsView.swift
//  CoinDetailNewsView
//
//  Created by Jim's MacBook Pro on 9/4/21.
//

import SwiftUI

struct CoinDetailNewsView: View {
    
    @EnvironmentObject private var vm: CoinDetailViewModel
    
    var body: some View {
        List {
            ForEach(vm.allNews) { news in
                NewsRowView(news: news)
            }
        }
        .listStyle(.plain)
        .navigationTitle("\(vm.coin.name) News")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct CoinDetailNewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            CoinDetailNewsView()
//        }
//        .environmentObject(dev.coinDetailVM)
//    }
//}
