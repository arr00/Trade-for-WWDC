//
//  Trade.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import Foundation
import Parse

public class Trade:PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "Trade"
    }
    
    @NSManaged var requester:PFUser
    @NSManaged var giveItems:[Item]
    @NSManaged var getItems:[Item]
    @NSManaged var giveItemsNotes:[String]
    @NSManaged var getItemsNotes:[String]
    @NSManaged var match:PFUser
    
    //contains creation date, creator, give items (pointer), give item details (array of strings), get items (pointers), get items details (array of strings), and acceptor
    
    public convenience init(giveItems:[Item], getItems:[Item], giveItemsNotes:[String], getItemsNotes:[String]) {
        self.init()
        
        self.giveItems = giveItems
        self.getItems = getItems
        self.giveItemsNotes = giveItemsNotes
        self.getItemsNotes = getItemsNotes
        if let user = PFUser.current() {
            self.requester = user
        }
        
    }
    
}
