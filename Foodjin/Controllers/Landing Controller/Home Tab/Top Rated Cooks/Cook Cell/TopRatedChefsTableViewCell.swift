//
//  TopRatedChefsTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon
import TagListView

protocol TopRatedChefsTableViewCellCommunication: class {
    func addToFavorite(cook: Cook?)
}

class TopRatedChefsTableViewCell: UITableViewCell {

    weak var delegate: TopRatedChefsTableViewCellCommunication?

    static let identifier:String = "TopRatedChefsTableViewCell"
    
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var cookDistance: UILabel!
    @IBOutlet weak var cookTime: UILabel!

    var cookInfo: Cook?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.cookImage.setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f4/100lr_JWGB.jpg"))
        
        //self.tagView.addTag("one")
        //self.tagView.addTag("two")
        //self.tagView.addTag("three")
        
        self.tagView.textFont = UIFont.italicSystemFont(ofSize: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
            self.availability.backgroundColor = primaryColor
            self.availability.text = "Open"
            self.cookTime.isHidden = true
        } else {
            self.availability.text = "Close"
            self.cookTime.isHidden = false
            self.availability.backgroundColor = secondaryColor
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

        //Cook Time
        var availableText = ""
        if let _ = self.cookInfo?.openTime {
            availableText = "\(self.cookInfo?.openTime ?? "")"
            if let _ = self.cookInfo?.closeTime {
                availableText = "\(self.cookInfo?.openTime ?? "") - \(self.cookInfo?.closeTime ?? "")"
            }
        }
        self.cookTime.text = availableText
        
        //rating
        self.ratingView.rating = Double(self.cookInfo?.rating ?? 0)
        
        //rating lable
        self.ratingLable.text = "Rating \(Double(self.cookInfo?.rating ?? 0)) (5)"
        
        //tagView
        for item in self.cookInfo?.cousinItems ?? [] {
            self.tagView.addTag(item.name ?? "")
        }
    }
}

//Ibactions
extension TopRatedChefsTableViewCell {
    @IBAction func addToFavButtonAction(_ sender: Any) {
        self.delegate?.addToFavorite(cook: self.cookInfo)
    }
}
