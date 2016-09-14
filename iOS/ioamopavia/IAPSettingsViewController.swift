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
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "IAPNotificationEnabled")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "IAPNotificationEnabled")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notificationAction(_ sender: AnyObject) {
        if notificationSwitch.isOn {
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
