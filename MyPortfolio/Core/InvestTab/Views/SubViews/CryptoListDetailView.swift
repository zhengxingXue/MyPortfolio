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
            loadingView
            ForEach(marketVM.savedCoins) { coin in
                CoinRowView(coin: coin, coinEntity: marketVM.getCoinEntity(of: coin)!, isEditing: $isEditing)
            }
            .onMove(perform: marketVM.move)
            .onDelete(perform: marketVM.delete(at:))
        }
        .refreshable {
            marketVM.refreshAllCoins()
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
    private var loadingView: some View {
        Group {
            if marketVM.isLoading {
                HStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
    }
    
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
