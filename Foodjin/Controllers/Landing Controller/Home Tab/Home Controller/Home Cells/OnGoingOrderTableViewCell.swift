//
//  OnGoingOrderTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 07/09/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
//


class OnGoingOrderTableViewCell: UITableViewCell {

    static let identifier:String = "OnGoingOrderTableViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
//    var OnGoingOrders: [OnGoIngOrderResponseObj]?
//    weak var delegate: OnGoingOrderCollectionViewCellCommunication?
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//        self.collectionView.register(UINib(nibName: OnGoingOrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OnGoingOrderCollectionViewCell.identifier)
//    }
//
}



//extension OnGoingOrderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.OnGoingOrders?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("on going order cell click")
//        self.delegate?.onGoingOrderClick(TrackOrderId: self.OnGoingOrders?[indexPath.row].orderID)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let returnCell = UICollectionViewCell()
//        
//        guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnGoingOrderCollectionViewCell.identifier, for: indexPath) as? OnGoingOrderCollectionViewCell
//            else { return returnCell }
//        reportsCell.OnGoingOrder = self.OnGoingOrders?[indexPath.row]
//        reportsCell.setCell()
//        return reportsCell
//    }
//}
