//
//  CoinDetailView.swift
//  CoinDetailView
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import SwiftUI

struct CoinDetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("Init \(coin.name) CoinDetailView")
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                DetailLineChartView(coin: vm.coin, prices: vm.prices)
                    .frame(height: 500)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            
            HStack {
                ListTitleRow(title: "Stats")
                Spacer()
                CustomImageView(coin: vm.coin)
                    .frame(width: 30, height: 30)
            }
            statsVGrid
            
            ListTitleRow(title: "News")
            newsPreviewRows
            newsShowMore
            
        }
        .listStyle(.plain)
        .refreshable { vm.refreshCoin() }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(vm.coin.name)
        .onDisappear {
            vm.updateCoinEntityPrice()
        }
    }
    
    private let columnsHorizontalSpacing: CGFloat = 5
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailView(coin: dev.coin)
        }
    }
}

extension CoinDetailView {
    private var statsVGrid: some View {
        LazyVGrid(columns: columns) {
            ForEach(0 ..< vm.coin.stats.count) { index in
                VStack(spacing: 10) {
                    HStack {
                        Text(vm.coin.stats[index].titleString)
                            .font(.callout)
                            .foregroundColor(.theme.secondaryText)
                        Spacer()
                        Text(vm.coin.stats[index].valueString)
                            .font(.body)
                            .foregroundColor(.theme.accent)
                    }
                    Divider()
                }
                .padding(.trailing, ((index % 2) == 0) ? columnsHorizontalSpacing : 0)
                .padding(.leading, ((index % 2) == 1) ? columnsHorizontalSpacing : 0)
            }
        }
        .listRowSeparator(.hidden)
    }
    
    private var newsPreviewRows: some View {
        ForEach(0 ..< 3) { index in
            if index < vm.allNews.count {
                NewsRowView(news: vm.allNews[index])
            }
        }
    }
    
    private var newsShowMore: some View {
        HStack {
            Text("Show More")
                .font(.callout)
                .foregroundColor(.theme.green)
                .background(NavigationLink("", destination: CoinDetailNewsView().environmentObject(vm)).opacity(0))
        }
        .listRowSeparator(.hidden)
    }
}
