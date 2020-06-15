//
//  SortView.swift
//  Foodjin
//
//  Created by Navpreet Singh on 22/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class SortView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier:String = "SortView"
    var value: Values?
    var selectedRadio: CategoryValueFilter?
    
    override func awakeFromNib() {
        self.collectionView.register(UINib(nibName: RadioCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RadioCollectionViewCell.identifier)
    }
    
    func refreshView() {
//        print(self.value)
        self.collectionView.reloadData()
    }
    
    func clear() {
        self.selectedRadio = nil
        self.collectionView.reloadData()
    }
}

//IbActions
extension SortView {
    @IBAction func ButtonAction(_ sender: Any) {
        print("Button CLick")
    }
}

extension SortView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.value?.categoryValueFilter?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked on Cell")
        
//        let getCell = collectionView.cellForItem(at: indexPath) as? RadioCollectionViewCell
//        getCell?.title.textColor = foodJinRedColor
    
        self.selectedRadio = self.value?.categoryValueFilter?[indexPath.row]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let returnCell = UICollectionViewCell()
        
        guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: RadioCollectionViewCell.identifier, for: indexPath) as? RadioCollectionViewCell
            else { return returnCell }
        if self.value?.categoryValueFilter?[indexPath.row] == self.selectedRadio {
            reportsCell.isSelected(isSelc: true)
        } else {
            reportsCell.isSelected(isSelc: false)
        }
        reportsCell.title.text = self.value?.categoryValueFilter?[indexPath.row].titleValueName
        
        return reportsCell
    }
}
