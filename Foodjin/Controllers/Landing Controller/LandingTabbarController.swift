//
//  LandingTabbarController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 23/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Default
import Presentr

protocol LandingTabbarControllerCommunication {
    func noProductInCart()
}

class LandingTabbarController: UITabBarController {
    
    // typealias completion = () -> ()?
    
    var isApplyCouponCode: Bool?
    var couponCode: String?
    
    var cartButton: UIButton?
    var badgeLable: UILabel?
    var addToCartResponse: AddToCart?
    
    var delegates: LandingTabbarControllerCommunication?
    
    let presenter: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        customPresenter.blurStyle = UIBlurEffect.Style.dark
        customPresenter.backgroundOpacity = 0.7
        customPresenter.dismissOnSwipe = true
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "clearCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setToPeru(notification:)), name: NSNotification.Name(rawValue: "clearCart"), object: nil)
        
        //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "orderPlaced"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(setToPeruorderPlaced(notification:)), name: NSNotification.Name(rawValue: "orderPlaced"), object: nil)
        
        //Select Dashboard Page
        //self.selectedIndex = 1
        
        var bottomSafeArea: CGFloat
        
        let window = UIApplication.shared.keyWindow
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = window?.safeAreaInsets.bottom ?? 0.0
        } else {
            bottomSafeArea = bottomLayoutGuide.length
        }
        
        //print("Bottom Safe Area \(bottomSafeArea)")
        
        self.cartButton = UIButton(frame: CGRect(x: self.view.frame.width-70, y: self.tabBar.frame.origin.y-(70+bottomSafeArea), width: 60, height: 60))
        self.cartButton?.backgroundColor = UIColor.black
        self.cartButton?.layer.cornerRadius = 30
        self.cartButton?.clipsToBounds = true
        self.cartButton?.setImage(UIImage(named: "cartIcon(withBg_withoutShadow)"), for: .normal)
        self.cartButton?.addTarget(self, action: #selector(self.cartButtonAction), for: .touchUpInside)
        self.view.addSubview(self.cartButton!)
        
        self.badgeLable = UILabel(frame: CGRect(x: self.cartButton!.frame.maxX-25, y: self.cartButton!.frame.origin.y-7, width: 25, height: 25))
        self.badgeLable?.text = "0"
        self.badgeLable?.textAlignment = .center
        self.badgeLable?.backgroundColor = UIColor(displayP3Red: 255/256, green: 235/256, blue: 235/256, alpha: 1.0)
        self.badgeLable?.layer.cornerRadius = 12.5
        self.badgeLable?.clipsToBounds = true
        self.view.addSubview(self.badgeLable!)
        if UserDefaults.standard.bool(forKey: "badgeval") {
            let tabBarItem = self.tabBar.items![3]
            tabBarItem.badgeValue = "●"
            tabBarItem.badgeColor = .clear
            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: primaryColor], for: .normal)
        }
    }
    
    func hideShowCart(show: Bool) {
        self.cartButton?.isHidden = !show
        self.badgeLable?.isHidden = !show
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Get Card Count
        self.getCartCountApi()
    }
    
    func logoutFromApplication() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = self.tabBar.items?.firstIndex(of: item), index > 0 {
            self.hideShowCart(show: true)
        }
        else {
            if let navControllers = (self.viewControllers?.first as? UINavigationController)?.viewControllers,navControllers.count == 0 {
                self.hideShowCart(show: true)
            }
            else {
                self.hideShowCart(show: false)
            }
        }
        if let index = self.tabBar.items?.firstIndex(of: item), index == 4 {
            let navController = (self.viewControllers![4] as! UINavigationController)
            navController.popToRootViewController(animated: true)
            let searchController = navController.viewControllers.first! as! SearchViewController
            searchController.clearSearch()
            
        }
    }
    
    
}

//IbActions
extension LandingTabbarController {
    
    @objc func cartButtonAction() {
        //print("Touch on cart view ")
        
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController else {return}
        newVC.tabBarCtrl = self
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}


//Api's
extension LandingTabbarController {
 
    func applyCoupenReccrenceApi(remove:Bool = false) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }

        var code = ""
        if (self.isApplyCouponCode == true) {
            code = self.couponCode ?? ""
        }
        
        let params = [
            "ApiKey": API_KEY,
            "StoreId": STORE_ID,
            "CustomerId": id,
            "CartItemId": 0,
            "TipAmount": 0,
            "CouponCode": remove ? "" : code,
        ]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.addProductOnCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(AddToCart.self, from: jsonData)
            //print(responseDict)
            
            self.addToCartResponse = responseDict
            
