//
//  OrderFilterTextView.swift
//  Foodjin
//
//  Created by Navpreet Singh on 08/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

enum OrderFilterTextViewType {
    case number
    case date
    case array
    case none
}

protocol OrderFilterTextViewCommunication: class {
    func enteringCharacted(text: Any, type: OrderFilterTextViewType)
}

class OrderFilterTextView: UIView {
    
//    let dummyList = ["Confirmed", "Delivered", "Canceled"]

    var textViewType: OrderFilterTextViewType?
    var delegate: OrderFilterTextViewCommunication?
    @IBOutlet var textView: UITextField!
    var dataArray: [String] = ["Confirmed", "Delivered", "Canceled"]

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setup() {
        if self.textViewType == OrderFilterTextViewType.number {
            self.textView.keyboardType = UIKeyboardType.numberPad
        }
    }

}

extension OrderFilterTextView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.delegate?.enteringCharacted(text: self.textView.text ?? "")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.enteringCharacted(text: self.textView.text ?? "", type: self.textViewType ?? OrderFilterTextViewType.none)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.textViewType == OrderFilterTextViewType.array {
            //value picker
            RPicker.selectOption(dataArray: dataArray) { (selctedText, atIndex) in
                // TODO: Your implementation for selection
                self.textView.text = selctedText
                self.delegate?.enteringCharacted(text: self.textView.text ?? "", type: self.textViewType ?? OrderFilterTextViewType.none)
            }
        }
        
        if self.textViewType == OrderFilterTextViewType.date {
            //date picker
            RPicker.selectDate { (selectedDate) in
                // TODO: Your implementation for date
                self.textView.text = selectedDate.dateString("dd MMM YYYY")
                self.delegate?.enteringCharacted(text: selectedDate, type: self.textViewType ?? OrderFilterTextViewType.none)
            }
        }
        
        if self.textViewType == OrderFilterTextViewType.number {
            return true
        }
        return false
    }
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}


