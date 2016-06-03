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
    
    func getDisposeDescritpion(disposeName: String) -> String {
        
        for dispose in disposes["DisposeOption"].array! {
            if disposeName == dispose["Name"].string{
                return dispose["Description"].string!
            }
        }
        return ""
    }
    
    func getDisposeImage(disposeName:String) -> UIImage {
        switch disposeName {
        case "GLASS":
            return UIImage(named: "vetro")!
        case "HUMID":
            return UIImage(named: "umido")!
        case "PAPER":
            return UIImage(named: "carta")!
        case "PLASTIC":
            return UIImage(named: "plastica")!
        case "GENERIC":
            return UIImage(named: "secco")!
        default:
            return UIImage()
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
