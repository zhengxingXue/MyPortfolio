//
//  AccountTabViewModel.swift
//  AccountTabViewModel
//
//  Created by Jim's MacBook Pro on 9/15/21.
//

import Foundation
import Combine

class AccountTabViewModel: ObservableObject {
    @Published var allAccounts: [AccountEntity] = []
    @Published var currentOrders: [OrderEntity] = []
    
    var currentAccount: AccountEntity { accountDataService.currentAccount }
    
    private let accountDataService = AccountDataService.instance
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        accountDataService.$accounts
            .sink { [weak self] returnedAccounts in
                self?.allAccounts = returnedAccounts
            }
            .store(in: &cancellables)
        
        accountDataService.$currentOrders
            .sink { [weak self] returnedOrders in
                self?.currentOrders = returnedOrders
            }
            .store(in: &cancellables)
    }
    
    func add(account name: String = "Guest Account") {
        let uniqueName = name.uniqued(withRespectTo: allAccounts.map({ $0.name ?? "Guest Account"}))
        accountDataService.add(account: uniqueName)
    }
    
    func addOrder(coin: CoinModel, amount: Double) {
        accountDataService.addOrder(coin: coin, amount: amount)
    }
    
    func delete(at offset: IndexSet) { offset.map({ allAccounts[$0] }).forEach { account in accountDataService.deleteEntity(account: account) } }
    
    func select(account entity: AccountEntity) { accountDataService.select(account: entity)}
    
    func clear() { accountDataService.clear() }
        
}
