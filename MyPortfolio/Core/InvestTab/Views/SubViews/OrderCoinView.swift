//
//  OrderCoinView.swift
//  OrderCoinView
//
//  Created by Jim's MacBook Pro on 9/18/21.
//

import SwiftUI

struct OrderCoinView: View {
    
    @EnvironmentObject private var marketVM: InvestTabViewModel
    
    @Binding var showOrderCoinView: Bool
    @State private var searchText = ""
    @State private var quantityText: String = ""
    @State private var selectedCoin: CoinModel? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                coinLogoList
                if selectedCoin != nil {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                            Spacer()
                            Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                        }
                        Divider()
                        HStack {
                            Text("Order Amount:")
                            Spacer()
                            TextField("EX: 1.4", text: $quantityText)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        Divider()
                        HStack {
                            Text("Current Value")
                            Spacer()
                            Text(getCurrentValue().asCurrency())
                        }
                    }
                    .animation(.none, value: selectedCoin)
                    .padding()
                    .font(.headline)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarTitle("Order Coins")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(isPresented: $showOrderCoinView)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let coin = selectedCoin, let quantity = Double(quantityText) {
                            marketVM.addOrder(coin: coin, amount: quantity)
                            showOrderCoinView = false
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
    
    private var searchResults: [CoinModel] {
        if searchText.isEmpty {
            return marketVM.allCoins
        } else {
            let lowercasedText = searchText.lowercased()
            return marketVM.allCoins.filter { $0.name.lowercased().contains(lowercasedText) || $0.symbol.lowercased().contains(lowercasedText) || $0.id.lowercased().contains(lowercasedText) }
        }
    }
}

struct OrderCoinView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCoinView(showOrderCoinView: .constant(true))
            .environmentObject(dev.marketVM)
    }
}

extension OrderCoinView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(searchResults) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75, height: 110)
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
}
