//
//  AddressTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 01/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

protocol AddressTableViewCellCommunication: class {
    func touchEditButton(onaddress: AddressArray)
    func touchDeleteButton(onaddress: AddressArray)
}


class AddressTableViewCell: UITableViewCell {

    static let identifier:String = "AddressTableViewCell"
    var address: AddressArray?
    var delegate: AddressTableViewCellCommunication?

    
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressDesc: UITextView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell() {
        self.addressTitle.text = self.address?.label ?? ""
        self.addressDesc.text = "\(self.address?.addressLine1 ?? "") " +
            "\(self.address?.addressLine2 ?? "") " +
            "\(self.address?.city ?? "") " +
        "\(self.address?.zipCode ?? "")"
        
        if self.address?.label == "Home" {
            self.addressImage.image = UIImage(named: "homeIcon")
        } else if self.address?.label == "Work" {
            self.addressImage.image = UIImage(named: "workIcon")
        }
    }
    
}

//Ibactions
extension AddressTableViewCell {
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.delegate?.touchEditButton(onaddress: self.address!)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {

        let alertController = UIAlertController(title: "Alert", message: "Do you want to Delete this Address?", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.delegate?.touchDeleteButton(onaddress: self.address!)
        }
        let alertAction2 = UIAlertAction(title: "No", style: .destructive) { (action) in
        }
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
        self.appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
