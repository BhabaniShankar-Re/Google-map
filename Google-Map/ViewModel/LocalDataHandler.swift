//
//  LocalDataHandler.swift
//  Google-Map
//
//  Created by Summit on 28/02/21.
//

import CoreData


class LocalDataHandler {
    static let shared: LocalDataHandler = LocalDataHandler()
    
    var persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
       let persistentContainer = NSPersistentContainer(name: "Google_Map")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        self.persistentContainer = persistentContainer
    }
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    

}


