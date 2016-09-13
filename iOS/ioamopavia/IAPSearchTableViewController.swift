//
//  IAPSearchTableViewController.swift
//  ioamopavia
//
//  Created by Matteo on 03/06/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import UIKit
import SwiftyJSON

class IAPSearchTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   // @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var emptyView: UIView!
    
    var disposes : JSON!
    var wastes : JSON!
    var filtered : [JSON]!
    var selectedWaste : JSON!
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))

    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.disposes = IAPEngine.sharedInstance.disposes
        self.wastes = IAPEngine.sharedInstance.wastes
        self.filtered = self.wastes.arrayValue
       //self.title = "Differenziata PV"
        searchBar.placeholder = "Cosa vuoi buttare?"
   //     let leftNavBarButton = UINavigationItem(customView:searchBar)
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self

    }

    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // search2waste
        if segue.identifier == "search2waste" {
            (segue.destinationViewController as! IAPWasteViewController).selectedWaste = self.selectedWaste
        }
    }
    // MARK: - Table view data source
}
extension IAPSearchTableViewController : UITableViewDataSource{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.filtered.count)
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
extension IAPSearchTableViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        selectedWaste = filtered[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }
}

extension IAPSearchTableViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        dispatch_async(dispatch_get_main_queue(), {
            
            self.searchBar.resignFirstResponder()
            self.tableView.resignFirstResponder()
        })

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        dispatch_async(dispatch_get_main_queue(), {

        self.searchBar.resignFirstResponder()
        self.tableView.resignFirstResponder()
        })
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
                //filtered = self.wastes.array
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                self.searchBar.resignFirstResponder()
                self.tableView.resignFirstResponder()
            })

        } else {
            searchActive = true;
        }
        self.tableView.hidden = !searchActive
        self.emptyView.hidden = searchActive
        self.tableView.reloadData()
    }
}
