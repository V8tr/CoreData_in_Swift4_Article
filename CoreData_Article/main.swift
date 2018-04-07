//
//  main.swift
//  Core Data in Swift 4 with NSPersistentContainer
//
//  Created by Vadim Bulavin on 4/7/18.
//  Copyright © 2018 Vadim Bulavin. All rights reserved.
//

import CoreData

let persistentContainer = NSPersistentContainer(name: "Model")

let group = DispatchGroup()

group.enter()

persistentContainer.loadPersistentStores { storeDescription, error in
    if let error = error {
        assertionFailure(error.localizedDescription)
    }
    
    print("Core Data stack has been initialized with description: \(storeDescription)")
    
    group.leave()
}

group.wait()

// Enforce clean run
try? FileManager.default.removeItem(at: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreData_Article.storedata"))

let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: persistentContainer.viewContext) as! Item

print(item)

item.name = "Some item"

do {
    try persistentContainer.viewContext.save()
    print("Item named '\(item.name!)' has been successfully saved.")
} catch {
    assertionFailure("Failed to save item: \(error)")
}

let itemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")

do {
    let fetchedItems = try persistentContainer.viewContext.fetch(itemsFetch) as! [Item]
    print("Fetched items: \(fetchedItems)")
} catch {
    assertionFailure("Failed to fetch items: \(error)")
}

persistentContainer.viewContext.delete(item)

do {
    let fetchedItems = try persistentContainer.viewContext.fetch(itemsFetch) as! [Item]
    print("Fetched items: \(fetchedItems)")
} catch {
    assertionFailure("Failed to fetch items: \(error)")
}










