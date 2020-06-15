//
//  CuisineCollectionViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 23/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class CuisineCollectionViewCell: UICollectionViewCell {
    
    static let identifier:String = "CuisineCollectionViewCell"
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
    
    func isSelected(isSelc: Bool) {
        if isSelc {
            self.title.textColor = foodJinRedColor
        } else {
            self.title.textColor = UIColor.black
        }
    }

}
