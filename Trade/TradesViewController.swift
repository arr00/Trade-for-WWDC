//
//  TradesViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse
import SendBirdSDK

class TradesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var trades:[Trade]!
    var selectedRow = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TradeTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "tradeCell")
        trades = [Trade]()
        if PFUser.current() == nil {
            
            PFAnonymousUtils.logIn { (user, error) in
                if error == nil {
                    SBDMain.connect(withUserId: user!.objectId!, completionHandler: { (user, error) in
                        print("Connected to sendbird")
                    })
                    if PFInstallation.current() != nil {
                        user!["installationId"] = PFInstallation.current()!.objectId
                    }
                    
                }
                
            }
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .done, target: self, action: #selector(YourTradesViewController.addTrade))

        // Do any additional setup after loading the view.
    }
    
    @objc func addTrade() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tradeDetails") as! TradeDetailsViewController
        vc.vcType = Type.NewTrade
        let navContr = UINavigationController(rootViewController: vc)
        self.present(navContr, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        UIApplication.shared.registerForRemoteNotifications()
        updateTrades()
    }
    func updateTrades() {
        trades.removeAll()
        tableView.reloadData()
        let query = PFQuery(className: "Trade")
        query.whereKey("requester", notEqualTo: PFUser.current())
        query.whereKeyDoesNotExist("match")
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                self.trades.removeAll()
                if objects!.count > 0 {
                    for object in objects! {
                        self.trades.append(object as! Trade)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trades.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tradeCell") as! TradeTableViewCell
        cell.trade = trades[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? TradeDetailsViewController {
            dest.trade = trades[selectedRow]
            dest.vcType = Type.ExistingTrade
        }
    }
    

}
