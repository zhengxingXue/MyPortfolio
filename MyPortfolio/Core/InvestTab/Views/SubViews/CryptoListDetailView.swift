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
    
    @State var isEditing = false
    
    var body: some View {
        List {
            ForEach(marketVM.savedCoins) {
                coin in CoinRowView(coin: coin)
            }
            .onMove(perform: marketVM.move)
            .onDelete(perform: marketVM.delete(at:))
        }
        .listStyle(.plain)
        .navigationTitle("My Crypto List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarTrailingItemView
            }
        }
        .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
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
                isEditing.toggle()
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
