//
//  TrackOrderContactUsTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 16/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

protocol TrackOrderContactUsTableViewCellCommunication {
    func viewSummary(status: Bool?)
    func havingIssueFoodjin()
    func emailFoodjin()
    func callFoodjin()

}

class TrackOrderContactUsTableViewCell: UITableViewCell {
    
    static let identifier:String = "TrackOrderContactUsTableViewCell"
    var delegate: TrackOrderContactUsTableViewCellCommunication?
    var isViewSummary:Bool = false
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension TrackOrderContactUsTableViewCell {
    @IBAction func viewSummaryButtonAction(_ sender: Any) {
        if self.isViewSummary {
            self.isViewSummary = false
        } else {
            self.isViewSummary = true
        }
        self.delegate?.viewSummary(status: self.isViewSummary)
    }
    
    //havean Issue
    @IBAction func havingFoodjinButtonAction(_ sender: Any) {
        self.delegate?.havingIssueFoodjin()
    }
    
    //email
    @IBAction func emailFoodjinButtonAction(_ sender: Any) {
        self.delegate?.emailFoodjin()
    }
    
    //Call
    @IBAction func callFoodjinButtonAction(_ sender: Any) {
        self.delegate?.callFoodjin()
    }

}
