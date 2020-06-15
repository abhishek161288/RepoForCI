//
//  OnGoingOrderCollectionViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 06/09/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit



class OnGoingOrderCollectionViewCell: UICollectionViewCell {

    static let identifier:String = "OnGoingOrderCollectionViewCell"
    @IBOutlet weak var containerStackView: UIStackView!
    var OnGoingOrder: OnGoIngOrderResponseObj?
    var reviewTapped:(()->())? = nil
    var crossTapped:(()->())? = nil
    
    @IBOutlet weak var reviewView: UIView!
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        if let reviewTapped = reviewTapped {
            reviewTapped()
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
     @IBAction func dismissReview(_ sender: Any)  {
        crossTapped?()
    }
    
    func setCell() {
       // print(self.OnGoingOrder)
        self.containerStackView.removeAllArrangedSubviews()
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        
        //One
        let topLable1 = UILabel()
        topLable1.text = "Order Status"
        topLable1.textAlignment = .left
        topLable1.font = UIFont.italicSystemFont(ofSize: 9)
        topLable1.textColor = UIColor.lightGray
        verticalStackView.addArrangedSubview(topLable1)
        
        let topLableValue1 = UILabel()
        topLableValue1.text = self.OnGoingOrder?.status ?? ""
        topLableValue1.textAlignment = .left
        topLableValue1.textColor = primaryColor
        topLableValue1.font = UIFont.systemFont(ofSize: 11)
        verticalStackView.addArrangedSubview(topLableValue1)
        
        self.containerStackView.addArrangedSubview(verticalStackView)
        
        let verticalStackView2 = UIStackView()
        verticalStackView2.axis = .vertical
        verticalStackView2.distribution = .fillEqually
        
        //Two
        let topLable2 = UILabel()
        topLable2.text = "Order ID"
        topLable2.textAlignment = .left
        topLable2.font = UIFont.italicSystemFont(ofSize: 9)
        topLable2.textColor = UIColor.lightGray
        verticalStackView2.addArrangedSubview(topLable2)
        
        let topLableValue2 = UILabel()
        topLableValue2.text = self.OnGoingOrder?.orderNumber ?? ""
        topLableValue2.textAlignment = .left
        topLableValue2.textColor = UIColor.darkGray
        topLableValue2.font = UIFont.systemFont(ofSize: 11)
        verticalStackView2.addArrangedSubview(topLableValue2)
        
        self.containerStackView.addArrangedSubview(verticalStackView2)

        
        let verticalStackView3 = UIStackView()
        verticalStackView3.axis = .vertical
        verticalStackView3.distribution = .fillEqually
        
        //Three
        let topLable3 = UILabel()
        topLable3.text = "Arrival Time"
        topLable3.textAlignment = .left
        topLable3.font = UIFont.italicSystemFont(ofSize: 9)
        topLable3.textColor = UIColor.lightGray
        verticalStackView3.addArrangedSubview(topLable3)
        
        let topLableValue3 = UILabel()
        topLableValue3.text = self.OnGoingOrder?.deliveredTime ?? ""
        topLableValue3.textAlignment = .left
        topLableValue3.textColor = UIColor.darkGray
        topLableValue3.font = UIFont.systemFont(ofSize: 11)
        verticalStackView3.addArrangedSubview(topLableValue3)
        
        self.containerStackView.addArrangedSubview(verticalStackView3)
        
        if self.OnGoingOrder?.status == "OrderDelivered" {
            reviewView.isHidden = false
        } else {
            reviewView.isHidden = true
        }
    }
}
