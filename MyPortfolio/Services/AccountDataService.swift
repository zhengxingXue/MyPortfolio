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
    private let coinEntityName: String = "CoinEntity"
    
    @Published var accounts: [AccountEntity] = []
    @Published var currentCoins: [CoinEntity] = []
    @Published var currentOrders: [OrderEntity] = []
    @Published var currentPortfolios: [PortfolioEntity] = []
    private var allCoins: [CoinEntity] = []
    
    var currentAccount: AccountEntity {
        if let currentAccount = accounts.first(where: { $0.selected }) {
            return currentAccount
        } else {
            let currentAccount = createEntity(account: "Guest Account")
            currentAccount.selected = true
            applyChanges()
            addEntity(coin: "bitcoin", rank: 1)
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
            self.getAll()
        }
    }
    
    private func getAll() {
        getAccount()
        getCurrentCoins()
        getAllCoins()
        getCurrentOrders()
        getCurrentPortfolios()
    }

    private func getAccount() {
        let request = NSFetchRequest<AccountEntity>(entityName: accountEntityName)
        do {
            accounts = try container.viewContext.fetch(request)
//            print("\naccounts: \n \(accounts)\n")
        } catch let error {
            print("Error fetching Account Entities. \(error)")
        }
    }
    
    private func getCurrentCoins() {
        currentCoins = currentAccount.coins?.allObjects as? [CoinEntity] ?? []
        var sortedCoins: [CoinEntity] = []
        for coinID in (currentAccount.coinIDs ?? []) {
            if let coin = currentCoins.first(where: { $0.coinID == coinID}) {
                sortedCoins.append(coin)
            }
        }
        currentCoins = sortedCoins
    }
    
    private func getCurrentOrders() {
        currentOrders = currentAccount.orders?.allObjects as? [OrderEntity] ?? []
        currentOrders.sort(by: { $0.dateCreated ?? Date() > $1.dateCreated ?? Date() })
    }
    
    private func getAllCoins() {
        let request = NSFetchRequest<CoinEntity>(entityName: coinEntityName)
        do {
            allCoins = try container.viewContext.fetch(request)
//            print("\nall coins: \n \(allCoins)\n")
        } catch let error {
            print("Error fetching coin Entities. \(error)")
        }
    }
    
    private func getCurrentPortfolios() {
        currentPortfolios = (currentAccount.portfolios?.allObjects as? [PortfolioEntity] ?? []).sorted(by: { $0.initValue > $1.initValue })
//        print("\nCurrent Portfolios: \n\(currentPortfolios)\n")
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
        getAll()
    }
    
    func clear() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: coinEntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting all coin Entities. \(error)")
        }
    }
}

extension AccountDataService {
    // MARK: OrderEntity PortfolioEntity Functions
    func addOrder(coin: CoinModel, amount: Double) {
        addEntity(order: coin.id, amount: amount, price: coin.currentPrice)
        updatePortolio(name: coin.id, rank:coin.marketCapRank, amount: amount, price: coin.currentPrice)
    }
    
    private func addEntity(order name: String, amount: Double, price: Double) {
        let entity = OrderEntity(context: container.viewContext)
        entity.name = name
        entity.dateCreated = Date()
        entity.amount = amount
        entity.price = price
        entity.account = currentAccount
        currentAccount.cash -= amount * price
        applyChanges()
    }
    
    private func updatePortolio(name: String, rank: Int16, amount: Double, price: Double) {
        if let oldEntity = currentPortfolios.first(where: { $0.name == name }) {
            // TODO: how to publish entity attribute change
            // Workaround, build a new entity
            let newAmount = oldEntity.amount + amount
            if newAmount > 0 {
                let portolioEntity = PortfolioEntity(context: container.viewContext)
                portolioEntity.name = name
                portolioEntity.amount = newAmount
                portolioEntity.initValue = oldEntity.initValue + amount * price
                portolioEntity.rank = rank
                portolioEntity.account = currentAccount
            }
            container.viewContext.delete(oldEntity)

        } else {
            let portolioEntity = PortfolioEntity(context: container.viewContext)
            portolioEntity.name = name
            portolioEntity.amount = amount
            portolioEntity.initValue = amount * price
            portolioEntity.rank = rank
            portolioEntity.account = currentAccount
        }
        applyChanges()
    }
}


extension AccountDataService {
    // MARK: AccountEntity Functions
    func add(account name: String) {
        guard accounts.first(where: { $0.name == name }) == nil else { return }
        addEntity(account: name)
    }
    
    func deleteEntity(account entity: AccountEntity) {
        for coin in (entity.coins?.allObjects as? [CoinEntity] ?? []) {
            deleteEntity(coin: coin, from: entity)
        }
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
        entity.coinIDs = []
        entity.coins = []
        entity.orders = []
        entity.portfolios = []
        return entity
    }
}

extension AccountDataService {
    // MARK: CoinEntity Functions
    func add(coin: CoinModel) {
        guard currentCoins.first(where: { $0.coinID == coin.id }) == nil else { return }
        addEntity(coin: coin.id, rank: coin.marketCapRank)
    }
    
    func delete(coin: CoinModel) {
        guard let entity = currentCoins.first(where: { $0.coinID == coin.id }) else { return }
        deleteEntity(coin: entity, from: currentAccount)
    }
    
    func moveCoin(from source: IndexSet, to destination: Int) {
        currentAccount.coinIDs?.move(fromOffsets: source, toOffset: destination)
        applyChanges()
    }
    
    private func addEntity(coin coinID: String, rank: Int16) {
        if let entity = allCoins.first(where: { $0.coinID == coinID }) {
            currentAccount.addToCoins(entity)
        } else {
            let entity = CoinEntity(context: container.viewContext)
            entity.coinID = coinID
            entity.rank = rank
            currentAccount.addToCoins(entity)
        }
        currentAccount.coinIDs?.append(coinID)
        applyChanges()
    }
    
    private func deleteEntity(coin entity: CoinEntity, from account: AccountEntity) {
        account.removeFromCoins(entity)
        if entity.accounts?.count == 0 {
            container.viewContext.delete(entity)
        }
        account.coinIDs?.removeAll(where: { $0 == entity.coinID })
        applyChanges()
    }
}
