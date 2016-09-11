//
//  IAPSettingsViewController.swift
//  ioamopavia
//
//  Created by Matteo on 11/09/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import UIKit

class IAPSettingsViewController: UIViewController {

    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("IAPNotificationEnabled")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notificationSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("IAPNotificationEnabled")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notificationAction(sender: AnyObject) {
        if notificationSwitch.on {
            IAPEngine.sharedInstance.scheduleLocalNotifications()
        } else {
            IAPEngine.sharedInstance.unscheduleLocalNotifications()
        }
        
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
