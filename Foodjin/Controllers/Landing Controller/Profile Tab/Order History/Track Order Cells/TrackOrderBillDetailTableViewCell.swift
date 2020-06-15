//
//  TrackOrderBillDetailTableViewCell.swift
//  Foodjin
//
//  Created by Abhishek Sharma on 04/12/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class TrackOrderBillDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    static let identifier = "TrackOrderBillDetailTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
