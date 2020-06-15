//
//  ForgotPasswordViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 19/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UnderLineTextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        #if DEBUG
            self.emailTextField.text = "navpreetsingh0790@gmail.com"
        #endif

    }
}

extension ForgotPasswordViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendLinkAction(_ sender: Any) {
        self.validate()
    }
    
    func validate() {
        do {
            _ = try emailTextField.validatedText(validationType: ValidatorType.requiredField(field: "Email/Phone"))
//            _ = try emailTextField.validatedText(validationType: ValidatorType.email)
            
            self.forgotPasswordApi()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func forgotPasswordApi() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var email = ""
        var phone = ""
        
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: self.emailTextField.text ?? "", options: [], range: NSRange(location: 0, length: self.emailTextField.text?.count ?? 0)) != nil {
                
//                 _ = try emailTextField.validatedText(validationType: ValidatorType.email)
                
                email = self.emailTextField.text ?? ""
                
            } else {
                phone = self.emailTextField.text ?? ""
            }
        } catch(let error) {
//            showAlert(for: (error as! ValidationError).message)
        }
    

        
        let params = [
            "Email":email,
            "Phone":phone,
            "Imei1":"",
            "Imei2":"",
            "DeviceNo":"",
            "LatPos":appDelegate.latitudeLabel  ?? "0.0",
            "LongPos":appDelegate.longitudeLabel  ?? "0.0",
            "ApiKey":API_KEY,
            "DeviceToken":"",
            "StoreId":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.forgotPasswword, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let loginDict = try? JSONDecoder().decode(Register.self, from: jsonData)
            print(loginDict)
            
            //get Userid and Otp navigate to Otp Screen
            guard let verificationVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "VerficationViewController") as? VerficationViewController else {return}
            verificationVC.isFromForgotPassword = true
            verificationVC.customerId = loginDict?.responseObj?.userID as? Int
            self.navigationController?.pushViewController(verificationVC, animated: true)
//            self.showAlertWithTitle(title: "Alert", msg: "OTP sent successfully to your registered mobile number")

        }) { (ResponseStatus) in
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func navigateTOCreatePassword() {
        guard let createPasswordVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CreatePasswordViewController") as? CreatePasswordViewController else {return}
        self.navigationController?.pushViewController(createPasswordVC, animated: true)
    }
}
