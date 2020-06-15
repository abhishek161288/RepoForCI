//
//  OrderNotesTableViewCell.swift
//  Foodjin
//
//  Created by Abhishek Sharma on 05/12/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class OrderNotesTableViewCell: UITableViewCell {

    static var identifier = "OrderNotesTableViewCell"
    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
