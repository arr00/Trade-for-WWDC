//
//  TextViewTableViewCell.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.text = "Optional comments here. Ex: Size, Color, Condition..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func setText(text:String) {
        textView.textColor = UIColor.black
        textView.text = text
    }
    func getNoteString() -> String {
        return textView.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
