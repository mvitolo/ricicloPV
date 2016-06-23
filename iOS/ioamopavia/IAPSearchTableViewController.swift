//
//  IAPSearchTableViewController.swift
//  ioamopavia
//
//  Created by Matteo on 03/06/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import UIKit
import SwiftyJSON

class IAPSearchTableViewController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    
    var disposes : JSON!
    var wastes : JSON!
    var filtered : [JSON]!
    
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.disposes = IAPEngine.sharedInstance.disposes
        self.wastes = IAPEngine.sharedInstance.wastes
        self.filtered = self.wastes.arrayValue
        self.title = "Differenziata PV"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.filtered.count)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IAPSearchCell", forIndexPath: indexPath) as! IAPSearchCell

        cell.waste?.text = filtered[indexPath.row]["Name"].string
        let dispose = filtered[indexPath.row]["DisposeOptions"][0]["disposeOption"].string
        
        let disposeArray = dispose?.componentsSeparatedByString(", ")
        
        cell.dispose.text = IAPEngine.sharedInstance.getDisposeDescritpion(disposeArray!)
        cell.wImage.image = IAPEngine.sharedInstance.getDisposeImage(dispose!)
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = IAPEngine.sharedInstance.hexStringToUIColor("#daeddb")
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        

        return cell
    }//daeddb

}

extension IAPSearchTableViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = (wastes.arrayValue ).filter({ (text) -> Bool in
            let tmp: NSString = text["Name"].string!
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            if searchText == "" {
                filtered = self.wastes.array
            }
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
