//
//  CheckoutViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 01/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Presentr
import Default
import Stripe


class CheckoutViewController: UIViewController {

    var myCartResponse: AddToCart?
    var category: String?
    var addrs: AddressArray?
    var orderIdForPayment: Int?

    var IsDelivery: Bool?
    var IsTakeAway: Bool?
    var addTip: Double = 0.0
    var IsApplyCoupon: Bool = false

    var tabBarCtrl:LandingTabbarController?

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var addressInfo: UITextView!

    @IBOutlet weak var numberOfItems: UILabel!
    
    @IBOutlet weak var subtotalValue: UILabel!
    @IBOutlet weak var taxValue: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    @IBOutlet weak var tipValue: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var couponCode: UITextField!
    @IBOutlet weak var couponCodeDeleteButton: UIButton!
    @IBOutlet weak var couponTitleLbl: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var additionalComment: UITextView!

    
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
        
        // Do any additional setup after loading the view.
        
        //print(self.tabBarCtrl)
    
//        (self.buttonStackView.arrangedSubviews[0] as? UIButton)?.setImage(UIImage(named: "filterRadioBtn_Active"), for: .normal)
//        self.category = "Delivery Address"
//        self.addressLable.text = self.category
//
//        self.IsDelivery = true
//        self.IsTakeAway = false
        
        
        let restaurantType = UserDefaults.standard.value(forKey: "RestaurantType") as? String
        
        if restaurantType == RestaurantType.Delivery.rawValue {
            self.category = "Delivery Address"
            self.IsDelivery = true
            self.IsTakeAway = false
           //let tmpButton = self.buttonStackView.viewWithTag(10) as? UIButton
            (self.buttonStackView.arrangedSubviews[0] as? UIButton)?.setImage(UIImage(named: "filterRadioBtn_Active"), for: .normal)
        } else {
            self.category = "Billing Address"
            self.IsDelivery = false
            self.IsTakeAway = true
           // let tmpButton = self.buttonStackView.viewWithTag(10) as? UIButton
            (self.buttonStackView.arrangedSubviews[1] as? UIButton)?.setImage(UIImage(named: "filterRadioBtn_Active"), for: .normal)
        }
        self.addressLable.text = self.category
        
