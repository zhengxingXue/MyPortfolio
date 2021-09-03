//
//  CoinCoreDataService.swift
//  CoinCoreDataService
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation
import CoreData

class CoinCoreDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "CoinContainer"
    private let entityName: String = "CoinEntity"
    
    @Published var savedEntities: [CoinEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            } else {
                print("Successfully loaded Core Data!")
            }
            self.getCoins()
        }
    }
    
    // MARK: Public
    func add(coin: CoinModel) {
        guard savedEntities.first(where: { $0.coinID == coin.id }) == nil else { return }
        add(coinID: coin.id)
    }
    
    func delete(coin: CoinModel) {
        guard let entity = savedEntities.first(where: { $0.coinID == coin.id }) else { return }
        delete(entity: entity)
    }
    
    // MARK: Private
    private func getCoins() {
        let request = NSFetchRequest<CoinEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
        print("Successfully loaded \(savedEntities.count) entity")
    }
    
    private func add(coinID: String) {
        let entity = CoinEntity(context: container.viewContext)
        entity.coinID = coinID
        applyChanges()
    }
    
    private func delete(entity: CoinEntity) {
        container.viewContext.delete(entity)
        applyChanges()
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
        getCoins()
    }
}
