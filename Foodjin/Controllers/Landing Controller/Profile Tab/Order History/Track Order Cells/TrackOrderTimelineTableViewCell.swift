//
//  TrackOrderTimelineTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 16/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class TrackOrderTimelineTableViewCell: UITableViewCell {
    
    static let identifier:String = "TrackOrderTimelineTableViewCell"
    @IBOutlet weak var containerStackView: UIStackView!
    var orderedStatusArray: [OrderedStatusArray]?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell() {
        //print(self.orderedStatusArray)
        
        self.containerStackView.removeAllArrangedSubviews()
        
        for i in self.orderedStatusArray ?? [] {
            
            let verticalStackView = UIStackView()
            verticalStackView.axis = .vertical
            //verticalStackView.alignment = .top
            verticalStackView.distribution = .fillEqually
            
            //timeline
            let timeLine = HorizontalTimelineItem()
            if i.isdone ?? false {
                timeLine.fillColor = foodJinGreenColor
                timeLine.strokeColor = foodJinGreenColor
            } else {
                timeLine.fillColor = UIColor.lightGray
                timeLine.strokeColor = UIColor.lightGray
            }
            
            timeLine.lineWidth = 1.0
            timeLine.diameter = 15.0
            timeLine.strokeWidth = 2.0
            timeLine.lineColor = foodJinGreenColor
            verticalStackView.addArrangedSubview(timeLine)
            
            //time
            let time = UILabel()
            time.text = i.statusTime ?? ""
            time.textAlignment = .center
            time.font = UIFont.italicSystemFont(ofSize: 9)
            time.textColor = UIColor.lightGray
            verticalStackView.addArrangedSubview(time)
            
            //status lable
            let status = UILabel()
            status.text = i.statusTitle ?? ""
            status.textAlignment = .center
            status.textColor = UIColor.darkGray
            status.numberOfLines = 0
            status.lineBreakMode = .byWordWrapping
            status.font = UIFont.systemFont(ofSize: 11)
            verticalStackView.addArrangedSubview(status)
            
            self.containerStackView.addArrangedSubview(verticalStackView)
        }
        
    }
    
}
