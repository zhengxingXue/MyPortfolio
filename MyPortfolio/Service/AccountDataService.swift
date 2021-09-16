//
//  AccountDataService.swift
//  AccountDataService
//
//  Created by Jim's MacBook Pro on 9/15/21.
//

import Foundation
import CoreData

class AccountDataService {
    
    static let instance = AccountDataService()
    
    private let container: NSPersistentContainer
    private let containerName: String = "AccountContainer"
    
    private let accountEntityName: String = "AccountEntity"
    private let portfolioCoinEntityName: String = "PortfolioCoinEntity"
    private let watchListCoinEntityName: String = "WatchListCoinEntity"
    
    @Published var accounts: [AccountEntity] = []
    @Published var currentWatchListCoins: [WatchListCoinEntity] = []
    
    var currentAccount: AccountEntity {
        if let currentAccount = accounts.first(where: { $0.selected }) {
            return currentAccount
        } else {
            let currentAccount = createEntity(account: "Guest Account")
            currentAccount.selected = true
            applyChanges()
            return currentAccount
        }
    }
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            } else {
                print("Successfully loaded \(self.containerName)!")
            }
            self.getAccount()
            self.getCurrentWatchListCoins()
        }
    }

    private func getAccount() {
        let request = NSFetchRequest<AccountEntity>(entityName: accountEntityName)
        do {
            accounts = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Account Entities. \(error)")
        }
    }
    
    private func getCurrentWatchListCoins() {
        currentWatchListCoins = currentAccount.watchListCoins?.allObjects as? [WatchListCoinEntity] ?? []
        currentWatchListCoins.sort(by: { $0.listIndex < $1.listIndex })
        for index in currentWatchListCoins.indices {
            currentWatchListCoins[index].listIndex = Int16(index)
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getAccount()
        getCurrentWatchListCoins()
//        getCoins()
    }
    
    // For Debug
//    private func getCoins() {
//        let request = NSFetchRequest<WatchListCoinEntity>(entityName: watchListCoinEntityName)
//        do {
//            let coins = try container.viewContext.fetch(request)
//            print("\(coins)")
//        } catch let error {
//            print("Error fetching Account Entities. \(error)")
//        }
//    }
}


extension AccountDataService {
    // MARK: AccountEntity Functions
    func add(account name: String) {
        guard accounts.first(where: { $0.name == name }) == nil else { return }
        addEntity(account: name)
    }
    
    func deleteEntity(account entity: AccountEntity) {
        container.viewContext.delete(entity)
        if entity.selected, let first = accounts.first(where: {$0.name != entity.name}) {
            first.selected = true
        }
        applyChanges()
    }

    func select(account entity: AccountEntity) {
        currentAccount.selected = false
        entity.selected = true
        applyChanges()
    }
    
    private func addEntity(account name: String) {
        _ = createEntity(account: name)
        applyChanges()
    }
    
    private func createEntity(account name: String) -> AccountEntity {
        let entity = AccountEntity(context: container.viewContext)
        entity.name = name
        entity.dateCreated = Date()
        entity.cash = 100000
        entity.selected = false
        entity.portfolioCoins = []
        entity.watchListCoins = []
        return entity
    }
}

extension AccountDataService {
    // MARK: WatchListCoinEntity Functions
    func add(coin: CoinModel) {
        guard currentWatchListCoins.first(where: { $0.coinID == coin.id }) == nil else { return }
        addEntity(watchListCoin: coin.id)
    }
    
    func delete(coin: CoinModel) {
        guard let entity = currentWatchListCoins.first(where: { $0.coinID == coin.id }) else { return }
        deleteEntity(watchListCoin: entity)
    }
    
    func move(coin: CoinModel, to destination: Int) {
        guard let entity = currentWatchListCoins.first(where: { $0.coinID == coin.id }) else { return }
        moveEntity(watchListCoin: entity, to: destination)
    }
    
    private func addEntity(watchListCoin coinID: String) {
        let entity = WatchListCoinEntity(context: container.viewContext)
        entity.coinID = coinID
        entity.listIndex = Int16(currentWatchListCoins.count)
        entity.account = currentAccount
        applyChanges()
    }
    
    private func deleteEntity(watchListCoin entity: WatchListCoinEntity) {
        container.viewContext.delete(entity)
        for index in Int(entity.listIndex) ..< currentWatchListCoins.count {
            currentWatchListCoins[index].listIndex -= 1
        }
        applyChanges()
    }
    
    private func moveEntity(watchListCoin entity: WatchListCoinEntity, to destination: Int) {
        let currentListIndex = entity.listIndex
        if destination < currentListIndex {
            for index in destination ..< Int(currentListIndex) {
                currentWatchListCoins[index].listIndex += 1
            }
        } else {
            let leftIndex = Int(currentListIndex) + 1
            guard leftIndex <= destination else { return }
            for index in leftIndex ..< destination {
                guard index < currentWatchListCoins.count else { break }
                currentWatchListCoins[index].listIndex -= 1
            }
        }
        entity.listIndex = Int16(destination)
        applyChanges()
    }
}
