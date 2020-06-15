//
//  FoodItemCollectionViewCell.swift
//  Demo_Collection_View
//
//  Created by Sunder singh on 17/10/19.
//  Copyright © 2019 Sunder singh. All rights reserved.
//

import UIKit

class FoodItemCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlet
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var resturantName: UILabel!
    @IBOutlet weak var foodTime: UILabel!
    @IBOutlet weak var foodTimeView: UIView!
    @IBOutlet weak var resturantAddressLbl: UILabel!
    @IBOutlet weak var foodType: UILabel!
    @IBOutlet weak var isOpenLbl: UILabel!
    @IBOutlet weak var resturantTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isOpenLbl.layer.cornerRadius = 4
        isOpenLbl.layer.masksToBounds = true
    }

}
