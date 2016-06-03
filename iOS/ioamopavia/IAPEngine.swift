//
//  IAPEngine.swift
//  ioamopavia
//
//  Created by Matteo on 03/06/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import UIKit
import SwiftyJSON

class IAPEngine: NSObject {
    static let sharedInstance = IAPEngine()
    
    var disposes : JSON!
    var wastes : JSON!
    
     override init() {
        
        super.init()
        disposes = readJson("dispose")["DisposeOptions"]
        wastes = readJson("data")
    }
    
    
    func readJson(jsonname: String) -> JSON!{
        
        if let path = NSBundle.mainBundle().pathForResource(jsonname, ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    print("jsonData:\(jsonObj)")
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
                return jsonObj
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
}
