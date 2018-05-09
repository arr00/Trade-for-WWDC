//
//  GenericItemTableViewCell.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse

class GenericItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    var file:PFFile? {
        set(this) {
            if this == nil {
                return
            }
            this!.getDataInBackground { (data, error) in
                if error == nil && data != nil {
                    if let image = UIImage(data: data!) {
                        self.myImageView.image = image
                        print("setting image")
                    }
                }
            }
        }
        get {
            return nil
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
