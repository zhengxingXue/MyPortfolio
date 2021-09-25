//
//  AddCoinView.swift
//  AddCoinView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct AddCoinView: View {
    @EnvironmentObject private var marketVM: InvestTabViewModel
    
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { coin in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(coin.name)
                                .font(.body)
                                .foregroundColor(.theme.accent)
                            Text(coin.symbol.uppercased())
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundColor(.theme.secondaryText)
                        }
                        Spacer()
                        Group {
                            if marketVM.savedCoinIndices.contains(where: {$0 == coin.marketCapRank - 1}) {
                                Image(systemName: "checkmark.circle.fill")
                                    .onTapGesture {
                                        marketVM.delete(coin: coin)
                                    }
                            } else {
                                Image(systemName: "plus.circle")
                                    .onTapGesture {
                                        marketVM.add(coin: coin)
                                    }
                            }
                        }
                        .foregroundColor(.theme.green)
                    }
                    .padding(.vertical)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(.plain)
            .navigationTitle("Add Crypto")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(isPresented: $isPresented)
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

struct AddCoinView_Previews: PreviewProvider {
    static var previews: some View {
        AddCoinView(isPresented: .constant(true))
            .environmentObject(dev.marketVM)
    }
}
