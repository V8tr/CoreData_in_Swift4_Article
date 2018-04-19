//
//  main.swift
//  Core Data in Swift 4 with NSPersistentContainer
//
//  Created by Vadim Bulavin on 4/7/18.
//  Copyright © 2018 Vadim Bulavin. All rights reserved.
//

import CoreData

// 1. Initialize

let persistentContainer = NSPersistentContainer(name: "Model")

let description = NSPersistentStoreDescription()
description.type = NSInMemoryStoreType
persistentContainer.persistentStoreDescriptions = [description]

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

// 2. Create new item

let context = persistentContainer.viewContext

let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as! Item
print(item)

// 3. Save item

item.name = "Some item"
try! context.save()
print("Item named '\(item.name!)' has been successfully saved.")

// 4. Fetch items

let itemsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
let fetchedItems = try! context.fetch(itemsFetchRequest) as! [Item]
print("Fetched items: \(fetchedItems)")

// 5. Delete item

context.delete(item)

let fetchedItemsAfterDelete = try! context.fetch(itemsFetchRequest) as! [Item]
print("Fetched items: \(fetchedItemsAfterDelete)")