       // (self.tabBarController as? LandingTabbarController)?.delegates = self
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "noCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setToPeru(notification:)), name: NSNotification.Name(rawValue: "noCart"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "alterCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTosklskd(notification:)), name: NSNotification.Name(rawValue: "alterCart"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Setting View
        self.settingView()
        //self.setUpDeliveryTakeAwayBar()
    }
    
    func settingView() {
        
        if let cart = AddToCart.read(forKey: "SavedCart") {
            
            self.emptyView.isHidden = true
            self.cartView.isHidden = false
            
            //print(cart)
            self.myCartResponse = cart
            
            let totalFromResponse = self.myCartResponse?.responseObj?.total ?? "0"
            let subTotal = self.myCartResponse?.responseObj?.subtotal ?? "0"
            let tax = self.myCartResponse?.responseObj?.tax ?? "0"
            let deliveryCharges = self.myCartResponse?.responseObj?.deliveryCharges ?? "0"
            let tip = self.myCartResponse?.responseObj?.tip ?? "0.0"
            
            self.numberOfItems.text = "\((self.myCartResponse?.responseObj?.cartProducts?.count ?? 0)) Items"
            
            self.cartTableHeight.constant = CGFloat((self.myCartResponse?.responseObj?.cartProducts?.count ?? 0)*100)
            
            self.subtotalValue.text = "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(Double(subTotal)! + Double(self.addTip))"
            
            self.taxValue.text = "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(self.myCartResponse?.responseObj?.tax ?? "0")"
            
            self.deliveryCharges.text = "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(self.myCartResponse?.responseObj?.deliveryCharges ?? "0")"
            let disCountAmount = (self.myCartResponse?.responseObj?.discountAmount ?? "")
            self.tipValue.text = (disCountAmount.count > 0 ? "- "  : "") + "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(self.myCartResponse?.responseObj?.discountAmount ?? "")"
            
            var total = 0.0
            total += Double(totalFromResponse)! + Double(self.addTip)
            total += Double(tax)!
            total += Double(deliveryCharges)!
            total += Double(tip)!

            self.totalValue.text = "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(total)"
            
            self.cartTableView.reloadData()
            if let coupon = (UserDefaults.standard.value(forKey: "coupon") as? String) {
                couponCode.isUserInteractionEnabled = false
                couponCode.text = coupon
                couponTitleLbl.text = "Coupon Used"
                couponCode.backgroundColor = UIColor.clear
                couponCodeDeleteButton.isHidden = false
                applyButton.isHidden = true
            }
            else {
                couponCode.isUserInteractionEnabled = true
                couponCode.text = ""
                couponTitleLbl.text = "Apply Coupon"
                couponCode.backgroundColor = UIColor(displayP3Red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
                couponCodeDeleteButton.isHidden = true
                applyButton.isHidden = false
            }
            
        } else {
            self.emptyView.isHidden = false
            self.cartView.isHidden = true
        }
    }
    
    
//    func applyCoupnApi(code: String) {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//
//        let params = [
//            "CustomerId": id,
//            "StoreId": STORE_ID,
//            "CouponCode": code,
//            "ApiKey": API_KEY,
//            "OrderId": "",
//            "OrderTotal":""
//        ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.applyCoupon, params: params, successCompletionHandler: { [unowned self] (jsonData) in
//            Loader.hide()
//            let responseDict = try? JSONDecoder().decode(CookProducts.self, from: jsonData)
//            print(responseDict)
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
//        }
//    }
    
    func checkOutCartApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let totalFromResponse = self.myCartResponse?.responseObj?.total ?? "0"
        let subTotal = self.myCartResponse?.responseObj?.subtotal ?? "0"
        let tax = self.myCartResponse?.responseObj?.tax ?? "0"
        let tip = self.myCartResponse?.responseObj?.tip ?? "0"
        
        let addressId = Int(self.addrs?.id ?? 0)
        let delCharges = Int(self.myCartResponse?.responseObj?.deliveryCharges ?? "0")
        let Tax = Int(tax)
        let totalTip = Double(tip)! + (self.addTip)
        let discount = Int(self.myCartResponse?.responseObj?.discountAmount ?? "0")
        let subtotal = Double(subTotal)! + Double(self.addTip)
        let total = Double(totalFromResponse)! + Double(self.addTip)
        
        let params = [
            "CustomerId": id,
            "StoreId": STORE_ID,
            "IsDelivery": self.IsDelivery ?? false,
            "ApiKey": API_KEY,
            "IsTakeAway": self.IsTakeAway ?? false,
            "DeliveryAddressId": addressId,
            "BillingAddressId": addressId,
            "DeliveryCharges": delCharges,
            "Tax": Tax,
            "Tip": totalTip,
            "DiscountAmount": discount,
            "Subtotal": subtotal,
            "Total": total,
            "AdditionalComments": self.additionalComment.text ?? "",
            "RestnCookId": 0
        ]
        
        debugPrint(params)
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.checkoutCart, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            //self.getAllPaymentMethods()
            
            do {
                let responseDict = try JSONDecoder().decode(CheckoutCart.self, from: jsonData)
                debugPrint(responseDict)
            } catch let error {
                debugPrint(error)
            }
            
        
            let responseDict = try? JSONDecoder().decode(CheckoutCart.self, from: jsonData)
            //print(responseDict)
            
            //On Hold
//            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ManageCardsViewController") as? ManageCardsViewController else {return}
//            //newVC.chkOutResponse = responseDict?.responseObj
//            self.navigationController?.pushViewController(newVC, animated: true)
            
            //self.addToCartResponse?.clear(forKey: "SavedCart")

            //(self.tabBarController as? LandingTabbarController)?.clear()
            
            // Till here
            
            
            self.orderIdForPayment = responseDict?.responseObj?.orderID
            self.showPaymentMethodsScreen()

            //
//            let addCardViewController = STPAddCardViewController()
//            addCardViewController.delegate = self
//            let navigationController = UINavigationController(rootViewController: addCardViewController)
//            self.present(navigationController, animated: true)
            
        }) { (ResponseStatus) in
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func showPaymentMethodsScreen() {
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "AllPaymentMethodsViewController") as? AllPaymentMethodsViewController else {return}
        newVC.orderIdForPayment = self.orderIdForPayment
        newVC.tabBarCtrl = self.tabBarCtrl
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

extension CheckoutViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func submitTokenToBackend(token: STPToken, completion: (_ error:Error)->()){
        //print("doing this")
        self.paymentConfirmation(token: token.tokenId)
    }
    
    func paymentConfirmation(token: String) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "PaymentToken":token,
            "OrderId": self.orderIdForPayment ?? 0 ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.checkoutPayment, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let response = try? JSONDecoder().decode(PaymentCheckout.self, from: jsonData)
            // print(response)
            
            self.dismiss(animated: true)
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearCart"), object: nil)
            self.navigationController?.popViewControllerWithHandler {
                (self.tabBarCtrl)?.presentThanyouPopUp(value: response?.responseObj, oderId: self.orderIdForPayment ?? 0)
            }
            
        }) { (ResponseStatus) in
            Loader.hide()
            self.dismiss(animated: true)
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        print(token)
        self.submitTokenToBackend(token: token, completion: { (error: Error?) in
            if let error = error {
                // Show error in add card view controller
                completion(error)
            }
            else {
                // Notify add card view controller that token creation was handled successfully
                completion(nil)
                
                // Dismiss add card view controller
                dismiss(animated: true)
            }
        })
    }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myCartResponse?.responseObj?.cartProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(CartTableViewCell.identifier, owner: self, options: nil)?.first as? CartTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.cartProduct = self.myCartResponse?.responseObj?.cartProducts?[indexPath.row]
        mainCell.setCell()
        return mainCell
    }
}

