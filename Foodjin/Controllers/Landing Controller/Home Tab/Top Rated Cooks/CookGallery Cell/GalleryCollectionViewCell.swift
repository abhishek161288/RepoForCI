//
//  GalleryCollectionViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 25/08/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon

class GalleryCollectionViewCell: UICollectionViewCell {

    static let identifier:String = "GalleryCollectionViewCell"
    
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var galleryLable: UILabel!
    
    var responseObj: CookGalleryResponseObj?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell() {
        self.galleryImage.setImage(with: URL(string: self.responseObj?.imageURL ?? ""))
        self.galleryLable.text = self.responseObj?.imageCaption
    }

}
