//
//  TrackOrderCartTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 17/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class TrackOrderCartTableViewCell: UITableViewCell {

    static let identifier:String = "TrackOrderCartTableViewCell"

    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartItems: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
