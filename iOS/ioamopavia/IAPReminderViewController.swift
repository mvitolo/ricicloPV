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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerLabel.text = IAPEngine.sharedInstance.getHeaderLabel()
        self.footerlaebl.text = IAPEngine.sharedInstance.getFooterLabel()
        self.imageWaste.image = UIImage(named: IAPEngine.sharedInstance.getImageForDay())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
