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
                Text("placeholder")
            }
            .navigationTitle(accountVM.currentAccount.name ?? "nil")
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
