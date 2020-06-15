//
//  TopRatedDishesCell.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

protocol TopRatedDishesCellCommunication: class {
    func showDetail(dish: Dish?)
    func nowRefreshForCartItems()
}

class TopRatedDishesCell: UITableViewCell {
    
    static let identifier:String = "TopRatedDishesCell"
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var cusine: UILabel!
    @IBOutlet weak var vegNonVeg: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishRating: FloatRatingView!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var cartItemsStepper: GMStepper!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var cookImageHeight: NSLayoutConstraint!
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dishInfo: Dish?
    var restaurantType: RestaurantType?
    var isDrinkCell: Bool?
    var categoryItem: CategoryItem?
    weak var delegate: TopRatedDishesCellCommunication?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.cookImage.setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f4/100lr_JWGB.jpg"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell() {
        
        //Review Count
        self.reviewCount.text = "\(self.dishInfo?.reviewCount ?? 0) Reviews"
        
        //Image
        self.dishImage.setImage(with: URL(string: self.dishInfo?.imageURL?[0].productImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        
        //Name
        self.dishName.text = self.dishInfo?.itemName ?? ""
        
        //cook Image
        self.cookImage.setImage(with: URL(string: self.dishInfo?.restnCookPictureURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        
        //cook name
        self.cookName.text = self.dishInfo?.restnCook ?? ""

        //Price
        self.dishPrice.text = self.dishInfo?.price?.until(".") ?? "0"
        
        //rating
        self.dishRating.rating = Double(self.dishInfo?.rating ?? 0)
        
        //rating lable
        self.ratingLable.text = "Rating: \(Double(self.dishInfo?.rating ?? 0))"
        
        //Cusine View
        if self.isDrinkCell ?? false {
            self.cusine.isHidden = true
        } else {
            if self.dishInfo?.cuisine?.isEmpty == false {
                self.cusine.isHidden = false
                self.cusine.text = "#\(self.dishInfo?.cuisine ?? "")"
            } else {
                self.cusine.isHidden = true
            }
        }
        
        if self.isDrinkCell ?? false  {
            self.vegNonVeg.isHidden = true
        } else {
            self.vegNonVeg.isHidden = false
        }
        
        if self.dishInfo?.preferences?.count ?? 0 > 0 {
            self.vegNonVeg.setImage(with: URL(string: self.dishInfo?.preferences?[0].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        }
        
        //set add to cart button from user default
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
    
    func setCellForCategory() {
        //Image
        self.dishImage.setImage(with: URL(string: self.categoryItem?.imageURL?[0].productImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        
        //Name
        self.dishName.text = self.categoryItem?.itemName ?? ""
        
        self.cookImage.isHidden = true
        self.cookName.isHidden = true
        self.cookImageHeight.constant = 0
        
        self.dishPrice.text = STORE_CURRENCY + (self.categoryItem?.price?.until(".") ?? "0")

        //rating
        self.dishRating.rating = Double(self.categoryItem?.rating ?? 0)
        
        //rating lable
        self.ratingLable.text = "Rating: \(Double(self.categoryItem?.rating ?? 0))"

        self.reviewCount.text = "\(self.categoryItem?.reviewCount ?? 0) Reviews"

        if self.categoryItem?.cuisine?.isEmpty == false {
            self.cusine.isHidden = false
            self.cusine.text = "#\(self.categoryItem?.cuisine ?? "")"
        } else {
            self.cusine.isHidden = true
        }
        
        if self.categoryItem?.preferences?.count ?? 0 > 0 {
            self.vegNonVeg.setImage(with: URL(string: self.categoryItem?.preferences?[0].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        }
        
        //set add to cart button from user default
        if let cart = AddToCart.read(forKey: "SavedCart") {
            
            let results = cart.responseObj?.cartProducts?.filter { $0.productID == self.categoryItem?.itemID }
            let exists = results?.isEmpty == false
            
            if exists {
                for product in cart.responseObj?.cartProducts ?? [] {
                    if product.productID == self.categoryItem?.itemID {
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

extension TopRatedDishesCell {
    
    //add to cart button action
    @IBAction func addToCartButtonAction(_ sender: Any) {
        //print("Add to Cart Action")
        
        var prodId = 0
        //get product id
        if self.dishInfo != nil {
            prodId = self.dishInfo?.itemID ?? 0
            //restId = self.dishInfo?.restnCookID ?? 0
        } else {
            prodId = self.categoryItem?.itemID ?? 0
        }
        
        
        self.appDelegate.tabbarController?.addProductToCartApi(prodId: prodId, isReplace: false, successCompletionHandler: { (cartResponse) in
            self.addToCartButton.isHidden = true
            self.cartItemsStepper.value = 1
            UserDefaults.standard.set(self.restaurantType!.rawValue, forKey: "RestaurantType")
        }, failureCompletionHandler: { (ResponseStatus) in
            
            let alertController = UIAlertController(title: ResponseStatus.errorMessageTitle ?? "",
                                                    message: ResponseStatus.errorMessage ?? "",
                                                    preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                print("Yes")
                
                //again
                self.appDelegate.tabbarController?.addProductToCartApi(prodId: prodId, isReplace: true, successCompletionHandler: { (cartResponse) in
                    self.addToCartButton.isHidden = true
                    self.cartItemsStepper.value = 1
                    
                   UserDefaults.standard.set(self.restaurantType!.rawValue, forKey: "RestaurantType")
                    
                    self.delegate?.nowRefreshForCartItems()
                    
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
        
        var prodId = 0
        //get product id
        if self.dishInfo != nil {
            prodId = self.dishInfo?.itemID ?? 0
        } else {
            prodId = self.categoryItem?.itemID ?? 0
        }
        
        if sender.stepperState == .ShouldIncrease {
            self.appDelegate.tabbarController?.increaseProductCountOnCartApi(prodId: prodId, completionHandler: {_ in
                print("alter cart but dont post notification")
            })
        }
        
        if sender.stepperState == .ShouldDecrease {
            if Int(self.cartItemsStepper.value) == 0 {
                self.addToCartButton.isHidden = false
                self.appDelegate.tabbarController?.deleteProductFromCartApi(prodId: prodId, completionHandler: {_ in
                    print("alter cart but dont post notification")
                })
            } else {
                self.appDelegate.tabbarController?.decreaseProductCountOnCartApi(prodId: prodId, completionHandler: {_ in
                    print("alter cart but dont post notification")
                })
            }
        }
    }
    
}
