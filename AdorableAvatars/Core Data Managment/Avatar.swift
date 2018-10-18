//
//  Avatar+create.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension Avatar {
    
    public convenience init(name: String, isFave: Bool){
        self.init(context: CoreDataStack.persistentContainer.viewContext)
        
        self.name = name
        self.isFave = isFave
    }
}
