//
//  TradeDetailsViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse
import SendBirdSDK

class TradeDetailsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var vcType:Type?
    @IBOutlet weak var tableView: UITableView!
    var trade:Trade!
    var giveGet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if trade == nil {
            trade = Trade()
            if let user = PFUser.current() {
                trade.requester = PFUser.current()!
            }
        }
        
        switch vcType ?? Type.ExistingTrade {
        case .NewTrade:
            self.navigationItem.title = "New Trade"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(TradeDetailsViewController.myDismiss))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(TradeDetailsViewController.submitTrade))
            break
        case .ExistingTrade:
            self.navigationItem.title = "Trade"
            print("Trade requester is \(trade.requester.objectId), and current user is \(PFUser.current()?.objectId)")
            if trade.requester.objectId != PFUser.current()?.objectId && trade.match == nil {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Accept", style: .done, target: self, action: #selector(TradeDetailsViewController.acceptTrade))
            }
            break
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func acceptTrade() {
        //TODO: Make trades immutable
        //trade.match = PFUser.current()!

        //loading
        PFCloud.callFunction(inBackground: "acceptTrade", withParameters: ["tradeId":trade.objectId!]) { (result, error) in
            print("Finished cloud call with result \(result)")
            if error == nil {
                let alert = UIAlertController(title: "Trade accepted!", message: "Go to messages to chat with your trade mate!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
                    //action
                }))
                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController!.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Error accepting trade", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
                    //action
                }))
                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController!.present(alert, animated: true, completion: nil)
            }
            
        }
      
    }
    
    @objc func submitTrade() {
        let acl = PFACL()
        acl.hasPublicReadAccess = true
        acl.hasPublicWriteAccess = false
        trade.acl = acl
        trade.saveInBackground { (success, error) in
            print("Trade posted with success of \(success)")
            if success {
                let alert = UIAlertController(title: "Trade posted successfully", message: "Your trade is on our servers! Hold tight and we'll let you know when it's accepted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cool", style: .default, handler: { (action) in
                    self.myDismiss()
                }))
                self.present(alert, animated: true, completion:nil)
            }
            else {
                let alert = UIAlertController(title: "Error posting trade", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.myDismiss()
                }))
                self.present(alert, animated: true, completion:nil)
            }
           
        }
        
    }
    
    @objc func myDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch vcType ?? Type.ExistingTrade {
        case .ExistingTrade:
            return 1
        case .NewTrade:
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Give":"Get"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if trade.giveItem == nil {
                //Add button
                let cell = tableView.dequeueReusableCell(withIdentifier: "addCell")!
                return  cell
            }
        }
        else {
            if trade.getItem == nil {
                //Add button
                let cell = tableView.dequeueReusableCell(withIdentifier: "addCell")!
                return  cell
            }
        }
        
        
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            if PFUser.current()?.objectId == trade.requester.objectId {
                cell.textLabel?.text = trade.giveItem!.title
            }
            else {
                cell.textLabel?.text = trade.getItem!.title
            }
            return cell
        }
        else {
            let cell = UITableViewCell()
            if PFUser.current()?.objectId == trade.requester.objectId {
                cell.textLabel?.text = trade.getItem!.title
            }
            else {
                cell.textLabel?.text = trade.giveItem!.title
            }
            return cell
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        print("Trade details \n Trade give details \(trade.giveItemNotes) \n Trade get details \(trade.getItemNotes)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        
        if indexPath.section == 0 {
            giveGet = false
            var giveItem:Item?
            if PFUser.current()?.objectId == trade.requester.objectId {
                giveItem = trade.giveItem
            }
            else {
                giveItem = trade.getItem
            }
            if giveItem != nil {
                let vc = storyboard?.instantiateViewController(withIdentifier: "itemDescription") as! ItemDescriptionViewController
                vc.item = giveItem
                vc.editable = false
                vc.trade = trade
                vc.getOrGive = giveGet
                self.navigationController?.show(vc, sender: self)
                return
            }
            
        }
        else {
            giveGet = true
            var getItem:Item?
            if PFUser.current()?.objectId == trade.requester.objectId {
                getItem = trade.getItem
            }
            else {
                getItem = trade.giveItem
            }
            if getItem != nil {
                let vc = storyboard?.instantiateViewController(withIdentifier: "itemDescription") as! ItemDescriptionViewController
                vc.item = getItem
                vc.trade = trade
                vc.editable = false
                vc.getOrGive = giveGet
                self.navigationController?.show(vc, sender: self)
                return
            }
           
            
        }
        self.performSegue(withIdentifier: "addItem", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? UINavigationController {
            if let myVC = dest.topViewController as? AddItemVC {
                myVC.trade = trade
                print("Set trade")
                myVC.getOrGive = giveGet
            }
            
        }
    }
    

}


public enum Type {
    case NewTrade
    case ExistingTrade
}
