//
//  NotificationTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    static let identifier:String = "NotificationTableViewCell"
    var notification: Notification?
    
    @IBOutlet weak var notiTitle: UILabel!
    @IBOutlet weak var notiTime: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        self.notiTitle.text = self.notification?.responseObjDescription ?? ""
        self.notiTime.text = "\(self.notification?.orderNotificationDate ?? "") \(self.notification?.orderNotificationTime ?? "")"
    }
    
}
