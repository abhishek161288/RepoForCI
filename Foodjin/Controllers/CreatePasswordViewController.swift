//
//  CreatePasswordViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 23/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField

class CreatePasswordViewController: UIViewController {

    var customerId: Int?
    var OtpCode: String?


    @IBOutlet weak var newPasswordTextField: UnderLineTextField!
    @IBOutlet weak var confirmPasswordTextField: UnderLineTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}

extension CreatePasswordViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPaswordAction(_ sender: Any) {
        self.validate()
    }
    
    @IBAction func troubleSignInAction(_ sender: Any) {
//        print("get Help Screen")
        
//        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "PolicyViewController") as? PolicyViewController else {return}
//        pVC.titleLableText = "Help"
//        self.navigationController?.pushViewController(pVC, animated: true)
        
        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        pVC.titleLableText = "Help"
        pVC.toOpenUrl = "http://dev.foodjin.org/get-help"
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    func validate() {
        do {
            _ = try newPasswordTextField.validatedText(validationType: ValidatorType.requiredField(field: "New Password"))
            _ = try newPasswordTextField.validatedText(validationType: ValidatorType.password)

            _ = try confirmPasswordTextField.validatedText(validationType: ValidatorType.requiredField(field: "Confirm Password"))
            _ = try confirmPasswordTextField.validatedText(validationType: ValidatorType.password)
            
            self.resetPasswordApi()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func resetPasswordApi() {
        //Api Hit
        let params = ["ApiKey":API_KEY,
                      "StoreId":STORE_ID,
                      "OTP": self.OtpCode ?? "",
                      "NewPassword": self.confirmPasswordTextField.text ?? "",
                      "CustomerId":  "\(self.customerId ?? 0)",
                    ]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.createPassword, params: params, successCompletionHandler: { [unowned self] (jsonData) in
             Loader.hide()
            let registerDict = try? JSONDecoder().decode(ResetPassword.self, from: jsonData)
            print(registerDict)

            self.navigationController?.popToRootViewController(animated: true)
            
            self.showAlertWithTitle(title: registerDict?.errorMessageTitle ?? "", msg: registerDict?.errorMessage ?? "")
            
            }) { (ResponseStatus) in
                Loader.hide()
                self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
            }
    }
}
