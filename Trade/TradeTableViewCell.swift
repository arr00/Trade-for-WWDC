//
//  TradeTableViewCell.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit

class TradeTableViewCell: UITableViewCell {
    @IBOutlet weak var giveImageView: UIImageView!
    @IBOutlet weak var getImageView: UIImageView!
    private var tradeStorage:Trade?
    var trade:Trade {
        set(item) {
            tradeStorage = trade
            
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
                
            }
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
