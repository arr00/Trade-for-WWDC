//
//  ParseTradesTableViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/9/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse
import SendBirdSDK


class ParseTradesTableViewController: PFQueryTableViewController, CLLocationManagerDelegate {

    var selectedTrade:Trade?
    let manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("loaded view")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let nib = UINib(nibName: "TradeTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "tradeCell")

        if PFUser.current() == nil {
            
            PFAnonymousUtils.logIn { (user, error) in
                if error == nil {
                    SBDMain.connect(withUserId: user!.objectId!, completionHandler: { (user, error) in
                        print("Connected to sendbird")
                    })
                    if PFInstallation.current() != nil && PFInstallation.current()!.deviceToken != nil {
                        PFUser.current()!["myDeviceToken"] = PFInstallation.current()!.deviceToken
                        PFUser.current()?.saveInBackground()
                        
                    }
                    
                }
                
            }
        }
   
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .done, target: self, action: #selector(ParseTradesTableViewController.addTrade))
        
        print("Completed view did load")
    }

    @objc func addTrade() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tradeDetails") as! TradeDetailsViewController
        vc.vcType = Type.NewTrade
        let navContr = UINavigationController(rootViewController: vc)
        self.present(navContr, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View started view did appear")
        /*
        let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        UIApplication.shared.registerForRemoteNotifications()*/
        //self.refreshControl?.beginRefreshing()
        if !UserDefaults.standard.bool(forKey: "authorized") {
            let vc = storyboard?.instantiateViewController(withIdentifier: "auth") as! AuthVC
            self.present(vc, animated: true, completion: nil)
        }
        print("Finished view did appear")
       
        
        
    }
    
    
    override func objectsDidLoad(_ error: Error?) {
        super.objectsDidLoad(error)
        
        if self.objects == nil || self.objects!.count == 0 {
            print("none exist")
            let alert = UIAlertController(title: "No trades yet.", message: "There are no items to trade availible at the moment. Hold tight!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: "Trade")
        if PFUser.current() != nil {
            query.whereKey("requester", notEqualTo: PFUser.current()!)
        }
        
        query.whereKeyDoesNotExist("match")
        query.order(byDescending: "createdAt")
        return query
    }
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Trade"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Trade"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tradeCell") as! TradeTableViewCell
        cell.trade = object as! Trade
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if indexPath.row < self.objects!.count {
            selectedTrade = self.objects![indexPath.row] as? Trade
            self.performSegue(withIdentifier: "showDetails", sender: self)
        }
        
    }

    
   
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? TradeDetailsViewController {
            dest.trade = selectedTrade
            dest.vcType = Type.AcceptableTrade
        }
    }

}
