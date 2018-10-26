//
//  CoreDataStack.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    
    static var adorableAvatarsGroupUrl : URL? {
        get {
            let adorableAvatarsGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.eliaspaulino.adorableavatars")
            if let coreDataFile = adorableAvatarsGroupUrl?.appendingPathComponent("AdorableAvatars") {
                
                return coreDataFile
            }

            return adorableAvatarsGroupUrl
        }
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AdorableAvatars")
        
        if let coreURL = CoreDataStack.adorableAvatarsGroupUrl {
            
            let description = NSPersistentStoreDescription.init(url: coreURL)
            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true
            container.persistentStoreDescriptions = [description]
        }
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        
        return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
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
