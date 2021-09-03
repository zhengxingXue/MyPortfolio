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
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                DetailLineChartView(coin: vm.coin)
                    .frame(height: 500)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            
            ListTitleRow(title: "Stats")
            statsVGrid
            
            ListTitleRow(title: "News")
            newsPreviewRows
            newsShowMore
            
        }
        .listStyle(.plain)
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(vm.coin.name)
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
            ForEach(0 ..< 10) { index in
                VStack(spacing: 10) {
                    HStack {
                        Text("Placeholder")
                            .font(.callout)
                            .foregroundColor(.theme.secondaryText)
                        Spacer()
                        Text("\(00)")
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
            NewsRowView(news: vm.allNews[index])
        }
    }
    
    private var newsShowMore: some View {
        HStack {
            Text("Show More")
                .font(.callout)
                .foregroundColor(.theme.green)
                .background(NavigationLink("", destination: newsShowMoreDestination).opacity(0))
        }
        .listRowSeparator(.hidden)
    }
    
    private var newsShowMoreDestination: some View {
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
