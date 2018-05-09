//
//  YourTradesViewController.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/7/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import Parse

class YourTradesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var yourTrades:[Trade]!
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TradeTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "tradeCell")
        yourTrades = [Trade]()
        
        //updateTrades()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .done, target: self, action: #selector(YourTradesViewController.addTrade))

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        updateTrades()
    }
    
    func updateTrades() {
        yourTrades.removeAll()
        tableView.reloadData()
        let query = PFQuery(className: "Trade")
        query.whereKey("requester", equalTo: PFUser.current())
        query.whereKeyDoesNotExist("match")
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                if objects!.count > 0 {
                    self.yourTrades.removeAll()
                    print("Fetched \(objects!.count) objects")
                    for object in objects! {
                        self.yourTrades.append(object as! Trade)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @objc func addTrade() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tradeDetails") as! TradeDetailsViewController
        vc.vcType = Type.NewTrade
        let navContr = UINavigationController(rootViewController: vc)
        self.present(navContr, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count is \(yourTrades.count)")
        return yourTrades.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Making a cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tradeCell") as! TradeTableViewCell
        cell.trade = yourTrades[indexPath.row]
        return cell
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
        if let dest = segue.destination as? TradeDetailsViewController {
            dest.trade = yourTrades[selectedRow]
            dest.vcType = Type.ExistingTrade
        }
    }
    

}