            //Saving
            self.addToCartResponse?.write(withKey: "SavedCart")
            if !remove {
                UserDefaults.standard.set(self.couponCode, forKey: "coupon")
            }
            else {
                UserDefaults.standard.removeObject(forKey:"coupon")
            }
            
            //self.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alterCart"), object: nil)
            
        }) { (ResponseStatus) in
            Loader.hide()
            print(ResponseStatus.errorMessageTitle ?? "")
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    
    func addProductToCartApi(prodId: Int?, quantity: Int, restId: Int?, completionHandler: @escaping (Bool) -> Void) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        var code = ""
//        if (self.isApplyCouponCode == true) {
//            code = self.couponCode ?? ""
//        }
        if let coupon = (UserDefaults.standard.value(forKey: "coupon") as? String) {
            code = coupon
        }
        
        let params = [
            "ApiKey":API_KEY,
            "ProductId": "\(prodId ?? 0)",
            "quantity": quantity,
            "StoreId":STORE_ID,
            "IsRestnCookChanged": false,
            "CustomerId": id,
            "TipAmount": 0,
            "CouponCode": code,
            "ProductAttributes": [
                [
                    "ProductAttributeMappingId": 0,
                    "ProductAttributeValueId": 0
                ]
            ]
        ]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.addProductOnCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(AddToCart.self, from: jsonData)
            //print(responseDict)
            self.addToCartResponse = responseDict
            
            //print(self.addToCartResponse)
            //Saving
            self.addToCartResponse?.write(withKey: "SavedCart")
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alterCart"), object: nil)
            
            completionHandler(true)
            self.getCartCountApi()
            
        }) { (ResponseStatus) in
            Loader.hide()
            print(ResponseStatus.errorMessageTitle ?? "")
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func increaseProductCountOnCartApi(prodId: Int?, completionHandler: @escaping (Bool) -> Void) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        var CartItemId:Int?
        if let cart = AddToCart.read(forKey: "SavedCart") {
            guard let prods = cart.responseObj?.cartProducts else { return }
            for item in prods {
                if item.productID == prodId {
                    CartItemId = item.cartItemID
                    break
                }
            }
        }
        
        var code = ""
//        if (self.isApplyCouponCode == true) {
//            code = self.couponCode ?? ""
//        }
        if let coupon = (UserDefaults.standard.value(forKey: "coupon") as? String) {
            code = coupon
        }

        let params = [
            "ApiKey": API_KEY,
            "StoreId": STORE_ID,
            "CustomerId": id,
            "CartItemId": CartItemId ?? 0,
            "TipAmount": 0,
            "CouponCode": code,
        ]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.plusProductOnCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(AddToCart.self, from: jsonData)
            //print(responseDict)
            self.addToCartResponse = responseDict
            
            //print(self.addToCartResponse)
            //Saving
            self.addToCartResponse?.write(withKey: "SavedCart")
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alterCart"), object: nil)
            
            completionHandler(true)
            self.getCartCountApi()
            
        }) { (ResponseStatus) in
            Loader.hide()
            print(ResponseStatus.errorMessageTitle ?? "")
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func decreaseProductCountOnCartApi(prodId: Int?, completionHandler: @escaping (Bool) -> Void) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        var CartItemId:Int?
        if let cart = AddToCart.read(forKey: "SavedCart") {
            guard let prods = cart.responseObj?.cartProducts else { return }
            for item in prods {
                if item.productID == prodId {
                    CartItemId = item.cartItemID
                    break
                }
            }
        }
        
        var code = ""
//        if (self.isApplyCouponCode == true) {
//            code = self.couponCode ?? ""
//        }
        if let coupon = (UserDefaults.standard.value(forKey: "coupon") as? String) {
            code = coupon
        }
        
        let params = [
            "ApiKey": API_KEY,
            "StoreId": STORE_ID,
            "CustomerId": id,
            "CartItemId": CartItemId ?? 0,
            "TipAmount": 0,
            "CouponCode": code,
        ]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.minusProductOnCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(AddToCart.self, from: jsonData)
            //print(responseDict)
            self.addToCartResponse = responseDict
            
            //print(self.addToCartResponse)
            //Saving
            self.addToCartResponse?.write(withKey: "SavedCart")
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alterCart"), object: nil)
            
            completionHandler(true)
            self.getCartCountApi()
            
        }) { (ResponseStatus) in
            Loader.hide()
            print(ResponseStatus.errorMessageTitle ?? "")
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func deleteProductFromCartApi(prodId: Int?, completionHandler: @escaping (Bool) -> Void) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }

        var CartItemId:Int?
        if let cart = AddToCart.read(forKey: "SavedCart") {
            guard let prods = cart.responseObj?.cartProducts else { return }
            for item in prods {
                if item.productID == prodId {
                    CartItemId = item.cartItemID
                    break
                }
            }
        }
        
        var code = ""
