//
//  CollectionTableViewCell.swift
//  MultiCellTableView
//
//  Created by Navpreet Singh on 13/11/18.
//  Copyright © 2018 Navpreet Singh. All rights reserved.
//

import UIKit

enum HorizontalTableViewCellType {
    case CookCell
    case DishCell
    case DrinksCell
    case None
}

protocol HorizontalTableViewCellCellCommunication: class {
    func touchOnHoriZontalCell(type: HorizontalTableViewCellType, indexNumber: Int)
    func touchOnTopButton(type: HorizontalTableViewCellType)
    func addToFavoriteThisChef(cook: Cook?, atIndex: Int?)
    func nowRefresh()
}

class HorizontalTableViewCell: UITableViewCell {

    static let identifier:String = "HorizontalTableViewCell"
    var cellType: HorizontalTableViewCellType?
    weak var delegate: HorizontalTableViewCellCellCommunication?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var CellTitle: UILabel!
    @IBOutlet weak var AllButton: UIButton!
    
    @IBOutlet weak var noData: UILabel!

    
    var cooks: [Cook]?
    var dishes: [Dish]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if self.cellType == HorizontalTableViewCellType.CookCell {
            self.collectionView.register(UINib(nibName: CookCell.identifier, bundle: nil), forCellWithReuseIdentifier: CookCell.identifier)
        }
        
        if self.cellType == HorizontalTableViewCellType.DishCell {
            self.collectionView.register(UINib(nibName: DishCell.identifier, bundle: nil), forCellWithReuseIdentifier: DishCell.identifier)
        }
        
        if self.cellType == HorizontalTableViewCellType.DrinksCell {
            self.collectionView.register(UINib(nibName: DishCell.identifier, bundle: nil), forCellWithReuseIdentifier: DishCell.identifier)
        }
        
        if self.cellType == HorizontalTableViewCellType.CookCell {
            if self.cooks?.count ?? 0 <= 0 {
                self.noData.isHidden = false
                self.noData.text = "Loading..."
            } else {
                self.noData.isHidden = true
            }
        } else if self.cellType == HorizontalTableViewCellType.DishCell {
            if self.dishes?.count ?? 0 <= 0 {
                self.noData.isHidden = false
                self.noData.text = "Loading..."
            } else {
                self.noData.isHidden = true
            }
        } else if self.cellType == HorizontalTableViewCellType.DrinksCell {
            if self.dishes?.count ?? 0 <= 0 {
                self.noData.isHidden = false
                self.noData.text = "Loading..."
            } else {
                self.noData.isHidden = true
            }
        }
    }
    
}

//Ibactions
extension HorizontalTableViewCell {
    @IBAction func allButtonAction(_ sender: Any) {
        self.delegate?.touchOnTopButton(type: self.cellType ?? HorizontalTableViewCellType.None)
    }
}

extension HorizontalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.cellType == HorizontalTableViewCellType.CookCell {
            return self.cooks?.count ?? 0
        } else if self.cellType == HorizontalTableViewCellType.DishCell {
            return self.dishes?.count ?? 0
        } else if self.cellType == HorizontalTableViewCellType.DrinksCell {
            return self.dishes?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.touchOnHoriZontalCell(type: self.cellType ?? HorizontalTableViewCellType.None,
                                             indexNumber: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width/1.7, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let returnCell = UICollectionViewCell()
        
        if self.cellType == HorizontalTableViewCellType.CookCell {
            guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CookCell.identifier, for: indexPath) as? CookCell
                else { return returnCell }
            reportsCell.cookInfo = self.cooks?[indexPath.row]
            reportsCell.index = indexPath.row
            reportsCell.delegate = self
            reportsCell.setCell()
            return reportsCell
        }
        
        if self.cellType == HorizontalTableViewCellType.DishCell {
            guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell
                else { return returnCell }
            reportsCell.dishInfo = self.dishes?[indexPath.row]
            reportsCell.isDrinkCell = true
            reportsCell.delegate = self
            reportsCell.setCell()
            return reportsCell
        }
        
        if self.cellType == HorizontalTableViewCellType.DrinksCell {
            guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell
                else { return returnCell }
            reportsCell.dishInfo = self.dishes?[indexPath.row]
            reportsCell.delegate = self
            reportsCell.isDrinkCell = false
            reportsCell.setCell()
            return reportsCell
        }

        return returnCell
        }
}

extension HorizontalTableViewCell: CookCellCommunication, DishCellCommunication {
    
    func nowRefreshForCartItems() {
        self.delegate?.nowRefresh()
    }
    
    func refreshing() {
        var paths:[IndexPath] = []
        
        for i in 0...(self.dishes?.count ?? 0)-1 {
            paths.append(IndexPath(row: i, section: 0))
        }
        
        if paths.count > 0 {
            //print(paths)
            self.collectionView.reloadItems(at: paths)
        }
    }
    
    func addToFavorite(cook: Cook?, atIndex: Int?) {
        self.delegate?.addToFavoriteThisChef(cook: cook, atIndex: atIndex)
    }
}
