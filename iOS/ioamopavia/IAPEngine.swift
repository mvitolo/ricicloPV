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
        wastes = readJson("newdata")
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
    
    func getDisposeDescritpion(disposeNames: Array<String>) -> String {
        var ret:String = ""
        var counter = 0
        for dispose in disposes["DisposeOption"].array! {
            for choosenDispose in disposeNames {
                if choosenDispose == dispose["Name"].string{
                    if counter > 0 {
                        ret = ret + ", "
                    }
                    ret = ret+dispose["Description"].string!
                    counter = counter + 1
                }
            }
        }
        return ret
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
    
    func getHeaderLabel() -> String {
        
        let dayoftheweek = NSDate().dayOfWeek()!
        
        switch dayoftheweek {
        case 1://Sunday
            return "Oggi è Domenica"
        case 2://Monday
            return "Oggi è Lunedí"
        case 3://Tuesday
            return "Oggi è Martedí"
        case 4://Wednsday
            return "Oggi è Mercoledí"
        case 5://Thursday
            return "Oggi è Giovedí"
        case 6://Friday
            return "Oggi è Venerdí"
        case 7://Saturday
            return "Oggi è Sabato"
        default:
            return ""
        }
    }
    
    func getFooterLabel() -> String {
        let dayoftheweek = NSDate().dayOfWeek()!
        
        switch dayoftheweek {
        case 1://Sunday
            return "Niente da buttare"
        case 2://Monday
            return "bisogna buttare l'umido"
        case 3://Tuesday
            return "bisogna buttare la carta"
        case 4://Wednsday
            return "bisogna buttare l'indifferenziato"
        case 5://Thursday
            return "bisogna buttare la plastica"
        case 6://Friday
            return "bisogna buttare l'umido"
        case 7://Saturday
            return "Niente da butare"
        default:
            return ""
        }
    }
    
    func getImageForDay() -> String {
        let dayoftheweek = NSDate().dayOfWeek()!
        
        switch dayoftheweek {
        case 1://Sunday
            return "smiley"
        case 2://Monday
            return "umidoBig"
        case 3://Tuesday
            return "cartaBig"
        case 4://Wednsday
            return "seccoBig"
        case 5://Thursday
            return "plasticaBig"
        case 6://Friday
            return "umidoBig"
        case 7://Saturday
            return "smiley"
        default:
            return "smiley"
        }
    }
}

extension NSDate {
    func dayOfWeek() -> Int? {
        if
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) {
            return comp.weekday
        } else {
            return nil
        }
    }
}
