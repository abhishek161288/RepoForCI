//
//  VerficationViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 23/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class VerficationViewController: UIViewController {

    @IBOutlet weak var codeView: SwiftyCodeView!
    @IBOutlet weak var titleLabel: UILabel!
    var isResend:Bool?
    var customerId: Int?
    var OtpCode: String?
    var isFromForgotPassword:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.isResend == true {
            self.resendOtpApi()
        }
        if let from = isFromForgotPassword, from {
            titleLabel.text = "OTP Verification"
        }
        else {
            titleLabel.text = "Registration Verification "
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //resend Otp
    @IBAction func resendOtpButtonAction(_ sender: Any) {
       self.resendOtpApi()
    }
    
    func resendOtpApi() {
        //Api Hit
        let params = [
            "CustomerId": "\(self.customerId ?? 0)",
            "ApiKey": API_KEY,
            "Imei1": "",
            "Imei2": "",
            "DeviceNo": "",
            "LatPos": "",
            "LongPos": "",
            "StoreId": STORE_ID,
            "DeviceToken": ""
        ]
        
        print(params)
        
         Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.resendOtp, params: params, successCompletionHandler: { [unowned self] (jsonData) in
             Loader.hide()
            let verifyDict = try? JSONDecoder().decode(ResendOtpResponse.self, from: jsonData)
            print(verifyDict)
            
            //self.showAlertWithTitle(title: verifyDict?.errorMessageTitle ?? "", msg: verifyDict?.errorMessage ?? "")

        }) { (ResponseStatus) in
             Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    @IBAction func verifyButtonAction(_ sender: Any) {
        self.validate()
    }
    
    @IBAction func havingTroubleButtonAction(_ sender: Any) {
        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        pVC.titleLableText = "Help"
        pVC.toOpenHTML = GetHelp
        self.navigationController?.pushViewController(pVC, animated: true)
        //        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "PolicyViewController") as? PolicyViewController else {return}
        //        pVC.titleLableText = "Help"
        //        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    func validate() {
        do {
            if self.codeView.code.count ?? 0 < 4 {
                throw ValidationError("Please enter the 4 digit OTP sent on your phone number")
            }
            self.verfiyApi()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func verfiyApi() {
        //Api Hit
        self.OtpCode = self.codeView.code
        let params = ["CustomerId": "\(self.customerId ?? 0)",
            "OTP": self.OtpCode ?? "",
            "ApiKey": API_KEY ]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.registerVerfication, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            
            Loader.hide()
            let verifyDict = try? JSONDecoder().decode(VerifyRegistration.self, from: jsonData)
            print(verifyDict)
            
            //save userId to userdefaults
            guard let id = verifyDict?.responseObj else { return }
            
            if self.isFromForgotPassword == true {
                //Navigate to Create new password Screen
                guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CreatePasswordViewController") as? CreatePasswordViewController else {return}
                newVC.customerId = id
                newVC.OtpCode = self.OtpCode
                self.navigationController?.pushViewController(newVC, animated: true)
            } else {
                guard let landingVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LandingTabbarController") as? LandingTabbarController else {return}
                landingVC.selectedIndex = 1
                //refrence to tab bar beavuse cart button not working on login
                appDelegate.tabbarController = landingVC
                self.navigationController?.pushViewController(landingVC, animated: false)
                //self.navigationController?.popToRootViewController(animated: true)
            }
            
            //self.showAlertWithTitle(title: verifyDict?.errorMessageTitle ?? "", msg: verifyDict?.errorMessage ?? "")

        }) { (ResponseStatus) in
            
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
}

extension VerficationViewController: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) {
        print("Entered code: ", code)
        self.OtpCode = code
    }
    func codeView(sender: SwiftyCodeView, didChangeInput code: String) {
        
    }

}
