//
//  InvestTabView.swift
//  InvestTabView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct InvestTabView: View {
    
    @EnvironmentObject private var marketVM: InvestTabViewModel
    
    var body: some View {
        NavigationView {
            List {
                notesScrollView
                ListTitleRow(title: "List")
                cryptoListTitle
                
                ForEach(marketVM.savedCoins) { coin in
                    CoinRowView(coin: coin, isEditing: .constant(false))
                }
                .onDelete(perform: marketVM.delete(at:))
                
            }
            .refreshable {
                marketVM.refreshAllCoins()
            }
            .listStyle(.plain)
            .navigationTitle("Investing")
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
                .padding(8)
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.theme.background)
                .padding(8)
        }
        .frame(height: 200)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .listRowBackground(Color.gray.opacity(0.1))
        .listRowSeparator(.hidden)
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
                Text("\(marketVM.savedCoinEntities.count) items")
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
