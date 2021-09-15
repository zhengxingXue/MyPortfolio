//
//  AllAcountsView.swift
//  AllAcountsView
//
//  Created by Jim's MacBook Pro on 9/15/21.
//

import SwiftUI

struct AllAcountsView: View {
    
    @EnvironmentObject private var accountVM: AccountTabViewModel
    
    @Binding var showAllAccountsView: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accountVM.allAccounts) { account in
                    HStack {
                        Text("\(account.name ?? "nil")")
                        Spacer()
                        Text((account.selected ) ? "current" : "")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        accountVM.select(account: account)
                        showAllAccountsView = false
                    }
                }
                .onDelete(perform: accountVM.delete(at:))
            }
            .listStyle(.plain)
            .navigationBarTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(isPresented: $showAllAccountsView)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        accountVM.add()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct AllAcountsView_Previews: PreviewProvider {
    static var previews: some View {
        AllAcountsView(showAllAccountsView: .constant(true))
            .environmentObject(dev.getAccountVM())
    }
}
