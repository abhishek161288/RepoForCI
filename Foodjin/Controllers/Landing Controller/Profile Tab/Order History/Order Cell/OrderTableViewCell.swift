//
//  OrderTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 02/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Foundation

protocol OrderTableViewCellCommunication: class {
    func touchReviewButton(onaddress: Order)
}

class OrderTableViewCell: UITableViewCell {
    
    var delegate: OrderTableViewCellCommunication?

    static let identifier:String = "OrderTableViewCell"
    var order : Order?
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var reviewButtonWidth: NSLayoutConstraint!

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var deliverTime: UILabel!

    @IBOutlet weak var deliverTimeStatic: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell() {
        self.orderId.text = self.order?.orderNumber ?? ""
        
        if let dateString = self.order?.orderTime {
            let dateTo = DateFormatter.date(fromISO8601String: dateString)
            //format
            self.orderTime.text = dateTo?.toString(format: DateFormatType.custom(foodjinDateFormat))
        } else {
            self.orderTime.text = ""
        }
        
//        Received = 10 DOne
//        Confirmed = 20 DOne
//        Prepared = 30 Done
//        OrderPickedUp = 3 Done
//        OrderDelivered = 4 Done
//        OrderReject = 9 Done
//        Cancelled = 40 Done
        
        
        //Setting Order Status
        if self.order?.orderStatus == 40 {
            //canceled
            self.orderStatus.text = "Cancelled"

            self.deliverTimeStatic.isHidden = true
            self.deliverTime.isHidden = true

            self.backView.backgroundColor = foodJinRedColor
            self.orderStatus.textColor = foodJinRedColor
            self.deliverTime.text = ""
            self.reviewButtonWidth.constant = 0

        } else if self.order?.orderStatus == 9 {
            //canceled
            self.orderStatus.text = "Rejected"
            
            self.deliverTimeStatic.isHidden = true
            self.deliverTime.isHidden = true
            
            self.backView.backgroundColor = foodJinOrangeColor
            self.orderStatus.textColor = foodJinOrangeColor
            self.deliverTime.text = ""
            self.reviewButtonWidth.constant = 0
            
        } else if self.order?.orderStatus == 10 {
            //canceled
            self.orderStatus.text = "Received"
            
            self.deliverTimeStatic.isHidden = true
            self.deliverTime.isHidden = true
            
            self.backView.backgroundColor = foodJinOrangeColor
            self.orderStatus.textColor = foodJinOrangeColor
            self.deliverTime.text = ""
            self.reviewButtonWidth.constant = 0
            
        }  else if self.order?.orderStatus == 30 {
            //canceled
            self.orderStatus.text = "Prepared"
            
            self.deliverTimeStatic.isHidden = true
            self.deliverTime.isHidden = true
            
            self.backView.backgroundColor = foodJinOrangeColor
            self.orderStatus.textColor = foodJinOrangeColor
            self.deliverTime.text = ""
            self.reviewButtonWidth.constant = 0
            
        } else if self.order?.orderStatus == 4 {
            self.orderStatus.text = "Delivered"
            self.deliverTimeStatic.isHidden = false
            self.deliverTime.isHidden = false

            //delivered + on review button
            self.backView.backgroundColor = foodJinGreenColor
            self.orderStatus.textColor = foodJinGreenColor
            
            if self.order?.isOpenForReview ?? true {
                self.reviewButtonWidth.constant = 65
            } else {
                self.reviewButtonWidth.constant = 0
            }

            if let dateString = self.order?.deliveredTime {
                let dateTo = DateFormatter.date(fromISO8601String: dateString)
                //format
                self.deliverTime.text = dateTo?.toString(format: DateFormatType.custom(foodjinDateFormat))
            } else {
                self.deliverTime.text = ""
            }

        }  else if self.order?.orderStatus == 3 {
            //Picked Up
            self.orderStatus.text = "On the Way"
            self.deliverTimeStatic.isHidden = true
            self.deliverTime.isHidden = true

            self.backView.backgroundColor = foodJinOrangeColor
            self.orderStatus.textColor = foodJinOrangeColor
            self.reviewButtonWidth.constant = 0

            self.deliverTime.text = ""
        }  else if self.order?.orderStatus == 20 {
            //Picked Up
            self.orderStatus.text = "Confirmed"
            self.deliverTimeStatic.isHidden = true
            self.deliverTime.isHidden = true
            
            self.backView.backgroundColor = foodJinOrangeColor
            self.orderStatus.textColor = foodJinOrangeColor
            self.reviewButtonWidth.constant = 0
            
            self.deliverTime.text = ""
        } else {
            self.orderStatus.text = ""

            self.reviewButtonWidth.constant = 0
        }
        
            
    }
    
}

//Ibactions
extension OrderTableViewCell {
    
    @IBAction func reviewButtonAction(_ sender: Any) {
        self.delegate?.touchReviewButton(onaddress: self.order!)
    }
}
