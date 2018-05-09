//
//  ItemDescriptionViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit

class ItemDescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var item:Item?
    var editable:Bool?
    var type:Type?
    var trade:Trade?
    var getOrGive:Bool?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        switch type ?? Type.ExistingTrade {
        case .NewTrade:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(ItemDescriptionViewController.save))
        case .ExistingTrade:
            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(ItemDescriptionViewController.dismissMe))
            break
        }
        
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        if item != nil {
            item!.image.getDataInBackground { (data, error) in
                if error == nil && data != nil {
                    guard let image = UIImage(data: data!) else {
                        return
                    }
                    self.imageView.image = image
                }
            }
        }
    }
    
    @objc func save() {
        if getOrGive ?? false {
            trade?.getItem = item!
        }
        else {
            trade?.giveItem = item!
        }
        print("saving")
        
        print("Saving trade")
        print(trade)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func dismissMe() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if item != nil {
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.textLabel?.text = item!.title
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "textViewCell") as! TextViewTableViewCell
                if editable ?? false {
                    cell.textView.isEditable = true
                }
                else {
                    cell.textView.isEditable = false
                    cell.textView.text = item!.notes ?? ""
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 44:80
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
