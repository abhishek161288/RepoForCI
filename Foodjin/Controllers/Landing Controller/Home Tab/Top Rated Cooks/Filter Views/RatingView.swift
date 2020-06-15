//
//  RatingView.swift
//  Foodjin
//
//  Created by Navpreet Singh on 22/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier:String = "RatingView"
    var value: Values?
    var selectedRating: [CategoryValueFilter]? = []

    override func awakeFromNib() {
        self.collectionView.register(UINib(nibName: RatingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RatingCollectionViewCell.identifier)
    }
    
    func refreshView() {
//        print(self.value)
        self.collectionView.reloadData()
    }
    
    func clear() {
        self.selectedRating = []
        self.collectionView.reloadData()
    }
}

extension RatingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.value?.categoryValueFilter?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Clicked on Cell")
//
//        let getCell = collectionView.cellForItem(at: indexPath) as? RadioCollectionViewCell
//        getCell?.title.textColor = foodJinRedColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35+(indexPath.row+1)*20, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let returnCell = UICollectionViewCell()
        
        guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCollectionViewCell.identifier, for: indexPath) as? RatingCollectionViewCell
            else { return returnCell }
        
        guard let vvv = self.value?.categoryValueFilter?[indexPath.row] else { return reportsCell }
        let number = Int(vvv.titleValueName ?? "0")
        reportsCell.setUpCell(with: number!)
        reportsCell.value = vvv
        reportsCell.indexPath = indexPath.row
        reportsCell.delegate = self
        
        if self.selectedRating?.contains(vvv) ?? false {
            reportsCell.isSelected(isSelc: true)
        } else {
            reportsCell.isSelected(isSelc: false)
        }
        return reportsCell
    }
}

extension RatingView: RatingCollectionViewCellCommunication {
    
    func didSelectOnCheckbox(index: Int?, value: CategoryValueFilter?) {
        
        guard let ind = index else { return }
        guard let vvv = self.value?.categoryValueFilter?[ind] else { return }
        if self.selectedRating?.contains(vvv) ?? false {
            self.selectedRating?.removeAll(where: { (CategoryValueFilter) -> Bool in
                return CategoryValueFilter == vvv
            })
        } else {
            self.selectedRating?.append(vvv)
        }
        
        self.collectionView.reloadData()
    }
}
