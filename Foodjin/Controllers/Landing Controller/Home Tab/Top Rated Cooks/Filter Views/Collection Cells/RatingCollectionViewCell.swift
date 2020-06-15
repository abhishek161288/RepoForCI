//
//  RatingCollectionViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol RatingCollectionViewCellCommunication {
    func didSelectOnCheckbox(index: Int?, value: CategoryValueFilter?)
}

class RatingCollectionViewCell: UICollectionViewCell {

    static let identifier:String = "RatingCollectionViewCell"
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var stackView: UIStackView!
    var value: CategoryValueFilter?
    var indexPath: Int?
    var delegate:RatingCollectionViewCellCommunication?

    var startNumber: Int?

    override func awakeFromNib() {
        super.awakeFromNib()        
        self.checkBox.boxType = .square
    }
    
    func setUpCell(with: Int) {
        
        self.stackView.removeAllArrangedSubviews()
        
        self.startNumber = with
        
        if let count = self.startNumber {
            for _ in 1...self.startNumber! {
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                image.image = UIImage(named: "itemRateIcon")
                self.stackView.addArrangedSubview(image)
            }
        }
    }
    
    func isSelected(isSelc: Bool) {
        if isSelc {
            self.checkBox.on = true
        } else {
            self.checkBox.on = false
        }
    }

    
    @IBAction func checkBoxButtonAction(_ sender: BEMCheckBox) {
//        print(sender.on)        
        self.delegate?.didSelectOnCheckbox(index: indexPath, value: value)
    }
    
}

