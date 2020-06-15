//
//  TrackOrderItemsTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 16/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class TrackOrderItemsTableViewCell: UITableViewCell {
    
    weak var contanningController: TrackOrderViewController?
    static let identifier:String = "TrackOrderItemsTableViewCell"
    var orderedItems: [OrderedItem]?
    var responseObject: TrackOrderResponseObj?
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var summaryLable: UILabel!
    @IBOutlet weak var summaryImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        summaryImage.backgroundColor = primaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        if self.contanningController?.isViewSummary ?? false {
            self.itemsCount.isHidden = true
            self.summaryLable.isHidden = true
            self.summaryImage.isHidden = true
        } else {
            self.itemsCount.isHidden = false
            self.summaryLable.isHidden = false
            self.summaryImage.isHidden = false
        }
        
        self.itemsCount.text = "\(self.orderedItems?.count ?? 0) Items"
    }
    
}

extension TrackOrderItemsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.orderedItems?.count ?? 0) + 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < (self.orderedItems?.count ?? 0) {
            return 70
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        if indexPath.row >= (self.orderedItems?.count ?? 0) {
            guard let mainCell = Bundle.main.loadNibNamed(TrackOrderBillDetailTableViewCell.identifier, owner: self, options: nil)?.first as? TrackOrderBillDetailTableViewCell else {
                return cell
            }
            let newIndex = indexPath.row - (self.orderedItems?.count ?? 0)
            switch newIndex {
            case 0:
                mainCell.titleLbl.text = "SubTotal"
                mainCell.subTitleLbl.text = STORE_CURRENCY + (responseObject?.subAmount ?? "")
            case 1:
                mainCell.titleLbl.text = "Tax"
                mainCell.subTitleLbl.text = STORE_CURRENCY + (responseObject?.tax ?? "")
            case 2:
                mainCell.titleLbl.text = "Discount"
                mainCell.subTitleLbl.text = STORE_CURRENCY + (responseObject?.discountAmount ?? "")
            case 3:
                mainCell.titleLbl.text = "Total"
                mainCell.subTitleLbl.text = STORE_CURRENCY + (responseObject?.amount ?? "")
            default:
                print("")
            }
            return mainCell
        }
        
        guard let mainCell = Bundle.main.loadNibNamed(TrackOrderCartTableViewCell.identifier, owner: self, options: nil)?.first as? TrackOrderCartTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.cartImage.setImage(with: URL(string: self.orderedItems?[indexPath.row].productImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        mainCell.cartName.text = self.orderedItems?[indexPath.row].productName ?? ""
        mainCell.cartPrice.text = STORE_CURRENCY + (self.orderedItems?[indexPath.row].productPrice?.until(".") ?? "")
        mainCell.cartItems.text = STORE_CURRENCY + "\(self.orderedItems?[indexPath.row].productPrice?.until(".") ?? "")" + "X" + "\(self.orderedItems?[indexPath.row].productQuantity ?? 1)"
        
        

        return mainCell
    }
}
