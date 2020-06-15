//
//  ReviewOrderCollectionViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 09/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

protocol ReviewOrderCollectionViewCellCommunication:class {
    func clickOnLikeDislikeOnAttribute(isLike: Bool, atribute: String, atIndex: Int)
}

class ReviewOrderCollectionViewCell: UICollectionViewCell {

    static let identifier:String = "ReviewOrderCollectionViewCell"
    weak var delegate:ReviewOrderCollectionViewCellCommunication?
    var index:Int?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//ibactions
extension ReviewOrderCollectionViewCell {
    @IBAction func likeButtonAction(_ sender: Any) {
//        print("Like Button Pressed")
//        self.likeButton.isHighlighted = true
//        self.dislikeButton.isHighlighted = false
        
        self.delegate?.clickOnLikeDislikeOnAttribute(isLike: true, atribute: self.lable.text!, atIndex: self.index ?? 0)
    }
    
    @IBAction func DislikeButtonAction(_ sender: Any) {
//        print("Dislike Button Pressed")
//        self.likeButton.isHighlighted = false
//        self.dislikeButton.isHighlighted = true
        self.delegate?.clickOnLikeDislikeOnAttribute(isLike: false, atribute: self.lable.text!, atIndex: self.index ?? 0)

    }
}
