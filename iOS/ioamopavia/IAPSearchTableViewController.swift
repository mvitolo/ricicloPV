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
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // search2waste
        if segue.identifier == "search2waste" {
            (segue.destination as! IAPWasteViewController).selectedWaste = self.selectedWaste
        }
    }
    // MARK: - Table view data source
}
extension IAPSearchTableViewController : UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.filtered.count)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IAPSearchCell", for: indexPath) as! IAPSearchCell

        cell.waste?.text = filtered[indexPath.row]["Name"].string
        let dispose = filtered[indexPath.row]["DisposeOptions"][0]["disposeOption"].string
        
        let disposeArray = dispose?.components(separatedBy:", ")
        
        cell.dispose.text = IAPEngine.sharedInstance.getDisposeDescritpion(disposeArray!)
        cell.wImage.image = IAPEngine.sharedInstance.getDisposeImage(dispose!)
        
        if (indexPath as NSIndexPath).row%2 == 0 {
            cell.backgroundColor = IAPEngine.sharedInstance.hexStringToUIColor("#daeddb")
        } else {
            cell.backgroundColor = UIColor.white
        }
        

        return cell
    }//daeddb
}
extension IAPSearchTableViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectedWaste = filtered[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

extension IAPSearchTableViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        DispatchQueue.main.async(execute: {
            
            self.searchBar.resignFirstResponder()
            self.tableView.resignFirstResponder()
        })

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        DispatchQueue.main.async(execute: {

        self.searchBar.resignFirstResponder()
        self.tableView.resignFirstResponder()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = (wastes.arrayValue ).filter({ (text) -> Bool in
            let tmp: NSString = text["Name"].string! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            if searchText == "" {
                //filtered = self.wastes.array
            }
            DispatchQueue.main.async(execute: {
                
                self.searchBar.resignFirstResponder()
                self.tableView.resignFirstResponder()
            })

        } else {
            searchActive = true;
        }
        self.tableView.isHidden = !searchActive
        self.emptyView.isHidden = searchActive
        self.tableView.reloadData()
    }
}
