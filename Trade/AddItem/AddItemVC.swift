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
        
        // Do any additional setup after loading the view.
    }
    func updateItems() {
        availibleItems.removeAll()
        let query = PFQuery(className: "Item")
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                for object in objects! {
                    self.availibleItems.append(object as! Item)
                }
                let item = Item()
                item.title = "Money"
                self.availibleItems.append(item)
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
        if indexPath.row == availibleItems.count - 1 {
            let alert = UIAlertController(title: "Value in USD", message: "", preferredStyle: .alert)
            alert.addTextField { (field) in
                print("hello")
            }
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                print("Added money with value of ")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            currentIndex = indexPath.row
            self.performSegue(withIdentifier: "showItemDetails", sender: self)
        }
        
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
