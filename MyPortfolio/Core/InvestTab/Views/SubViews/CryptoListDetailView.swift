//
//  CryptoListDetailView.swift
//  CryptoListDetailView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct CryptoListDetailView: View {
    
    @EnvironmentObject private var marketVM: InvestTabViewModel
    
    @State private var showAddCoinView: Bool = false
    
    var body: some View {
        List {
            ForEach(marketVM.savedCoins) {
                coin in CoinRowView(coin: coin)
            }
            .onDelete(perform: marketVM.delete(at:))
        }
        .listStyle(.plain)
        .navigationTitle("My Crypto List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarTrailingItemView
            }
        }
    }
}

struct CryptoListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CryptoListDetailView()
                .environmentObject(dev.marketVM)
        }
    }
}

extension CryptoListDetailView {
    private var toolbarTrailingItemView: some View {
        HStack {
            Button(action: {
                showAddCoinView.toggle()
            }, label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.theme.accent)
            })
                .padding(.trailing)
            
            Button(action: {
                print("Unimplemented")
            }, label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.theme.accent)
            })
        }
        .fullScreenCover(isPresented: $showAddCoinView) {
            AddCoinView(isPresented: $showAddCoinView)
        }
    }
}
