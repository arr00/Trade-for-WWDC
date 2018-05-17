//
//  TradeTableViewCell.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse

class TradeTableViewCell: PFTableViewCell {
    @IBOutlet weak var giveImageView: PFImageView!
    @IBOutlet weak var getImageView: PFImageView!
    
    private var tradeStorage:Trade?
    var trade:Trade {
        set(item) {
            if PFUser.current()?.objectId == item.requester.objectId {
                //items remain
                item.getItem?.fetchInBackground(block: { (object, error) in
                    self.getImageView.file = item.getItem!.image
                    self.getImageView.loadInBackground()
                })
                item.giveItem?.fetchInBackground(block: { (object, error) in
                    self.giveImageView.file = item.giveItem!.image
                    self.giveImageView.loadInBackground()
                })
            }
            else {
                //switch items
                item.getItem?.fetchInBackground(block: { (object, error) in
                    self.giveImageView.file = item.getItem!.image
                    self.giveImageView.loadInBackground()
                })
                item.giveItem?.fetchInBackground(block: { (object, error) in
                    self.getImageView.file = item.giveItem!.image
                    self.getImageView.loadInBackground()
                })
                
            }
            
            tradeStorage = trade
            
            
            
            /*
                do {
                    try item.getItem!.fetchIfNeeded()
                }
                catch {
                    print("error fetching")
                    return
                }
                
                item.getItem!.image.getDataInBackground { (data, error) in
                    if let image = UIImage(data: data!) {
                        self.getImageView.image = image
                    }
                }
            
            
                do {
                    try item.giveItem!.fetchIfNeeded()
                }
                catch {
                    print("error fetching")
                    return
                }
                item.giveItem!.image.getDataInBackground { (data, error) in
                    if let image = UIImage(data: data!) {
                        self.giveImageView.image = image
                    }
                
            }*/
        }
        get {
            return tradeStorage ?? Trade()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
