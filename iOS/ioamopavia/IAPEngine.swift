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
    
    static let appTitle = "RicicloPV"
    
    var disposes : JSON!
    var wastes : JSON!
    
     override init() {
        
        super.init()
        disposes = readJson("dispose")["DisposeOptions"]
        wastes = readJson("newdata")
    }
    
    
    func readJson(_ jsonname: String) -> JSON!{
        
        if let path = Bundle.main.path(forResource: jsonname, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
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
    
    func getDisposeDescritpion(_ disposeNames: Array<String>) -> String {
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
    
    func getDisposeImage(_ disposeName:String) -> UIImage {
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
    
    func getDisposeImageBig(_ disposeName:String) -> UIImage {
        switch disposeName {
        case "GLASS":
            return UIImage(named: "vetroBig")!
        case "HUMID":
            return UIImage(named: "umidoBig")!
        case "PAPER":
            return UIImage(named: "cartaBig")!
        case "PLASTIC":
            return UIImage(named: "plasticaBig")!
        case "GENERIC":
            return UIImage(named: "seccoBig")!
        default:
            return UIImage()
        }
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getHeaderLabel() -> String {
        
        let dayoftheweek = Date().dayOfWeek()!
        
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
        let dayoftheweek = Date().dayOfWeek()!
        
        switch dayoftheweek {
        case 1://Sunday
            return "Niente da buttare"
        case 2:
            return "stasera ritirano l'umido"
        case 3:
            return "stasera ritirano la carta"
        case 4:
            return "stasera ritirano l'indifferenziato"
        case 5:
            return "stasera ritirano la plastica"
        case 6:
            return "stasera ritirano l'umido"
        case 7://Saturday
            return "Niente da butare"
        default:
            return ""
        }
    }
    
    func getImageForDay() -> String {
        let dayoftheweek = Date().dayOfWeek()!
        
        switch dayoftheweek {
        case 1://Sunday
            return "smiley"
        case 2:
            return "umidoBig"
        case 3:
            return "cartaBig"
        case 4:
            return "seccoBig"
        case 5:
            return "plasticaBig"
        case 6:
            return "smiley"
        case 7://Saturday
            return "smiley"
        default:
            return "smiley"
        }
    }
    
    func getReminderTitle(_ dayoftheweek: NSInteger) -> String {
        
        switch dayoftheweek {
        case 1://Sunday
            return ""
        case 2:
            return "Ricordati che devi buttare l'Umido!"
        case 3:
            return "Ricordati che devi buttare la Carta!"
        case 4:
            return "Ricordati che devi buttare l'Indifferenziata!"
        case 5:
            return "Ricordati che devi buttare la Plastica!"
        case 6:
            return "Ricordati che devi buttare l'Umido!"
        case 7:
            return ""
        default:
            return ""
        }
    }
    
    func scheduleLocalNotifications() {
        UserDefaults.standard.set(true, forKey: "IAPNotificationEnabled")
        UserDefaults.standard.synchronize()

        for i in 1...4 {
            let fireDate = getDateOfSpecificDay(i)
            let notification = UILocalNotification()
            
            let dict:NSDictionary = ["ID" : String(format:"com.iap.reminder%d",i)]
            notification.userInfo = dict as! [String : String]
            notification.alertBody = getReminderTitle(i)
            notification.alertAction = "Open"
            notification.fireDate = fireDate
            notification.repeatInterval = NSCalendar.Unit.weekday  // Can be used to repeat the notification
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    func unscheduleLocalNotifications() {
        UserDefaults.standard.set(false, forKey: "IAPNotificationEnabled")
        UserDefaults.standard.synchronize()
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func getDateOfSpecificDay(_ day:NSInteger) -> Date {/// here day will be 1 or 2.. or 7
        let desiredWeekday = day
        let weekDateRange = (Calendar.current as NSCalendar).maximumRange(of: NSCalendar.Unit.weekday)
        let daysInWeek =  weekDateRange.length - weekDateRange.location + 1
        
        let dateComponents = (Calendar.current as NSCalendar).components(NSCalendar.Unit.weekday, from: Date())
        let currentWeekDay = dateComponents.weekday
        let differenceDays = (desiredWeekday - currentWeekDay! + daysInWeek) % daysInWeek
        var daysComponents = DateComponents()
        daysComponents.day = differenceDays
        daysComponents.hour = 19
        daysComponents.minute = 0
        daysComponents.second = 0
        
        let resultDate = (Calendar.current as NSCalendar).date(byAdding: daysComponents, to: Date(), options: NSCalendar.Options.matchFirst)
        return resultDate!
    }
    
    func getDisposeData(_ disposeName:String) -> String {
        for dispose in disposes["DisposeOption"].array! {
            if disposeName == dispose["Name"].string{
                let ret = dispose["Description"].string! + "\n" + dispose["Container"].string! + "\n" + dispose["Procedure"].string!
                return ret
            }
        }
        return ""
    }
}

extension Date {
    func dayOfWeek() -> Int? {
        if
            let cal: Calendar = Calendar.current,
            let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self) {
            return comp.weekday
        } else {
            return nil
        }
    }
}
