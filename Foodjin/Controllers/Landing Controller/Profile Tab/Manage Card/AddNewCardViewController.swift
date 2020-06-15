//
//  AddNewCardViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField

class AddNewCardViewController: UIViewController {

    @IBOutlet weak var cardNumber: UnderLineTextField!
    @IBOutlet weak var cardExpiryMonth: UnderLineTextField!
    @IBOutlet weak var cardExpiryYear: UnderLineTextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.cardNumber.delegate = self

        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
        }
        self.cardExpiryMonth.inputView = expiryDatePicker
        self.cardExpiryYear.inputView = expiryDatePicker

//        self.addNewCard()
    }
    
    func addNewCard() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "CardToken":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.addNewCard, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
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

}

//Ibactions
extension AddNewCardViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension AddNewCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumber {
        var string = string
        
        var text = textField.text
        
        let characterSet = CharacterSet(charactersIn: "0123456789")
        string = string.replacingOccurrences(of: " ", with: "")
        if (string as NSString).rangeOfCharacter(from: characterSet.inverted).location != NSNotFound {
            return false
        }
        
        text = (text as NSString?)?.replacingCharacters(in: range, with: string)
        text = text?.replacingOccurrences(of: " ", with: "")
        
        var newString = ""
        while (text?.count ?? 0) > 0 {
            let subString = (text as? NSString)?.substring(to: min((text?.count ?? 0), 4))
            newString = newString + (subString ?? "")
            if (subString?.count ?? 0) == 4 {
                newString = newString + (" ")
            }
            text = (text as? NSString)?.substring(from: min((text?.count ?? 0), 4))
        }
        
        newString = newString.trimmingCharacters(in: characterSet.inverted)
        
        if newString.count >= 20 {
            return false
        }
        
        textField.text = newString
        }
        return false
    }

}
