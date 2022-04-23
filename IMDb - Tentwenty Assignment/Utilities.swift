//
//  Utilities.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import SVProgressHUD

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
}
