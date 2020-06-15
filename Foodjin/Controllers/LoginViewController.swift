//
//  ViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 18/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField
import Firebase

class LoginViewController: UIViewController {
    
    //Input Fields Outlets
    @IBOutlet weak var usernameTextField: UnderLineTextField!
    @IBOutlet weak var passwordTextField: UnderLineTextField!

    //Buttons Outlets
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerNowButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        #if DEBUG
            self.usernameTextField.text = "navpreetsingh0790@gmail.com"
            self.passwordTextField.text = "Jaat@1234"
        
//        self.usernameTextField.text = "8283929290" //"7009928796"
//        self.passwordTextField.text = "Admin@1234" //"ARun!@34"

        self.usernameTextField.text = "7009928796"
        self.passwordTextField.text = "ARun!@34"
        
        self.usernameTextField.text = "abhishek1612@yopmail.com"
        self.passwordTextField.text = "Demo@1234"
        
        #endif

    }
    
}

// MARK: IBActions
extension LoginViewController {
    
    @IBAction func ForgotPasswordAction(_ sender: Any) {
        
        guard let forgetPasswordVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController else {return}
        self.navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    
    @IBAction func SignInAction(_ sender: Any) {
        
//        #if DEBUG
//        guard let verificationVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "VerficationViewController") as? VerficationViewController else {return}
//        verificationVC.isFromForgotPassword = false
//        self.navigationController?.pushViewController(verificationVC, animated: true)
//        #else
            self.validate()
//        #endif
    }
    
    @IBAction func RegisterNowAction(_ sender: Any) {
        guard let registerVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {return}
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}


extension LoginViewController {
    func validate() {
        
        if (self.usernameTextField.text?.count ?? 0 <= 0) && (self.passwordTextField.text?.count ?? 0 <= 0 ) {
            self.showAlert(for: "Please enter your Email or Phone Number & Password")
            return
        }
        
        do {
            _ = try usernameTextField.validatedText(validationType: ValidatorType.requiredField(field: "Username"))
            _ = try passwordTextField.validatedText(validationType: ValidatorType.requiredField(field: "Password"))
            
            //            _ = try usernameTextField.validatedText(validationType: ValidatorType.email)
            _ = try passwordTextField.validatedText(validationType: ValidatorType.password)
            
            self.loginIntoApplication()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func loginIntoApplication() {
        
        InstanceID.instanceID().instanceID { (result, error) in
            print("Token:: \(result?.token)")
            if error == nil {
                let fcmDeviceToken = result!.token
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                var email = ""
                var phone = ""
                
                do {
                    if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: self.usernameTextField.text ?? "", options: [], range: NSRange(location: 0, length: self.usernameTextField.text?.count ?? 0)) != nil {
                        
                        email = self.usernameTextField.text ?? ""
                        
                    } else {
                        phone = self.usernameTextField.text ?? ""
                    }
                } catch(let error) {
                    //            showAlert(for: (error as! ValidationError).message)
                }
                
                
                let params = [
                    "Email":email,
                    "Pswd":self.passwordTextField.text ?? "",
                    "Phone":phone,
                    "Imei1":"",
                    "Imei2":"",
                    "DeviceNo":"",
                    "LatPos":appDelegate.latitudeLabel  ?? "0.0",
                    "LongPos":appDelegate.longitudeLabel  ?? "0.0",
                    "ApiKey":API_KEY,
                    "DeviceToken":fcmDeviceToken,
                    "StoreId":STORE_ID ]
                
                Loader.show(animated: true)
                
                WebServiceManager.instance.post(url: Urls.login, params: params, successCompletionHandler: { [unowned self] (jsonData) in
                    Loader.hide()
                    let loginDict = try? JSONDecoder().decode(Register.self, from: jsonData)
                    print(loginDict)
                    
                    if loginDict?.responseObj?.userStatus == "InActive" {
                        print("Navigate to otp Screen with user Id")
                        guard let verificationVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "VerficationViewController") as? VerficationViewController else {return}
                        verificationVC.customerId = loginDict?.responseObj?.userID as? Int
                        verificationVC.isResend = true
                        self.navigationController?.pushViewController(verificationVC, animated: true)
                    } else {
                        //land to main screen
                        let uId = "\(loginDict?.responseObj?.userID ?? 0)"
                        UserDefaults.standard.set(uId, forKey: userId)
                        
                        guard let landingVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LandingTabbarController") as? LandingTabbarController else {return}
                        landingVC.selectedIndex = 1
                        //refrence to tab bar beavuse cart button not working on login
                        appDelegate.tabbarController = landingVC
                        self.navigationController?.pushViewController(landingVC, animated: false)
                    }
                    
                }) { (ResponseStatus) in
                    Loader.hide()
                    self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
                }
            }
            
        }
        
    }
    
}
