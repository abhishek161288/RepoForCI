//
//  ChangePasswordViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextField: UnderLineTextField!
    @IBOutlet weak var newPasswordTextField: UnderLineTextField!
    @IBOutlet weak var confirmPasswordTextField: UnderLineTextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        #if DEBUG
//        self.oldPasswordTextField.text = "Done@1234"
//        self.newPasswordTextField.text = "Jaat@1234"
//        self.confirmPasswordTextField.text = "Jaat@1234"
        #endif
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

//Ibactions
extension ChangePasswordViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        self.validate()
    }
    
    func validate() {
        do {
            _ = try oldPasswordTextField.validatedText(validationType: ValidatorType.requiredField(field: "Old Password"))
            _ = try oldPasswordTextField.validatedText(validationType: ValidatorType.password)

            _ = try newPasswordTextField.validatedText(validationType: ValidatorType.requiredField(field: "New Password"))
            _ = try newPasswordTextField.validatedText(validationType: ValidatorType.password)

            _ = try confirmPasswordTextField.validatedText(validationType: ValidatorType.requiredField(field: "Confirm Password"))
            _ = try confirmPasswordTextField.validatedText(validationType: ValidatorType.password)

            
            if newPasswordTextField.text != confirmPasswordTextField.text {
                throw ValidationError("Password Mismatch")
            }
            
            self.changePassword()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func changePassword() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "OldPassword": self.oldPasswordTextField.text ?? "",
            "NewPassword": self.newPasswordTextField.text ?? "",
            "ApiKey":API_KEY,
            "CustomerId":id ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.resetPassword, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(ResetPassword.self, from: jsonData)
            
            ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController).popToRootViewController(animated: true)
            self.navigationController?.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")

            
        }) { (ResponseStatus) in
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
}
