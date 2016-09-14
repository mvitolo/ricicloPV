//
//  IAPWasteViewController.swift
//  ioamopavia
//
//  Created by Matteo on 13/09/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import SwiftyJSON
import UIKit

class IAPWasteViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var wasteTitle: UILabel!
    var selectedWaste : JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Descrizione Rifiuto"
        self.wasteTitle.text = selectedWaste["Name"].string
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension IAPWasteViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var valcount = 0
        for val in selectedWaste["DisposeOptions"].array! {
            if val["disposeOption"].string == "" {
                
            } else {
                valcount = valcount + 1
            }
        }
        return (valcount)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dispose = selectedWaste["DisposeOptions"][indexPath.row]["disposeOption"].string!

        let im = IAPEngine.sharedInstance.getDisposeImageBig(dispose)
        if im == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IAPWasteNoImageTableViewCell", for: indexPath) as! IAPWasteNoImageTableViewCell
            cell.disposeDescription.text = IAPEngine.sharedInstance.getDisposeData(dispose)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IAPWasteTableViewCell", for: indexPath) as! IAPWasteTableViewCell
            cell.disposeDescription.text = IAPEngine.sharedInstance.getDisposeData(dispose)
            cell.disposeImage.image = im
        
            return cell
        }
    }//daeddb
}

