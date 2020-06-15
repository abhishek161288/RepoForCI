//
//  EditProfileViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 26/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField
//import libPhoneNumber_iOS
import CountryPicker
import MapleBacon

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UnderLineTextField!
    @IBOutlet weak var firstNameTextField: UnderLineTextField!
    @IBOutlet weak var lastNameTextField: UnderLineTextField!
    @IBOutlet weak var countryCodeTextField: UnderLineTextField!
    @IBOutlet weak var phoneNumberTextField: UnderLineTextField!
    
    var picker: CountryPicker!
    var imagePicker: ImagePicker!
    var profileDict: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.countryCodeTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        //setting
        self.profileImageView.setImage(with: URL(string: self.profileDict?.responseObj?.profilePic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.firstNameTextField.text = "\(self.profileDict?.responseObj?.firstName ?? "")"
        self.lastNameTextField.text = "\(self.profileDict?.responseObj?.lastName ?? "")"
        self.countryCodeTextField.text = "+"+"\(self.profileDict?.responseObj?.mobileStd ?? 0)"
        self.phoneNumberTextField.text = "\(self.profileDict?.responseObj?.mobileNo ?? "")"
        self.emailTextField.text = "\(self.profileDict?.responseObj?.email ?? "")"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        picker = CountryPicker()
        picker.displayOnlyCountriesWithCodes = CountryCodes.codes
        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: false)
        picker.theme = theme
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        countryCodeTextField.inputView = picker
        
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

extension EditProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
    }
}

//Ibactions
extension EditProfileViewController {
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        self.validate()
    }
    
    @IBAction func PickProfilePictureButtonAction(_ sender: Any) {
        print("Pick Profile Picture")
        self.imagePicker.present(from: sender as! UIButton)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
//        if textField == self.phoneNumberTextField {
//            let allowedCharacters = CharacterSet(charactersIn:"+0123456789")//Here change this characters based on your requirement
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
        
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
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.countryCodeTextField {
//            //            print(picker.currentCountry?.phoneCode)
//            if picker.currentCountry?.phoneCode == nil {
//                self.countryCodeTextField.text = "+93"
//            } else {
//                self.countryCodeTextField.text = picker.currentCountry?.phoneCode
//            }
//        }
//    }
}

extension EditProfileViewController: CountryPickerDelegate {
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //        print(phoneCode)
        self.countryCodeTextField.text = phoneCode
    }
}


extension EditProfileViewController {
    
    func validate() {
        do {
            //_ = try emailTextField.validatedText(validationType: ValidatorType.requiredField(field: "Email"))
            
           // _ = try emailTextField.validatedText(validationType: ValidatorType.email)
            _ = try firstNameTextField.validatedText(validationType: ValidatorType.requiredField(field: "First Name"))
            _ = try lastNameTextField.validatedText(validationType: ValidatorType.requiredField(field: "Last Name"))
            //_ = try countryCodeTextField.validatedText(validationType: ValidatorType.requiredField(field: "Country Code"))
           // _ = try phoneNumberTextField.validatedText(validationType: ValidatorType.requiredField(field: "10 digit Phone Number"))
            
//            if phoneNumberTextField.text?.count ?? 0 < 10 {
//                throw ValidationError("Invalid Phonenumber")
//            }
//            if phoneNumberTextField.text?.count ?? 0 > 10 {
//                throw ValidationError("Invalid Phonenumber")
//            }
            
            self.updateProfileApi()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func updateProfileApi() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }

        let proImage = self.profileImageView.image?.jpegData(compressionQuality: 0.1)
        let strBase64 = proImage?.base64EncodedString(options: .lineLength64Characters)
//        print(strBase64)
        
        //Api Hit
        let params = ["Id":id,
                      "FirstName": self.firstNameTextField.text ?? "",
                      "LastName": self.lastNameTextField.text ?? "",
            "Pswd": "",
            "ProfilePic": strBase64 ?? "",
            "Imei1": "",
            "Imei2": "",
            "DeviceNo": "",
            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
            "LongPos": appDelegate.longitudeLabel ?? "0.0",
            "ApiKey":API_KEY,
            "StoreId":STORE_ID,
            "DeviceToken":""]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.updateCustomerDetails, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let registerDict = try? JSONDecoder().decode(Register.self, from: jsonData)
           // print(registerDict)

            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.showAlertWithTitle(title: registerDict?.errorMessageTitle ?? "", msg: registerDict?.errorMessage ?? "")

        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
        
    }
    
}
