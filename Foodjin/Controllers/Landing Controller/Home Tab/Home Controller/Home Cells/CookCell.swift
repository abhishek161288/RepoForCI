//
//  HorizontalCell.swift
//  Trasers
//
//  Created by Navpreet Singh on 14/11/18.
//  Copyright © 2018 Boopathi. All rights reserved.
//

import UIKit
import MapleBacon
import TagListView

protocol CookCellCommunication: class {
    func addToFavorite(cook: Cook?, atIndex: Int?)
}

class CookCell: UICollectionViewCell {

    static let identifier:String = "CookCell"
    weak var delegate: CookCellCommunication?
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var cookDistance: UILabel!
    @IBOutlet weak var tagView: TagListView!
    
    var cookInfo: Cook?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tagView.textFont = UIFont.italicSystemFont(ofSize: 12.0)
    }
    
    func setCell() {
        
        //Like or dislike
        if self.cookInfo?.isLike == true {
            self.favButton.setImage(UIImage(named: "favouriteIcon"), for: .normal)
        } else {
            self.favButton.setImage(UIImage(named: "favouriteIcon(gray)"), for: .normal)
        }
        
        //Availibility
        if self.cookInfo?.isStatusAvailable == true {
            self.availability.backgroundColor = foodJinGreenColor
            self.availability.text = "Available"
        } else {
            self.availability.backgroundColor = foodJinRedColor
            self.availability.text = "Unavailable"
        }
        
        //Favorite
//        if self.cookInfo?.isLike == true {
//            self.favButton.imageView?.image = UIImage(named: "favouriteIcon_Active")
//        } else {
//            self.favButton.imageView?.image = UIImage(named: "favouriteIcon")
//        }
        
        //Image
        self.cookImage.setImage(with: URL(string: self.cookInfo?.cooknRESTImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        
        //Name
        self.cookName.text = self.cookInfo?.cooknRESTName ?? ""
        
        //Distance
        self.cookDistance.text = self.cookInfo?.distance ?? ""

        //rating
        self.ratingView.rating = Double(self.cookInfo?.rating ?? 0)
        
        //tagView
        self.tagView.removeAllTags()
        for item in self.cookInfo?.cousinItems ?? [] {
            self.tagView.addTag(item.name ?? "")
        }
        
    }
}

//Ibactions
extension CookCell {
    @IBAction func addToFavButtonAction(_ sender: Any) {
        self.delegate?.addToFavorite(cook: self.cookInfo, atIndex: self.index)
    }
}
