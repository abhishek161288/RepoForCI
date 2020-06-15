//
//  CartTableViewCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 29/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit


class CartTableViewCell: UITableViewCell {

    static let identifier:String = "CartTableViewCell"
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var delButton: UIButton!
    
    //CheckOut
    
    var cartProduct: CartProduct?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell() {
        //var urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        self.productImage.setImage(with: URL(string: self.cartProduct?.productImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.productName.text = self.cartProduct?.productName ?? ""
        self.productPrice.text = "$\(self.cartProduct?.productPrice ?? "0.0")"
        
        self.stepper.value = Double(self.cartProduct?.quantity ?? 1)
    }
    
    @IBAction func deletebuttonAction(_ sender: Any) {
        print("Del Button Action")
        
        let alertController = UIAlertController(title: "Alert", message: "Do you want to Delete this product?", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.appDelegate.tabbarController?.deleteProductFromCartApi(prodId: self.cartProduct?.productID, completionHandler: {_ in
                print("alter cart but dont post notification")
            })
        }
        let alertAction2 = UIAlertAction(title: "No", style: .destructive) { (action) in
        }
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
        self.appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func stepperAction(_ sender: Any) {
//        print("Stepper Button Action")
        
        let send = sender as? GMStepper

        if send?.stepperState == .ShouldIncrease {
            
            self.appDelegate.tabbarController?.increaseProductCountOnCartApi(prodId: self.cartProduct?.productID, completionHandler: {_ in
                print("alter cart but dont post notification")
            })
            
        }
        
        if send?.stepperState == .ShouldDecrease {
            if Int(self.stepper.value) == 0 {
                
                self.appDelegate.tabbarController?.deleteProductFromCartApi(prodId: self.cartProduct?.productID, completionHandler: {_ in
                    print("alter cart but dont post notification")
                })
                
            } else {
                
                self.appDelegate.tabbarController?.decreaseProductCountOnCartApi(prodId: self.cartProduct?.productID, completionHandler: {_ in
                    print("alter cart but dont post notification")
                })
                
            }
        }
    }
    
}