//        if (self.isApplyCouponCode == true) {
//            code = self.couponCode ?? ""
//        }
        if let coupon = (UserDefaults.standard.value(forKey: "coupon") as? String) {
            code = coupon
        }
        
        let params = [
            "ApiKey": API_KEY,
            "StoreId": STORE_ID,
            "CustomerId": id,
            "CartItemId": CartItemId ?? 0,
            "TipAmount": 0,
            "CouponCode": code,
        ]
        
        Loader.show(animated: true)
        WebServiceManager.instance.post(url: Urls.deleteProductOnCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(AddToCart.self, from: jsonData)
            //print(responseDict)
            self.addToCartResponse = responseDict
            
            //print(self.addToCartResponse)
            //Saving
            self.addToCartResponse?.write(withKey: "SavedCart")
            
            completionHandler(true)
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alterCart"), object: nil)
            
            self.getCartCountApi()
            
        }) { (ResponseStatus) in
            //print(ResponseStatus.errorMessageTitle ?? "")
            Loader.hide()
            
            self.clear()
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noCart"), object: nil)
            
            self.getCartCountApi()
            
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
            
        }
    }
    
    func clear() {
        //self.addToCartResponse?.clear(forKey: "SavedCart")
        self.isApplyCouponCode = false
        UserDefaults.standard.removeObject(forKey: "SavedCart")
        UserDefaults.standard.removeObject(forKey: "coupon")
    }
    
    @objc func setToPeru(notification: NSNotification) {
        self.clear()
    }

    func presentThanyouPopUp(value: PaymentCheckoutResponseObj? , oderId:Int?) {
        
        //Presenter
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ThankyouPopupViewController") as? ThankyouPopupViewController else {return}
        newVC.data = value
        newVC.orderId = oderId
        self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
    }
}


//Cart Api
extension LandingTabbarController {
    
    //Cart Count
    func getCartCountApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID ]
        
        WebServiceManager.instance.post(url: Urls.cartCount, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            
            let responseDict = try? JSONDecoder().decode(CartCount.self, from: jsonData)
            //print(responseDict)
            self.badgeLable?.text = "\(responseDict?.responseObj ?? 0)"
            
            //self.getAllCartItemsApi()
            
        }) { (ResponseStatus) in
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func getAllCartItemsApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
       
        let params = [
            "ApiKey": API_KEY,
            "StoreId": STORE_ID,
            "CustomerId": id,
            "CartItemId": 0,
            "TipAmount": 0,
            "CouponCode": "",
        ]
        
        WebServiceManager.instance.post(url: Urls.addProductOnCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            
            let responseDict = try? JSONDecoder().decode(AddToCart.self, from: jsonData)
            //print(responseDict)
            
            self.addToCartResponse = responseDict
            //Saving
            self.addToCartResponse?.write(withKey: "SavedCart")
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alterCart"), object: nil)
            
        }) { (ResponseStatus) in
            Loader.hide()
        }
    }
    
    //Add Product To Cart
    func addProductToCartApi(prodId: Int?,
                             isReplace: Bool,
                             successCompletionHandler: @escaping (AddToCart) -> Void,
                             failureCompletionHandler: @escaping (ResponseStatus) -> Void) {
        
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        var code = ""
        if (self.isApplyCouponCode == true) {
            code = self.couponCode ?? ""
        }
        
        let params = [
            "ApiKey":API_KEY,
            "productId": "\(prodId ?? 0)",
            "quantity": 1,
            "StoreId":STORE_ID,
            "IsRestnCookChanged": isReplace,
            "CustomerId": id,
            "TipAmount": 0,
            "CouponCode": code,
            "productAttributes": [
                [
//                    "ProductAttributeMappingId": 0,
//                    "ProductAttributeValueId": 0
                ]
            ]
        ]
        
        debugPrint(params)
        
        Loader.show(animated: true) //  [unowned self]
        WebServiceManager.instance.post(url: Urls.addProductOnCart, params: params, successCompletionHandler: { (jsonData) in
            Loader.hide()
            do {
                let responseDict = try JSONDecoder().decode(AddToCart.self, from: jsonData)
                self.addToCartResponse = responseDict
                self.addToCartResponse?.write(withKey: "SavedCart")
                self.getCartCountApi()
                successCompletionHandler(responseDict)
            } catch let error {
                debugPrint(error)
                
            }
        }) { (ResponseStatus) in
            Loader.hide()
            
            failureCompletionHandler(ResponseStatus)
            
            self.getCartCountApi()
        }
    }
    
}
