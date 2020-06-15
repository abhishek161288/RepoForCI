//
//  RadioCollectionViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class RadioCollectionViewCell: UICollectionViewCell {

    static let identifier:String = "RadioCollectionViewCell"
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isSelected(isSelc: Bool) {
        if isSelc {
            self.image.image = UIImage(named: "filterRadioBtn_Active")
        } else {
            self.image.image = UIImage(named: "filterRadioBtn")
        }
    }

}
