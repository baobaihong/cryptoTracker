//
//  PortfolioDataService.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/22.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading core data: \(error)")
            }
        }
        self.getPortfolio()
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("error fetching portfolio entity: \(error)")
        }
    }
    
    // MARK: PUBLIC
    func updatePortfolio(coin: CoinModel, amount: Double) {
        //check if this coin exist in database
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount) // if the amount passed in > 0, update the amount in database
            } else {
                delete(entity: entity) // if the amount <= 0, delete the coin in database
            }
        } else {
            add(coin: coin, amount: amount) // if the coin doesn't exist in database, add it to the database
        }
    }
    
    // MARK: PRIVATE
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("error saving to core data: \(error)")
        }
    }
    
    private func applyChanges() {
        save() // saved to database but the publisher of this data service has not been updated
        getPortfolio() // re-fetch the whole array(preferred approach when database is not large, otherwise should use append)
    }
    
}
