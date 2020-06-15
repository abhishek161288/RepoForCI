//
//  AddCardViewController.swift
//  Foodjin
//
//  Created by Abhishek Sharma on 12/12/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Stripe



class AddCardViewController: UIViewController,SwiftyCodeViewDelegate {

    @IBOutlet weak var cardExpiryMonth: UITextField!
    @IBOutlet weak var cardExpiryYear: UITextField!
    @IBOutlet weak var cardType: UITextField!
    @IBOutlet weak var cardCVV: UITextField!
    @IBOutlet weak var cardNumberView: SwiftyCodeView!
    var sendTokenToBackend: ((_ token: String?) -> Void)?

    
    let stpCardParam = STPCardParams()
    let months = ["JAN", "FEB","MAR","APR", "MAY","JUN","JUL", "AUG","SEP","OCT", "NOV","DEC"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the viewś
        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            self.cardExpiryMonth.text = self.months[month - 1]
            self.cardExpiryYear.text = "\(year)"
            NSLog(string) // should show something like 05/2015
        }
        self.cardExpiryMonth.inputView = expiryDatePicker
        self.cardExpiryYear.inputView = expiryDatePicker
//        stpCardParam.number = "4242424242424242"
//        stpCardParam.expYear = 2024
//        stpCardParam.expMonth = 12
//        stpCardParam.cvc = "454"
        
        
        
    }
    
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) {
        stpCardParam.number = code
        
    }
    func codeView(sender: SwiftyCodeView, didChangeInput code: String) {
        let type = self.validateCreditCardFormat(text: code)
        DispatchQueue.main.async {
            self.cardType.text = type.type.rawValue
        }
        
    }
    
    func generateToken(card: STPCardParams, completion: @escaping (_ token: STPToken?) -> Void) {
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                completion(token)
            }
            else {
                print(error)
                completion(nil)
            }
        }
    }
    
    @IBAction func addCardAction(sender: UIButton) {
        if let error = validateCard() {
            showAlert(for: error)
            return
        }
        let _ = generateToken(card: stpCardParam) { (token) in
            self.sendTokenToBackend?(token?.tokenId)
        }
    }
    
    @IBAction func backButtonClicked()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func validateCard() -> String?  {
        if let month = cardExpiryMonth.text {
            stpCardParam.expMonth = UInt((months.firstIndex(of: month) ?? 0) + 1)
        }
        else {
            return "Select expiry month"
        }
        if let year = cardExpiryYear.text {
            stpCardParam.expYear = UInt(year) ?? 2020
        }
        else {
            return "Select expiry year"
        }
        
        if cardNumberView.code.count < 16 {
            return "Enter Card Number"
        }
        else {
            stpCardParam.number = cardNumberView.code
        }
        
        if let cvv = cardCVV.text, cvv.count == 3 {
            stpCardParam.cvc = cvv
        }
        else {
            return "Enter valid cvv"
        }
        
        return nil
    }
    enum CardType: String {
        case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
        
        static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
        
        var regex : String {
            switch self {
            case .Amex:
                return "^3[47][0-9]{5,}$"
            case .Visa:
                return "^4[0-9]{6,}([0-9]{3})?$"
            case .MasterCard:
                return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
            case .Diners:
                return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
            case .Discover:
                return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
            case .JCB:
                return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
            case .UnionPay:
                return "^(62|88)[0-9]{5,}$"
            case .Hipercard:
                return "^(606282|3841)[0-9]{5,}$"
            case .Elo:
                return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
            default:
                return ""
            }
        }
    }
    
    func validateCreditCardFormat(text: String)-> (type: CardType, valid: Bool) {
        // Get only numbers from the input string
        var input = text
        let numberOnly = input
        
        var type: CardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in CardType.allCards {
            
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(number: numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, valid)
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func luhnCheck(number: String) -> Bool {
//        var sum = 0
//        let digitStrings = number.reversed().map { String($0) }
//
//        for tuple in digitStrings.enumerated() {
//            guard let digit = Int(tuple.element) else { return false }
//            let odd = tuple.index % 2 == 1
//
//            switch (odd, digit) {
//            case (true, 9):
//                sum += 9
//            case (true, 0...8):
//                sum += (digit * 2) % 9
//            default:
//                sum += digit
//            }
//        }
//
//        return sum % 10 == 0
        return true
    }

    

}
