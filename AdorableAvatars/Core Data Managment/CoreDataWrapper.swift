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
    
    
    /// get all avatars saved on coredata
    ///
    /// - Returns: the avatars
    /// - Throws: coredata fetch error
    public static func getAllAvatars() throws -> [Avatar] {
        let request: NSFetchRequest<Avatar> = Avatar.fetchRequest()
        
        return try CoreDataStack.persistentContainer.viewContext.fetch(request)
    }
    
    
    /// get all favorite avatats on coredata
    ///
    /// - Returns: the favorite avatars
    /// - Throws: coredata fetch error
    public static func getAllFavoriteAvatars() throws -> [Avatar] {
        let request: NSFetchRequest<Avatar> = Avatar.fetchRequest()
        let sort = NSSortDescriptor.init(key: "name", ascending: true)
        
        request.predicate = NSPredicate.init(format: "isFave == true")
        request.sortDescriptors = [sort]
        
        return try CoreDataStack.persistentContainer.viewContext.fetch(request)
    }
    
    
    /// search by avatars with a name
    ///
    /// - Parameter name: the name to search for
    /// - Returns: the avatars with name composed by the paramenter
    /// - Throws: coredata fetch error
    public static func findAvatars(byName name: String) throws ->  [Avatar] {
        let request: NSFetchRequest<Avatar> = Avatar.fetchRequest()
        let sort = NSSortDescriptor.init(key: "name", ascending: true)
        
        request.predicate = NSPredicate.init(format: "name CONTAINS[cd] %@", name)
        request.sortDescriptors = [sort]
        
        return try CoreDataStack.persistentContainer.viewContext.fetch(request)
    }
    
    public static func getAvatar(withName name: String) -> Avatar? {
        let request: NSFetchRequest<Avatar> = Avatar.fetchRequest()
        request.predicate = NSPredicate.init(format: "name == [c] %@", name)
        
        if let result = try? CoreDataStack.persistentContainer.viewContext.fetch(request) {
            return result.first
        }
        
        return nil
    }
}
