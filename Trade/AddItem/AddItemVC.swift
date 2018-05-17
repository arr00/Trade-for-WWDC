//
//  AddItemVC.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse

class AddItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var availibleItems:[Item]!
    var currentIndex = -1
    var trade:Trade?
    var getOrGive:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availibleItems = [Item]()
        updateItems()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(AddItemVC.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Request new item", style: .plain, target: self, action: #selector(AddItemVC.requestAdditionalItems))
        
        // Do any additional setup after loading the view.
    }
    @objc func requestAdditionalItems() {
        let alert = UIAlertController(title: "Request new item to trade.", message: "Trades for WWDC only allows trades with items added by us. If there is an item missing that has been around for a while, please send us an email.", preferredStyle: .alert)
        let emailButton = UIAlertAction(title: "Send email", style: .default) { (alert) in
            if let url = URL(string: "mailto:support@agapps.xyz") {
                print("Opening link")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(emailButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    func updateItems() {
        availibleItems.removeAll()
        let query = PFQuery(className: "Item")
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                for object in objects! {
                    self.availibleItems.append(object as! Item)
                }
                
                if self.availibleItems.count == 0 {
                    let alert = UIAlertController(title: "No items to trade yet.", message: "There are no items availble to trade in the app yet. As items are give out at WWDC, they will be added. Hold tight!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                /*
                let item = Item()
                item.title = "Money"
                self.availibleItems.append(item)*/
                
                self.availibleItems.sort(by: { (i1, i2) -> Bool in
                    guard let i1Order = i1["order"] as? Double else {
                        return false
                    }
                    guard let i2Order = i2["order"] as? Double else {
                        return false
                    }
                    return i1Order < i2Order
                })
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func cancel() {
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
        return availibleItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! GenericItemTableViewCell
        let item = availibleItems[indexPath.row]
        cell.titleLabel.text = item.title
        print("fetching image")
        cell.file = item.image
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            currentIndex = indexPath.row
            self.performSegue(withIdentifier: "showItemDetails", sender: self)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showItemDetails" {
            if let dest = segue.destination as? ItemDescriptionViewController {
                dest.item = availibleItems[currentIndex]
                dest.editable = true
                dest.type = Type.NewTrade
                dest.trade = trade
                dest.getOrGive = getOrGive
            }
        }
    }
    

}
