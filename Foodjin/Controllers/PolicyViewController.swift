//
//  PolicyViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 23/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class PolicyViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    var titleLableText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.titleLable.text = self.titleLableText ?? ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
