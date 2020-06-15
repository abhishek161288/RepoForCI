//
//  ThankyouPopupViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 07/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class ThankyouPopupViewController: UIViewController {

    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var timeField: UILabel!
    
    var orderId: Int?
    var data: PaymentCheckoutResponseObj?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.timeField.text = self.data?.orderArrivalTime ?? ""
        
        
    }

}

//Ib Actions
extension ThankyouPopupViewController {
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewOrderStatusButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TrackOrderViewController") as? TrackOrderViewController else {return}
            newVC.orderId = self.orderId
            (appDelegate.window?.rootViewController as? MainRootNavigationController)?.pushViewController(newVC, animated: true)
        }
    }
}
