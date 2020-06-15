//
//  UIViewController+Extensions.swift
//  Foodjin
//
//  Created by Navpreet Singh on 24/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(title: String, msg: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func saveStringToUserdefaults(value: String?, key: String) {
        //unbind
        guard let str = value else { return }
        UserDefaults.standard.set(str, forKey: "name")
    }
    
    func getStringFromUserdefaults(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }

}
