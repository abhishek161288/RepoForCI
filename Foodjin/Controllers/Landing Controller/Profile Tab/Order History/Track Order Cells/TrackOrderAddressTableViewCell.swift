//
//  TrackOrderAddressTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 16/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class TrackOrderAddressTableViewCell: UITableViewCell {
    
    weak var contanningController: TrackOrderViewController?
    static let identifier:String = "TrackOrderAddressTableViewCell"

    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var detail: UITextView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        if self.contanningController?.isViewSummary ?? false {
            self.heading.isHidden = true
            self.addressImage.isHidden = true
            self.addressType.isHidden = true
            self.detail.isHidden = true
        } else {
            self.heading.isHidden = false
            self.addressImage.isHidden = false
            self.addressType.isHidden = false
            self.detail.isHidden = false
        }
        
    }
    
}
