//
//  Item.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import Foundation
import Parse

public class Item:PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "Item"
    }
    
    @NSManaged var image:PFFile
    @NSManaged var title:String
    public var notes:String?
    
    public convenience init(notes:String, image:PFFile, title:String) {
        self.init()
        self.notes = notes
        self.image = image
        self.title = title
    }
    public convenience init(image:PFFile, title:String) {
        self.init()
        self.image = image
        self.title = title
    }
    
    
    
}
