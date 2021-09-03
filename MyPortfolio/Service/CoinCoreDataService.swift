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
    
    func move(coin: CoinModel, to destination: Int) {
        guard let entity = savedEntities.first(where: { $0.coinID == coin.id }) else { return }
        move(entity: entity, to: destination)
    }
    
    // MARK: Private
    private func getCoins() {
        let request = NSFetchRequest<CoinEntity>(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CoinEntity.listIndex, ascending: true)]
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
        
        // TODO: Debug
        for index in savedEntities.indices {
            savedEntities[index].listIndex = Int16(index)
        }
        
        print("Successfully loaded \(savedEntities.count) entity")
        print("\(savedEntities)")
    }
    
    private func add(coinID: String) {
        let entity = CoinEntity(context: container.viewContext)
        entity.coinID = coinID
        entity.listIndex = Int16(savedEntities.count)
        applyChanges()
    }
    
    private func delete(entity: CoinEntity) {
        container.viewContext.delete(entity)
        for index in Int(entity.listIndex) ..< savedEntities.count {
            savedEntities[index].listIndex -= 1
        }
        applyChanges()
    }
    
    private func move(entity: CoinEntity, to destination: Int) {
        let currentListIndex = entity.listIndex
        print("destination: \(destination) current index:\(currentListIndex)")
        if destination < currentListIndex {
            for index in destination ..< Int(currentListIndex) {
                savedEntities[index].listIndex += 1
            }
        } else {
            for index in (Int(currentListIndex) + 1) ..< destination {
                guard index < savedEntities.count else { break }
                savedEntities[index].listIndex -= 1
            }
        }
        entity.listIndex = Int16(destination)
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
