//
//  MessagesViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/8/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse

class MessagesVC:UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var trades:[Trade]!
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TradeTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "tradeCell")
        trades = [Trade]()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    override func viewDidAppear(_ animated: Bool) {
        updateTrades()
    }
    func updateTrades() {
        trades.removeAll()
        tableView.reloadData()
        let match = PFQuery(className: "Trade")
        let requester = PFQuery(className: "Trade")
        if PFUser.current() != nil {
            requester.whereKey("requester", equalTo: PFUser.current()!)
            match.whereKey("match", equalTo: PFUser.current()!)
        }
        
        requester.whereKeyExists("match")
        
        let jointQuery = PFQuery.orQuery(withSubqueries: [requester,match])
        jointQuery.order(byDescending: "acceptedAt")

        jointQuery.findObjectsInBackground { (objects, error) in
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showMessages", sender: self)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ActualMessagingViewController {
            dest.trade = trades[selectedRow]
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
