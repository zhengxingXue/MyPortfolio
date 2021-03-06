//
//  InvestTabView.swift
//  InvestTabView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct InvestTabView: View {
    
    @EnvironmentObject private var marketVM: InvestTabViewModel
    
    @State private var showOrderCoinView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                
                overviewView
                
                // notesScrollView
                
                portfolioView
                
                ListTitleRow(title: "List")
                cryptoListTitle
                if !marketVM.isLoading && marketVM.allCoins.count > 0 {
                    ForEach(marketVM.savedCoinIndices, id: \.self) { coinIndex in
                        CoinRowView(coin: marketVM.allCoins[coinIndex], isEditing: .constant(false))
                    }
                    .onDelete(perform: marketVM.delete(at:))
                }
                
            }
            .refreshable {
                marketVM.refreshAllCoins()
            }
            .listStyle(.plain)
            .navigationTitle("Investing")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showOrderCoinView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showOrderCoinView) {
                        OrderCoinView(showOrderCoinView: $showOrderCoinView)
                            .environmentObject(marketVM)
                    }
                }
            }
        }
    }
}

struct InvestTabView_Previews: PreviewProvider {
    static var previews: some View {
        InvestTabView()
            .environmentObject(dev.marketVM)
            .preferredColorScheme(.light)
        InvestTabView()
            .environmentObject(dev.marketVM)
            .preferredColorScheme(.dark)
    }
}

extension InvestTabView {
    private var notesScrollView: some View {
        TabView {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.theme.background)
                .padding(10)
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.theme.background)
                .padding(10)
        }
        .frame(height: 200)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .listRowBackground(Color.gray.opacity(0.1))
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
    }
    
    private var overviewView: some View {
        Group {
            sectionSeparator
            
            HStack {
                Text(marketVM.getEquityString())
                    .bold()
                Text("Equity")
                Spacer()
            }
            .font(.title)
            .foregroundColor(.theme.accent)
            
            HStack {
                Text(marketVM.getBuyingPowerString())
                Text("Buying Power")
                Spacer()
            }
            .font(.title2)
            .foregroundColor(.theme.accent)
            
            sectionSeparator
        }
        .listRowSeparator(.hidden)
    }
    
    private var portfolioView: some View {
        Group {
            if marketVM.portfolios.count > 0 {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Portfolio")
                            .font(.title)
                        Spacer()
                        Text("Value " + marketVM.getPortfolioValueString())
                            .font(.callout)
                    }
                    .foregroundColor(.theme.accent)
                    .padding(.bottom)
                    
                    HStack {
                        Text("Coin")
                        Spacer()
                        Text("Holdings")
                        Text("Total Profit")
                            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                    }
                    .font(.caption)
                    .foregroundColor(.theme.secondaryText)
                }
                
                ForEach(marketVM.portfolios) { portfolio in
                    HStack {
                        Text(portfolio.getCoinModel(from: marketVM.allCoins)?.name ?? "-")
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text(portfolio.getHoldingValueString(from: marketVM.allCoins))
                                .bold()
                            // Text(portfolio.initValue.asCurrencyWith2Decimals())
                            Text(portfolio.amount.asNumberString())
                        }
                        Text(portfolio.getTotalProfitString(from: marketVM.allCoins))
                            .foregroundColor(portfolio.isProfitable(from: marketVM.allCoins) ? .theme.green : .theme.red)
                            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                    }
                    .foregroundColor(.theme.accent)
                }
                sectionSeparator
            }
        }
    }
    
    private var sectionSeparator: some View {
        Rectangle()
            .foregroundColor(Color.gray.opacity(0.1))
            .frame(height: 8)
            .listRowInsets(EdgeInsets())
    }
    
    private var cryptoListTitle: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 50, height: 70)
                .foregroundColor(.gray.opacity(0.2))
            VStack(alignment: .leading, spacing: 10) {
                Text("My Crypto")
                    .font(.body)
                    .foregroundColor(.theme.accent)
                Text("\(marketVM.savedCoinIndices.count) items")
                    .font(.callout)
                    .foregroundColor(.theme.secondaryText)
            }
            Spacer()
            if marketVM.isLoading { ProgressView() }
        }
        .background(
            NavigationLink(
                "",
                destination: CryptoListDetailView().environmentObject(marketVM)
            )
                .opacity(0)
        )
        .listRowSeparator(.hidden)
    }
    
//    private var oldNotesScrollView: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 0) {
//                ForEach(1..<3) { index in
//                    Text("Note \(index)")
//                        .font(.title)
//                        .foregroundColor(.theme.accent)
//                        .frame(width: UIScreen.main.bounds.width - 16, height: 200)
//                        .background(
//                            RoundedRectangle(cornerRadius: 5)
//                                .foregroundColor(.theme.background)
//                        )
//                        .padding(.vertical, 8)
//                        .padding(.leading, 8)
//                }
//            }
//        }
//        .listRowBackground(Color.gray.opacity(0.1))
//        .listRowSeparator(.hidden)
//        .listRowInsets(EdgeInsets())
//    }
}
