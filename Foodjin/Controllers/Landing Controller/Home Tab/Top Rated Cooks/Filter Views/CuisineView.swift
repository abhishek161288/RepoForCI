//
//  CuisineView.swift
//  Foodjin
//
//  Created by Navpreet Singh on 22/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class CuisineView: UIView {

    static let identifier:String = "CuisineView"
    @IBOutlet weak var collectionView: UICollectionView!
    var value: Values?
    var selectedCusines: [CategoryValueFilter]? = []


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override func awakeFromNib() {
        self.collectionView.register(UINib(nibName: CuisineCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CuisineCollectionViewCell.identifier)
    }

    func refreshView() {
//        print(self.value)
        self.collectionView.reloadData()
    }
    
    func clear() {
        self.selectedCusines = []
        self.collectionView.reloadData()
    }
}

extension CuisineView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.value?.categoryValueFilter?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked on Cell")
        
//        let getCell = collectionView.cellForItem(at: indexPath) as? CuisineCollectionViewCell
//        getCell?.title.textColor = foodJinRedColor
        guard let vvv = self.value?.categoryValueFilter?[indexPath.row] else { return }
        if self.selectedCusines?.contains(vvv) ?? false {
            self.selectedCusines?.removeAll(where: { (CategoryValueFilter) -> Bool in
                return CategoryValueFilter == vvv
            })
        } else {
            self.selectedCusines?.append(vvv)
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/5, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let returnCell = UICollectionViewCell()
        
        guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisineCollectionViewCell.identifier, for: indexPath) as? CuisineCollectionViewCell
            else { return returnCell }
        guard let vvv = self.value?.categoryValueFilter?[indexPath.row] else { return reportsCell }
        if self.selectedCusines?.contains(vvv) ?? false {
            reportsCell.isSelected(isSelc: true)
        } else {
            reportsCell.isSelected(isSelc: false)
        }
        reportsCell.title.text = self.value?.categoryValueFilter?[indexPath.row].titleValueName
        return reportsCell
    }
}
