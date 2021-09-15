//
//  AccountTabView.swift
//  AccountTabView
//
//  Created by Jim's MacBook Pro on 9/15/21.
//

import SwiftUI

struct AccountTabView: View {
    
    @EnvironmentObject private var accountVM: AccountTabViewModel
    
    @State private var showAllAccountsView: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                accountInfo
                VStack {
                    Text("Cash " + accountVM.currentAccount.cash.asCurrencyWith2Decimals())
                }
            }
            .sheet(isPresented: $showAllAccountsView, content: {
                AllAcountsView(showAllAccountsView: $showAllAccountsView)
                    .environmentObject(accountVM)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAllAccountsView.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.theme.accent)
                    }
                }
            }
        }
    }
}

struct AccountTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView()
            .environmentObject(dev.getAccountVM())
    }
}

extension AccountTabView {
    private var accountInfo: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .fill(Color.theme.background)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "plus.circle")
                                .resizable()
                                .foregroundColor(.theme.accent)
                        )
                    , alignment: .bottomTrailing)
                .padding(.vertical)
            
            Text(accountVM.currentAccount.name ?? "nil")
                .foregroundColor(.theme.accent)
                .font(.title)
            
            Text("Joined \(accountVM.currentAccount.dateCreated?.asMonthYearString() ?? "Unknown" )")
                .foregroundColor(.theme.secondaryText)
                .font(.body)
        }
        .padding(.bottom)
    }
}
