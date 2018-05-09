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
    @NSManaged var giveItem:Item?
    @NSManaged var getItem:Item?
    @NSManaged var giveItemNotes:String
    @NSManaged var getItemNotes:String
    @NSManaged var match:PFUser
    
    //contains creation date, creator, give items (pointer), give item details (array of strings), get items (pointers), get items details (array of strings), and acceptor
    
    public override init() {
        super.init()
        
        
    }
    public convenience init(giveItem:Item, getItem:Item, giveItemNotes:String, getItemNotes:String) {
        self.init()
        
        self.giveItem = giveItem
        self.getItem = getItem
        self.giveItemNotes = giveItemNotes
        self.getItemNotes = getItemNotes
        if let user = PFUser.current() {
            self.requester = user
        }
        
    }
    
}
