//
//  MockPersistenceContainer.swift
//  WeatherAppTests
//
//  Created by Dhruv Ukani on 17/10/23.
//

import Foundation
import CoreData.NSPersistentStore
@testable import WeatherApp

class MockPersistenceContainer: PersistenceStorageProtocol {
    
    static let shared = MockPersistenceContainer()
    
    
    var persistentContainer: NSPersistentContainer {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "WeatherApp")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T:NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try MockPersistenceContainer.shared.context.fetch(managedObject.fetchRequest()) as? [T] else {
                return nil
            }
            return result
        }
        catch let error{
            debugPrint(error)
        }
        return nil
    }
    
}
