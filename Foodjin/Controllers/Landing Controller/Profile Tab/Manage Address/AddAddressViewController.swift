//
//  AddAddressViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField

class AddAddressViewController: UIViewController {

    @IBOutlet weak var lineOneTextField: MVPlaceSearchTextField!
    @IBOutlet weak var lineTwoTextField: UnderLineTextField!
    @IBOutlet weak var cityTextField: UnderLineTextField!
    @IBOutlet weak var zipCodeTextField: UnderLineTextField!
    @IBOutlet weak var otherTextField: UnderLineTextField!
    @IBOutlet weak var stackView: UIStackView!

    
    var lable: String?
    var lableId: Int = 1

    var address: AddressArray?
    var isFromAddLocationButton: Bool?

    var isFromAddAddress: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //print(self.address)
        
        self.lineOneTextField.placeSearchDelegate                 = self;
        self.lineOneTextField.strApiKey                           = "AIzaSyDwhX90LbY7RdQ1yGT7WvI0IQ_J2na-5gg";
        self.lineOneTextField.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
        self.lineOneTextField.autoCompleteShouldHideOnSelection   = true;
        self.lineOneTextField.maximumNumberOfAutoCompleteRows     = 5;
        
        self.otherTextField.isHidden = true
        
        self.cityTextField.text = self.address?.city ?? ""
        self.lineOneTextField.text = self.address?.addressLine1 ?? ""
        self.lineTwoTextField.text = self.address?.addressLine2 ?? ""
        self.zipCodeTextField.text = self.address?.zipCode ?? ""
        
        
        let buttonsArray = self.stackView.subviews
        
        if self.address?.label == "Other" {
            
            self.lable = self.address?.label ?? ""
            self.lableId = 3
            
            let getButton = buttonsArray[2] as? UIButton
            getButton?.backgroundColor = primaryColor
            getButton?.setTitleColor(UIColor.white, for: .normal)
            getButton?.setImage(UIImage(named: "otherIcon_AddAddress(white)"), for: .normal)
            self.otherTextField.isHidden = false
            
            self.otherTextField.text = self.address?.label ?? ""
            
        } else if self.address?.label == "Work" {
            self.lable = "Work"
            self.lableId = 2
            
            let getButton = buttonsArray[1] as? UIButton
            getButton?.backgroundColor = primaryColor
            getButton?.setTitleColor(UIColor.white, for: .normal)
            getButton?.setImage(UIImage(named: "workIcon_AddAddress(white)"), for: .normal)
            self.otherTextField.isHidden = true
        }
        else if self.address?.label == "Home" {
            self.lable = "Home"
            self.lableId = 1
            
            let getButton = buttonsArray[0] as? UIButton
            getButton?.backgroundColor = primaryColor
            getButton?.setTitleColor(UIColor.white, for: .normal)
            getButton?.setImage(UIImage(named: "homeIcon_AddAddress(white)"), for: .normal)
            self.otherTextField.isHidden = true
        }
            
        else {
            if address != nil {
                self.lable = "Other"
                self.lable = self.address?.label ?? ""
                self.lableId = 3
                
                let getButton = buttonsArray[2] as? UIButton
                getButton?.backgroundColor = primaryColor
                getButton?.setTitleColor(UIColor.white, for: .normal)
                getButton?.setImage(UIImage(named: "otherIcon_AddAddress(white)"), for: .normal)
                self.otherTextField.isHidden = false
                
                self.otherTextField.text = self.address?.label ?? ""
            }
            else {
                self.lable = "Home"
                self.lableId = 1
                
                let getButton = buttonsArray[0] as? UIButton
                getButton?.backgroundColor = primaryColor
                getButton?.setTitleColor(UIColor.white, for: .normal)
                getButton?.setImage(UIImage(named: "homeIcon_AddAddress(white)"), for: .normal)
                self.otherTextField.isHidden = true
            }
        }
    }
    
    
    func addAddressApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let lat = Double(self.address?.latPos ?? 0.0)
        let long = Double(self.address?.longPos ?? 0.0)
        
        
        if self.lable == "Other" && self.otherTextField.text != "" {
            self.lable = self.otherTextField.text ?? "Other"
        }

        let params = [
            "LabelId":self.lableId,
            "Label":self.lable ?? "0",
            "City":self.cityTextField.text ?? "",
            "Address1":self.lineOneTextField.text ?? "",
            "Address2":self.lineTwoTextField.text ?? "",
            "ZipPostalCode":self.zipCodeTextField.text ?? "",
            "ApiKey":API_KEY,
            "CustId":id,
            "LatPos": "\(lat )",
            "LongPos": "\(long )" ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.addAddress, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(ResetPassword.self, from: jsonData)
            //print(responseDict)
            
            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")

            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func updateAddressApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let lat = Double(self.address?.latPos ?? 0.0)
        let long = Double(self.address?.longPos ?? 0.0)
        
        if self.otherTextField.text != "Home" && self.otherTextField.text != "Work" && self.lable != "Home" && self.lable != "Work" {
            if let customTest = self.otherTextField.text, customTest.count > 0 {
                self.lable = self.otherTextField.text ?? "Other"
            }
            else {
                self.lable = "Other"
            }
        }
        else {
            
        }
        
        let params = [
            "Id": self.address?.id ?? 0,
            "LabelId": "",
            "Label": self.lable ?? "0",
            "City": self.cityTextField.text ?? "",
            "Address1": self.lineOneTextField.text ?? "",
            "Address2": self.lineTwoTextField.text ?? "",
            "ZipPostalCode": self.zipCodeTextField.text ?? "",
            "ApiKey": API_KEY,
            "CustId": id,
            "LatPos": lat,
            "LongPos": long ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.updateAddress, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(ResetPassword.self, from: jsonData)
            print(responseDict)
            
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
            
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }

}

