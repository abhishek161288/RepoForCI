//
//  AddTipViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 29/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

protocol AddTipViewControllerCommunication: class {
    func addTip(code: String?)
}

class AddTipViewController: UIViewController {

    weak var delegate: AddTipViewControllerCommunication?
    @IBOutlet weak var tipTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//Ib Actions
extension AddTipViewController {
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTipButtonAction(_ sender: Any) {
        self.delegate?.addTip(code: "\((sender as? UIButton)?.tag ?? 0)")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addfinalButtonAction(_ sender: Any) {
        self.delegate?.addTip(code: self.tipTextField.text ?? "0")
        self.dismiss(animated: true, completion: nil)
    }
}
