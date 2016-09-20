//
//  IAPReminderViewController.swift
//  ioamopavia
//
//  Created by Matteo on 28/08/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import UIKit

class IAPReminderViewController: UIViewController {

    @IBOutlet weak var imageWaste: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var footerlaebl: UILabel!
    
    @IBOutlet weak var downtownImage: UIImageView!
    @IBOutlet weak var downtownDescription: UILabel!
    @IBOutlet weak var suburbsImage: UIImageView!
    @IBOutlet weak var suburbDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isZoneSet = UserDefaults.standard.object(forKey: "IAPHomeZone") == nil
        self.imageWaste.isHidden = isZoneSet
        //self.headerLabel.hidden = isZoneSet
        self.footerlaebl.isHidden = isZoneSet
        
        self.downtownImage.isHidden = !isZoneSet
        self.downtownDescription.isHidden = !isZoneSet
        self.suburbsImage.isHidden = !isZoneSet
        self.suburbDescription.isHidden = !isZoneSet
        
        if isZoneSet == false {
            
        
        } else {
            let dayoftheweek = Date().dayOfWeek()!
            let cityZone = UserDefaults.standard.integer(forKey: "IAPHomeZone")
            self.headerLabel.text = IAPEngine.sharedInstance.getHeaderLabel(dayoftheweek, cityZone)
            self.footerlaebl.text = IAPEngine.sharedInstance.getFooterLabel(dayoftheweek, cityZone)
            self.imageWaste.image = UIImage(named: IAPEngine.sharedInstance.getImageForDay(dayoftheweek, cityZone))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