//Ibactions
extension AddAddressViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setAddressTagButtonAction(_ sender: Any) {
        //reset
        let buttonsArray = self.stackView.subviews
        let getButton = buttonsArray[0] as? UIButton
        getButton?.backgroundColor = UIColor.white
        getButton?.setTitleColor(UIColor.darkGray, for: .normal)
        getButton?.setImage(UIImage(named: "homeIcon_AddAddress"), for: .normal)
        
        let getButton2 = buttonsArray[1] as? UIButton
        getButton2?.backgroundColor = UIColor.white
        getButton2?.setTitleColor(UIColor.darkGray, for: .normal)
        getButton2?.setImage(UIImage(named: "workIcon_AddAddress"), for: .normal)
        
        let getButton3 = buttonsArray[2] as? UIButton
        getButton3?.backgroundColor = UIColor.white
        getButton3?.setTitleColor(UIColor.darkGray, for: .normal)
        getButton3?.setImage(UIImage(named: "otherIcon_AddAddress"), for: .normal)
        
        
        //setting
        let button = sender as? UIButton
        button?.backgroundColor = primaryColor
        
        if button?.titleLabel?.text == "Home" {
            self.lable = "Home"
            self.lableId = 1
            self.otherTextField.isHidden = true
            
            button?.setTitleColor(UIColor.white, for: .normal)
            button?.setImage(UIImage(named: "homeIcon_AddAddress(white)"), for: .normal)
            
        } else if button?.titleLabel?.text == "Work" {
            self.lable = "Work"
            self.lableId = 2
            self.otherTextField.isHidden = true
            
            button?.setTitleColor(UIColor.white, for: .normal)
            button?.setImage(UIImage(named: "workIcon_AddAddress(white)"), for: .normal)
            
        } else if button?.titleLabel?.text == "Other" {
            self.lable = self.otherTextField.text ?? "Other"
            self.lableId = 3
            self.otherTextField.isHidden = false
            
            button?.setTitleColor(UIColor.white, for: .normal)
            button?.setImage(UIImage(named: "otherIcon_AddAddress(white)"), for: .normal)
        }
    }
    
    @IBAction func saveNewAddressButtonAction(_ sender: Any) {
        self.validate()
    }
    
    func validate() {
        do {
            _ = try lineOneTextField.validatedText(validationType: ValidatorType.requiredField(field: "address line 1"))
            _ = try lineTwoTextField.validatedText(validationType: ValidatorType.requiredField(field: "address line 2"))
            _ = try cityTextField.validatedText(validationType: ValidatorType.requiredField(field: "city"))
            _ = try zipCodeTextField.validatedText(validationType: ValidatorType.requiredField(field: "pincode"))
            
//            if self.lable == nil {
//                throw ValidationError("Please select location type")
//            }
            
            if self.lable == "Other" {
                //_ = try otherTextField.validatedText(validationType: ValidatorType.requiredField(field: "location type"))
            }
            
            if self.address != nil {
                if self.isFromAddLocationButton ?? false == true {
                    self.addAddressApi()
                } else {
                    self.updateAddressApi()
                }
            } else {
                self.addAddressApi()
            }
            
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
}


extension AddAddressViewController: UITextFieldDelegate {
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == self.zipCodeTextField {
            let allowedCharacters = CharacterSet(charactersIn:"QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

extension AddAddressViewController: PlaceSearchTextFieldDelegate {
    
    func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        self.view.endEditing(true)
        print("SELECTED ADDRESS : \(responseDict)")
        
        var line1 = ""
        var line2 = ""
        var country = ""
        var city = ""
        var zipCode = ""

//        for addressComponent in (responseDict.addressComponents)! {
//            for type in (addressComponent.types){
//                
//                switch(type){
//                    
//                case "sublocality_level_1":
//                    line1 = addressComponent.name
//                    
//                case "locality":
//                    line2 = addressComponent.name
//
//                case "political":
//                    city = addressComponent.name
//                    
//                case "country":
//                    country = addressComponent.name
//                    
//                case "city":
//                    city = addressComponent.name
//                    
//                case "postal_code":
//                    zipCode = addressComponent.name
//                    
//                default:
//                    break
//                }
//            }
//        }
//        
//        let address = AddressArray(id: 0, label: "Other",
//                                   addressLine1: line1,
//                                   addressLine2: line2+","+country,
//                                   zipCode: zipCode,
//                                   city: city,
//                                   latPos: responseDict.coordinate.latitude,
//                                   longPos: responseDict.coordinate.longitude)
//        let completeAddress = line1 + "," + line2 + "," + country + "," + zipCode
//        DispatchQueue.main.async {
//            self.lineOneTextField.text = completeAddress
//        }
       // self.addAddressFromCurrentLoction(onaddress: address)
    }
    
    func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
    }
    
    func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
    }
    
    func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
    }
}

