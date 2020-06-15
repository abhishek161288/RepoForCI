//
//  DishCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 01/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon
import TagListView

protocol DishCellCommunication: class {
    func nowRefreshForCartItems()
}

class DishCell: UICollectionViewCell {

    static let identifier:String = "DishCell"
    
    weak var delegate: DishCellCommunication?

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var cusine: UILabel!
    @IBOutlet weak var vegNonVeg: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishRating: FloatRatingView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var cartItemsStepper: GMStepper!
    var dishInfo: Dish?
    var isDrinkCell: Bool?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell() {
        //Image
        self.dishImage.setImage(with: URL(string: self.dishInfo?.imageURL?[0].productImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        
        //Name
        self.dishName.text = self.dishInfo?.itemName ?? ""
        
        //Price
        self.dishPrice.text = self.dishInfo?.price?.until(".") ?? "0"
        
        //rating
        self.dishRating.rating = Double(self.dishInfo?.rating ?? 0)
        
        //tag View
        if self.isDrinkCell ?? false {
            if self.dishInfo?.cuisine?.isEmpty == false {
                self.cusine.isHidden = false
                self.cusine.text = "#\(self.dishInfo?.cuisine ?? "")"
            } else {
                self.cusine.isHidden = true
            }
        } else {
            self.cusine.isHidden = true
        }
        
        if self.isDrinkCell ?? false {
            self.vegNonVeg.isHidden = false
        } else {
            self.vegNonVeg.isHidden = true
        }
        
//        if self.dishInfo?.available ?? true {
//            self.vegNonVeg.image = UIImage(named: "veg_Icon")
//        } else {
//            self.vegNonVeg.image = UIImage(named: "nonVeg_Icon")
//        }
        
        
        if self.dishInfo?.preferences?.count ?? 0 > 0 {
            self.vegNonVeg.setImage(with: URL(string: self.dishInfo?.preferences?[0].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        }
        
        //set add to cart button count from user default
        self.setCartButtonState()
    }
    
    func setCartButtonState() {
        if let cart = AddToCart.read(forKey: "SavedCart") {
            
            let results = cart.responseObj?.cartProducts?.filter { $0.productID == self.dishInfo?.itemID }
            let exists = results?.isEmpty == false
            
            if exists {
                for product in cart.responseObj?.cartProducts ?? [] {
                    if product.productID == self.dishInfo?.itemID {
                        //got product
                        self.addToCartButton.isHidden = true
                        self.cartItemsStepper.value = Double(product.quantity ?? 1)
                    }
                }
            } else {
                //show cart item has been deleted
                self.addToCartButton.isHidden = false
                self.cartItemsStepper.value = 0.0
            }
        }
    }

}

//Ibactions
extension DishCell {
    
    //add to cart button action
    @IBAction func addToCartButtonAction(_ sender: Any) {
        //print("Add to Cart Action")
        
        self.appDelegate.tabbarController?.addProductToCartApi(prodId: self.dishInfo?.itemID, isReplace: false, successCompletionHandler: { (cartResponse) in
            self.addToCartButton.isHidden = true
            self.cartItemsStepper.value = 1

           // UserDefaults.standard.set(self.restaurantType!.rawValue, forKey: "RestaurantType")
            
        }, failureCompletionHandler: { (ResponseStatus) in
            
            let alertController = UIAlertController(title: ResponseStatus.errorMessageTitle ?? "",
                                                    message: ResponseStatus.errorMessage ?? "",
                                                    preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                print("Yes")
                
                //again
                self.appDelegate.tabbarController?.addProductToCartApi(prodId: self.dishInfo?.itemID, isReplace: true, successCompletionHandler: { (cartResponse) in
                    self.addToCartButton.isHidden = true
                    self.cartItemsStepper.value = 1
                    
                    self.delegate?.nowRefreshForCartItems()
                  //  UserDefaults.standard.set(self.restaurantType!.rawValue, forKey: "RestaurantType")
                    
                }, failureCompletionHandler: { (ResponseStatus) in
                })
                
            }
            let alertAction2 = UIAlertAction(title: "No", style: .destructive) { (action) in
                print("No")
                return
            }
            alertController.addAction(alertAction)
            alertController.addAction(alertAction2)
            self.appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }
    
    //Stepper button Action
    @IBAction func stepperButtonAction(_ sender: GMStepper) {
        //print(sender.value)

            if sender.stepperState == .ShouldIncrease {
                self.appDelegate.tabbarController?.increaseProductCountOnCartApi(prodId: self.dishInfo?.itemID, completionHandler: {_ in
                    print("alter cart but dont post notification")
                })
            }
        
            if sender.stepperState == .ShouldDecrease {
                if Int(self.cartItemsStepper.value) == 0 {
                    self.addToCartButton.isHidden = false
                    self.appDelegate.tabbarController?.deleteProductFromCartApi(prodId: self.dishInfo?.itemID, completionHandler: {_ in
                        print("alter cart but dont post notification")
                    })
                } else {
                    self.appDelegate.tabbarController?.decreaseProductCountOnCartApi(prodId: self.dishInfo?.itemID, completionHandler: {_ in
                        print("alter cart but dont post notification")
                    })
                }
            }
    }
    
}
