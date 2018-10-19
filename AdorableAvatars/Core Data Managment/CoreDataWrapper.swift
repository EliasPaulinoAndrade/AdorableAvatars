//
//  CoreDataWrapper.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import CoreData

class CoreDataWrapper {
    public static func getAllAvatars() throws -> [Avatar] {
        let request: NSFetchRequest<Avatar> = Avatar.fetchRequest()
        
        return try CoreDataStack.persistentContainer.viewContext.fetch(request)
    }
    
    public static func getAllFavoriteAvatars() throws -> [Avatar] {
        let request: NSFetchRequest<Avatar> = Avatar.fetchRequest()
        let sort = NSSortDescriptor.init(key: "name", ascending: true)
        
        request.predicate = NSPredicate.init(format: "isFave == true")
        request.sortDescriptors = [sort]
        
        return try CoreDataStack.persistentContainer.viewContext.fetch(request)
    }
}