extension CheckoutViewController {
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickAddressButtonAction(_ sender: Any) {
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ManageAddressViewController") as? ManageAddressViewController else {return}
        newVC.isToPick = true
        newVC.delegate = self
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func validate() {
        do {
            _ = try couponCode.validatedText(validationType: ValidatorType.requiredField(field: "Coupon"))
            
            self.IsApplyCoupon = true
            print("Coupon is: \(self.couponCode.text)")
            
            self.tabBarCtrl?.isApplyCouponCode = true
            self.tabBarCtrl?.couponCode = self.couponCode.text ?? ""
            self.tabBarCtrl?.applyCoupenReccrenceApi()
            
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    @IBAction func deleteDiscount() {
        self.tabBarCtrl?.applyCoupenReccrenceApi(remove: true)
    }
    
    @IBAction func applyCouponButtonAction(_ sender: Any) {
        
        self.validate()
        
        //print(self.tabBarCtrl)
        
        //        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        //
        //        var total = 0.0
        //        total += (self.myCartResponse?.responseObj?.subtotal ?? 0.0)
        //        total += Double(self.myCartResponse?.responseObj?.tax ?? 0)
        //        total += Double(self.myCartResponse?.responseObj?.deliveryCharges ?? 0)
        //        total += Double((self.myCartResponse?.responseObj?.tip ?? 0) + self.addTip)
        //
        //        let params = [
        //            "CustomerId":id,
        //            "ApiKey":API_KEY,
        //            "StoreId":STORE_ID,
        //            "CouponCode":self.couponCode.text ?? "",
        //            "OrderId": self.orderIdForPayment ?? 0,
        //            "OrderTotal":total]
        //
        //        Loader.show(animated: true)
        //
        //        WebServiceManager.instance.post(url: Urls.applyCoupon, params: params, successCompletionHandler: { [unowned self] (jsonData) in
        //            Loader.hide()
        //            let response = try? JSONDecoder().decode(PaymentCheckout.self, from: jsonData)
        //            print(response)
        //
        //        }) { (ResponseStatus) in
        //            Loader.hide()
        //            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        //        }
    }
    
    @IBAction func addTipButtonAction(_ sender: Any) {
        //Presenter
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "AddTipViewController") as? AddTipViewController else {return}
        newVC.delegate = self
        self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
    }
    
    @IBAction func handleCategoryClick(sender: UIButton) {
        for i in self.buttonStackView.arrangedSubviews {
            (i as? UIButton)?.setImage(UIImage(named: "filterRadioBtn"), for: .normal)
        }
        sender.setImage(UIImage(named: "filterRadioBtn_Active"), for: .normal)
        
        if sender.tag == 10 {
            self.category = "Delivery Address"
            self.IsDelivery = true
            self.IsTakeAway = false
        } else {
            self.category = "Billing Address"
            self.IsDelivery = false
            self.IsTakeAway = true
        }
        self.addressLable.text = self.category
    }
    
    @IBAction func proceedToPaymentButtonAction(_ sender: Any) {
        print("Payment proceed")
        self.checkOutCartApi()
    }
    
    @IBAction func backToMenuButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CheckoutViewController: AddTipViewControllerCommunication, ManageAddressViewControllerCommunication {
    
    //Address Picked
    func addressPicked(address: AddressArray?) {
        self.addrs = address
        
        self.addressType.text = address?.label ?? ""
        self.addressInfo.text = "\(address?.addressLine1 ?? "") " +
            "\(address?.addressLine2 ?? "") " +
            "\(address?.city ?? "") " +
        "\(address?.zipCode ?? "0")"
    }
    
    //Add Tip
    func addTip(code: String?) {
        //print("Add Tip \(code)")
        
        self.addTip = Double(code ?? "0") ?? 0
        let tip = self.myCartResponse?.responseObj?.tip ?? "0.0"
        
        self.tipValue.text = "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(Double(tip)! + self.addTip)"
        
        let subTotal = self.myCartResponse?.responseObj?.subtotal ?? "0"
        let tax = self.myCartResponse?.responseObj?.tax ?? "0"
        let deliveryCharges = self.myCartResponse?.responseObj?.deliveryCharges ?? "0"
        
        var total = 0.0
        total += Double(subTotal)!
        total += Double(tax)!
        total += Double(deliveryCharges)!
        total += Double(tip)! + (self.addTip)
        
        self.totalValue.text = "\(self.myCartResponse?.responseObj?.currencySymbol ?? "")\(total)"
    }
}


extension CheckoutViewController: LandingTabbarControllerCommunication {
    func noProductInCart() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setToPeru(notification: NSNotification) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setTosklskd(notification: NSNotification) {
        // self.viewDidLoad()
        self.settingView()
    }
}
