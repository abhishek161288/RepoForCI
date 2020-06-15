//
//  NewsDetailTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon

class NewsDetailTableViewCell: UITableViewCell {

    static let identifier:String = "NewsDetailTableViewCell"
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    var blogComment: BlogComment?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell() {
        self.profileImage.setImage(with: URL(string: self.blogComment?.userImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.name.text = self.blogComment?.userName ?? ""
        self.desc.text = self.blogComment?.comment ?? ""
    }
    
}
