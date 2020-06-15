//
//  NewsTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon

class NewsTableViewCell: UITableViewCell {
    
    static let identifier:String = "NewsTableViewCell"
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogTime: UILabel!
    @IBOutlet weak var blogCommentCount: UILabel!
    @IBOutlet weak var comentimageview: UIImageView!

    var post: BlogPost?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell() {
        self.profileImage.setImage(with: URL(string: self.post?.chefImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.imageview.setImage(with: URL(string: self.post?.blogImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))

        self.blogTitle.text = self.post?.blogTitle ?? ""
        self.blogTime.text = self.post?.blogTime ?? ""
        if self.post?.blogCommentsCount ?? 0 > 1 {
            self.blogCommentCount.text = "\(self.post?.blogCommentsCount ?? 0) Comments"
        } else {
            self.blogCommentCount.text = "\(self.post?.blogCommentsCount ?? 0) Comment"
        }

        if self.post?.customerImages?.count ?? 0 > 0 {
            self.comentimageview.isHidden = false
            self.comentimageview.setImage(with: URL(string: self.post?.customerImages?[0].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        } else {
            self.comentimageview.isHidden = true
        }
    }
}
