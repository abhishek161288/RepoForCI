//
//  ShowItemViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 16/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon

class ShowItemViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var itemDetail: DishDetails?
    var dishInfo: Dish?
    
    @IBOutlet weak var vegNonVeg: UIImageView!
    
    @IBOutlet weak var rootHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCusine: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTime: UILabel!
    
    @IBOutlet weak var specificationStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var specificationStackView: UIStackView!
    @IBOutlet weak var productCalories: UILabel!
    @IBOutlet weak var productProtein: UILabel!
    @IBOutlet weak var productFat: UILabel!
    @IBOutlet weak var productFibre: UILabel!

    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productRating: UILabel!
    @IBOutlet weak var productReview: UILabel!
    @IBOutlet weak var productFloatRating: FloatRatingView!

    @IBOutlet weak var viewInformationButton: UIButton!
    
    @IBOutlet weak var cartItemsStepper: GMStepper!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var restaurantType: RestaurantType?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print(self.itemDetail)
//        print(self.dishInfo)
        
        self.descriptionHeightConstraint.constant = 0
        self.viewInformationButton.setTitle("View More Information", for: .normal)
        
        guard var detail = self.itemDetail?.responseObj?[0] else {
            return
        }
        //settings:
        self.productImage.setImage(with: URL(string: detail.imageURL?[0].productImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "no image"))
        
        if detail.cuisine?.isEmpty == false {
            self.productCusine.isHidden = false
            self.productCusine.text = "#\(detail.cuisine ?? "")"
        } else {
            self.productCusine.isHidden = true
            self.productCusine.text = ""
        }
        
        self.productName.text = detail.name ?? ""
        self.productPrice.text = STORE_CURRENCY + (detail.price?.until(".") ?? "0")
        
        if detail.dishPrepareTime == "0 min" {
            self.productTime.text = ""
        } else {
            self.productTime.text = "Dish preparation time: \(detail.dishPrepareTime ?? "")"
        }
        self.productFloatRating.rating = Double(detail.rating ?? 0)
        
        self.productCalories.text = nil
        self.productProtein.text = nil
        self.productFat.text = nil
        self.productFibre.text = nil
        
//        self.productCalories.text = detail.price ?? ""
//        for i in detail.specifications ?? [] {
//
//        }
        
        if detail.preferences?.count ?? 0 > 0 {
            self.vegNonVeg.setImage(with: URL(string: detail.preferences?[0].image ?? ""))
        }

        if detail.specifications?.count ?? 0 > 0 {
            self.specificationStackView.isHidden = false
            self.specificationStackViewHeightConstraint.constant = 55
            
            var i = 0
            while i < detail.specifications?.count ?? 0 {
                
                guard let getItem = detail.specifications?[i] else {break}
                
                if i==0 {
                    self.productCalories.text = "\(getItem.value ?? "")\n\(getItem.name ?? "")"
                }
                if i==1 {
                    self.productProtein.text = "\(getItem.value ?? "")\n\(getItem.name ?? "")"
                }
                if i==2 {
                    self.productFat.text = "\(getItem.value ?? "")\n\(getItem.name ?? "")"
                }
                if i==3 {
                    self.productFibre.text = "\(getItem.value ?? "")\n\(getItem.name ?? "")"
                }
                i=i+1
            }
        } else {
            self.specificationStackView.isHidden = true
            self.specificationStackViewHeightConstraint.constant = 0
        }
        
        
        
        self.productDescription.text = detail.responseObjDescription ?? ""
        self.productRating.text = "Rating \(detail.rating ?? 0)"
        self.productReview.text = "\(detail.reviewCount ?? 0) Reviews"
        
        //Is Hidden
        self.productDescription.isHidden = true
        self.productRating.isHidden = true
        self.productReview.isHidden = true
        self.productFloatRating.isHidden = true
        
        
        //set add to cart button from user default
        if let cart = AddToCart.read(forKey: "SavedCart") {
            
            let results = cart.responseObj?.cartProducts?.filter { $0.productID == detail.id }
            let exists = results?.isEmpty == false
            
            if exists {
                for product in cart.responseObj?.cartProducts ?? [] {
                    if product.productID == detail.id {
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

//Ib Actions
extension ShowItemViewController {
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewInformationButtonAction(_ sender: UIButton) {
        
        if self.rootHeightConstraint.constant == 500 {
            self.viewInformationButton.setTitle("View More Information", for: .normal)
            self.rootHeightConstraint.constant = 300
            self.descriptionHeightConstraint.constant = 0

            self.productDescription.isHidden = true
            self.productRating.isHidden = true
            self.productReview.isHidden = true
            self.productFloatRating.isHidden = true

        } else {
            self.viewInformationButton.setTitle("View Less Information", for: .normal)
            self.rootHeightConstraint.constant = 500
            self.descriptionHeightConstraint.constant = 100

            self.productDescription.isHidden = false
            self.productRating.isHidden = false
            self.productReview.isHidden = false
            self.productFloatRating.isHidden = false
        }
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        
        guard let detail = self.itemDetail?.responseObj?[0] else {
            return
        }
        
        self.appDelegate.tabbarController?.addProductToCartApi(prodId: detail.id, isReplace: false, successCompletionHandler: { (cartResponse) in
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
                self.appDelegate.tabbarController?.addProductToCartApi(prodId: detail.id, isReplace: true, successCompletionHandler: { (cartResponse) in
                    self.addToCartButton.isHidden = true
                    self.cartItemsStepper.value = 1
                    UserDefaults.standard.set(self.restaurantType!.rawValue, forKey: "RestaurantType")
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
        
        guard let detail = self.itemDetail?.responseObj?[0] else {
            return
        }
        
        if sender.stepperState == .ShouldIncrease {
            self.appDelegate.tabbarController?.increaseProductCountOnCartApi(prodId: detail.id, completionHandler: {_ in
                print("Post notification to relode table")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
            })
        }
        
        if sender.stepperState == .ShouldDecrease {
            if Int(self.cartItemsStepper.value) == 0 {
                self.addToCartButton.isHidden = false
                self.appDelegate.tabbarController?.deleteProductFromCartApi(prodId: detail.id, completionHandler: {_ in
                    print("Post notification to relode table")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)                })
            } else {
                self.appDelegate.tabbarController?.decreaseProductCountOnCartApi(prodId: detail.id, completionHandler: {_ in
                    print("Post notification to relode table")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)                })
            }
        }
    }
}
