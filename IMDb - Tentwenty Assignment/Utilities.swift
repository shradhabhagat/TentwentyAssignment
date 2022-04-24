//
//  Utilities.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import SVProgressHUD
import UIKit

class Utilities {
    static func showLoader(message: String = "Please wait..."){
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.light)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show(withStatus: message)
        }
        
    }
    
    static func hideLoader(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    class func getAppDelegate() -> AppDelegate {
        return (UIApplication.shared.delegate as? AppDelegate) ?? AppDelegate()
    }
    
    class func showAlert(vc: UIViewController?, title: String,havingSubtitle subtitle:String, buttonName: String, perform:(() -> Void)? = nil){
        let alert = UIAlertController.init(title: title, message: subtitle, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: buttonName, style: .default, handler: {(action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            if let completion = perform{
                completion()
            }
        })
        alert.addAction(ok)
        vc?.present(alert, animated: true, completion: nil)
    }
}
