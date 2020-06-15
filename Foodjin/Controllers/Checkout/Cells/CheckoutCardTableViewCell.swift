//
//  CheckoutCardTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 07/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import UnderLineTextField

protocol CheckoutCardTableViewCellCommunication: class {
    func addedCvv(onCard: Card?, cvv: String)
}

class CheckoutCardTableViewCell: UITableViewCell {

    var cardInfo : Card?
    weak var delegate: CheckoutCardTableViewCellCommunication?

    static let identifier:String = "CheckoutCardTableViewCell"
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var expiry: UILabel!
    @IBOutlet weak var cvv: UnderLineTextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell() {
        self.logoImage.image = UIImage(named: "mastercard")
        guard let four = self.cardInfo?.last4 else { return }
        self.number.text = "xxxx \(four)"
        
        guard let month = self.cardInfo?.expMonth else { return }
        guard let year = self.cardInfo?.expYear else { return }
        
        self.expiry.text = "Card Expiry: \(month)/\(year)"
    }
}


extension CheckoutCardTableViewCell: UITextFieldDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //print(textView.text)
        
        self.delegate?.addedCvv(onCard: self.cardInfo, cvv: textView.text)
    }
}
