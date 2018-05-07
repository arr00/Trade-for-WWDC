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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availibleItems = [Item]()
        

        tableView.delegate = self
        tableView.dataSource = self
        
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
            }
        }
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
        item.image.getDataInBackground { (data, error) in
            if error == nil && data != nil {
                if let image = UIImage(data: data!) {
                    cell.myImageView.image = image
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        self.performSegue(withIdentifier: "showItemDetails", sender: self)
    }
    

   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showItemDetails" {
            if let dest = segue.destination as? ItemDescriptionViewController {
                dest.item = availibleItems[currentIndex]
                dest.editable = true
            }
        }
    }
    

}
