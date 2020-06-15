//
//  SignUpViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 23/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField
//import libPhoneNumber_iOS
import CountryPicker

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UnderLineTextField!
    @IBOutlet weak var firstNameTextField: UnderLineTextField!
    @IBOutlet weak var lastNameTextField: UnderLineTextField!
    @IBOutlet weak var countryCodeTextField: UnderLineTextField!
    @IBOutlet weak var phoneNumberTextField: UnderLineTextField!
    @IBOutlet weak var passwordTextField: UnderLineTextField!
    @IBOutlet weak var confirmPasswordTextField: UnderLineTextField!
    @IBOutlet weak var confirmationLabel: UIButton!
    var currentCountryCode = NSLocale.current.regionCode

    var picker: CountryPicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let countryCode = NSLocale.object(NSLocale.cu)
//        for country in countryCode {
//            print(country)
//        }

        // Do any additional setup after loading the view.
        #if DEBUG
//            self.emailTextField.text = "navpreetsingh0790@gmail.com"
//            self.firstNameTextField.text = "Navpreet"
//            self.lastNameTextField.text = "Singh"
//            self.countryCodeTextField.text = "+91"
//            self.phoneNumberTextField.text = "9779677670"
//            self.passwordTextField.text = "Asdf"
//            self.confirmPasswordTextField.text = "Asdf"
        #endif
        
        self.phoneNumberTextField.delegate = self
        self.countryCodeTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
//        let appVersion = Bundle.main.object(forInfoDictionaryKey: "Bundle display name")
//        confirmationLabel.setTitle("By Using this app, you agree to \(appVersion)'s", for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        picker = CountryPicker()
        picker.displayOnlyCountriesWithCodes = CountryCodes.codes
        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: false)
        picker.theme = theme
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        self.countryCodeTextField.inputView = picker

//        for i in self.countryCodeValues {
//            if i["code"] == {
//                self.countryCodeTextField.text = i["dial_code"]
//            }
//        }
        
        //print(self.currentCountryCode)
        
       // print(picker?.countries)
        
        if let path = Bundle.main.path(forResource: "Dial_Codes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Array<Any>
                //print(jsonResult)
                
                for i in jsonResult ?? [] {
                    if let ii = i as? Dictionary<String, String> {
                        if ii["code"] == self.currentCountryCode {
                            self.countryCodeTextField.text = ii["dial_code"]
                            break;
                        }
                    }
                }
                
            } catch {
                // handle error
                print("Could Not found locale")
                self.countryCodeTextField.text = ""
            }
        }
    }
    

}

extension SignUpViewController {
    @IBAction func registerButtonAction(_ sender: Any) {
        self.validate()
    }
    
    @IBAction func termsAndConditionsButtonAction(_ sender: Any) {
//        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "PolicyViewController") as? PolicyViewController else {return}
//        pVC.titleLableText = "Terms of Use"
//        self.navigationController?.pushViewController(pVC, animated: true)
        
        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        pVC.titleLableText = "Terms of Use"
        pVC.toOpenHTML = TermsCondition
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    @IBAction func privacyPoliciesButtonAction(_ sender: Any) {
//        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "PolicyViewController") as? PolicyViewController else {return}
//        pVC.titleLableText = "Privacy Policy"
//        self.navigationController?.pushViewController(pVC, animated: true)
        
        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        pVC.titleLableText = "Privacy Policy"
        pVC.toOpenHTML = Privacy
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    @IBAction func haveAnAccountAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == self.phoneNumberTextField {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        if textField == self.firstNameTextField {
            let allowedCharacters = CharacterSet(charactersIn:"QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        if textField == self.lastNameTextField {
            let allowedCharacters = CharacterSet(charactersIn:"QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.countryCodeTextField {
//            print(picker.currentCountry?.phoneCode)
            if picker.currentCountry?.phoneCode == nil {
                self.countryCodeTextField.text = "+93"
            } else {
                self.countryCodeTextField.text = picker.currentCountry?.phoneCode
            }
        }
    }
}

extension SignUpViewController: CountryPickerDelegate {
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//        print(phoneCode)
        self.countryCodeTextField.text = phoneCode
    }
}

extension SignUpViewController {
    func validate() {
        do {
            _ = try emailTextField.validatedText(validationType: ValidatorType.requiredField(field: "Email"))
            _ = try emailTextField.validatedText(validationType: ValidatorType.email)
            _ = try firstNameTextField.validatedText(validationType: ValidatorType.requiredField(field: "First Name"))
            _ = try lastNameTextField.validatedText(validationType: ValidatorType.requiredField(field: "Last Name"))
            _ = try countryCodeTextField.validatedText(validationType: ValidatorType.requiredField(field: "Country Code"))
            _ = try phoneNumberTextField.validatedText(validationType: ValidatorType.requiredField(field: "10 digit Phone Number"))

            if phoneNumberTextField.text?.count ?? 0 < 10 {
                throw ValidationError("Invalid Phonenumber")
            }
            if phoneNumberTextField.text?.count ?? 0 > 10 {
                throw ValidationError("Invalid Phonenumber")
            }
            
            _ = try passwordTextField.validatedText(validationType: ValidatorType.requiredField(field: "Password"))
            _ = try passwordTextField.validatedText(validationType: ValidatorType.password)

            _ = try confirmPasswordTextField.validatedText(validationType: ValidatorType.requiredField(field: "Confirm Password"))
            _ = try confirmPasswordTextField.validatedText(validationType: ValidatorType.password)
            
            if passwordTextField.text != confirmPasswordTextField.text {
                throw ValidationError("Password Mismatch")
            }
            
            self.registerIntoApplication()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func registerIntoApplication() {
        print("\(self.countryCodeTextField.text ?? "")\(" ")\(self.phoneNumberTextField.text  ?? "")")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        //Api Hit
        let params = ["Id":"0",
            "FirstName": self.firstNameTextField.text ?? "",
            "LastName": self.lastNameTextField.text ?? "",
            "Email":    self.emailTextField.text ?? "",
            "MobileNo": "\(self.countryCodeTextField.text ?? "")\(" ")\(self.phoneNumberTextField.text  ?? "")",
            "Pswd": self.passwordTextField.text ?? "",
            "ProfilePic": "",
            "Imei1": "",
            "Imei2": "",
            "DeviceNo": "",
            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
            "LongPos": appDelegate.longitudeLabel ?? "0.0",
            "ApiKey":API_KEY,
            "StoreId":STORE_ID,
            "DeviceToken":"",
            "DeviceType":""]
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.register, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let registerDict = try? JSONDecoder().decode(Register.self, from: jsonData)
            print(registerDict)
            let uId = "\(registerDict?.responseObj?.userID ?? 0)"
            UserDefaults.standard.set(uId, forKey: userId)
            guard let verificationVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "VerficationViewController") as? VerficationViewController else {return}
            verificationVC.isFromForgotPassword = false
            verificationVC.customerId = registerDict?.responseObj?.userID as? Int
            self.navigationController?.pushViewController(verificationVC, animated: true)
            
        }) { (ResponseStatus) in
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
}
