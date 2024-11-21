//
//  persistant.swift
//  ShubhamLodhi_MT
//
//  Created by SHUBHAM on 21/11/24.
//

import Foundation
import CoreData

final class  PersistantStorage {
    // MARK: - Core Data stack
    private init(){}
    static var shared = PersistantStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "ShubhamLodhi_MT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    lazy var  context = persistentContainer.viewContext
    func saveContext () {

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
