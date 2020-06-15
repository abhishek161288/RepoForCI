//
//  CardTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 02/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

protocol CardTableViewCellCommunication: class {
    func touchDeleteButton(onaddress: Card)
}

class CardTableViewCell: UITableViewCell {
    
    weak var delegate: CardTableViewCellCommunication?
    var cardInfo : Card?
    
    static let identifier:String = "CardTableViewCell"
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var expiry: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell() {
        if self.cardInfo?.brand == "Visa" {
            self.logoImage.image = UIImage(named: "visa")
        } else {
            self.logoImage.image = UIImage(named: "mastercard")
        }
        guard let four = self.cardInfo?.last4 else { return }
        self.number.text = "xxxx \(four)"
        
        guard let month = self.cardInfo?.expMonth else { return }
        guard let year = self.cardInfo?.expYear else { return }

        self.expiry.text = "Card Expiry: \(month)/\(year)"
    }
    
}

//Ibactions
extension CardTableViewCell {
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        self.delegate?.touchDeleteButton(onaddress: self.cardInfo!)
    }
}
