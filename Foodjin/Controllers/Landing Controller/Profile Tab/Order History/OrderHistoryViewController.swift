//
//  OrderHistoryViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Presentr

class OrderHistoryViewController: UIViewController,ScrollPagerDelegate  {

    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var filterView: UIView!

    @IBOutlet var scrollPager: ScrollPager!
    @IBOutlet var orderTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    var Originalorders : [Order]?
    var orders : [Order]?
    var statusData: [StatusData]?
    
    let presenter: Presentr = {
        let width = ModalSize.custom(size: Float(UIScreen.main.bounds.width-60))
        let height = ModalSize.custom(size: Float(UIScreen.main.bounds.height/2+180))
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 30, y: 140))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        customPresenter.blurStyle = UIBlurEffect.Style.dark
        customPresenter.backgroundOpacity = 0.7
        customPresenter.dismissOnSwipe = false
        return customPresenter
    }()
    
    var firstView:OrderFilterTextView?
    var secondView:OrderFilterTextView?
    var thirdView:OrderFilterTextView?

    var firstViewFilterText:String?
    var secondViewFilterText:Date?
    var thirdViewFilterText:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableViewTopConstraint.constant = 5
        self.filterView.isHidden = true
        
        
        self.firstView = Bundle.main.loadNibNamed("OrderFilterTextView", owner: nil, options: nil)?.first as? OrderFilterTextView
        self.firstView?.textView.placeholder = "Order No."
        self.firstView?.delegate = self
        self.firstView?.textViewType = OrderFilterTextViewType.number
        self.firstView?.setup()
        
        self.secondView = Bundle.main.loadNibNamed("OrderFilterTextView", owner: nil, options: nil)?.first as? OrderFilterTextView
        self.secondView?.textView.placeholder = "Order Date"
        self.secondView?.delegate = self
        self.secondView?.textViewType = OrderFilterTextViewType.date
        self.secondView?.setup()
        
        self.thirdView = Bundle.main.loadNibNamed("OrderFilterTextView", owner: nil, options: nil)?.first as? OrderFilterTextView
        self.thirdView?.textView.placeholder = "Order Status"
        self.thirdView?.delegate = self
        self.thirdView?.textViewType = OrderFilterTextViewType.array
        self.thirdView?.dataArray = (self.statusData ?? []).map({$0.status ?? ""})
        self.thirdView?.setup()
    
        if self.navigationController?.viewControllers.count == 1 {
            backButton.isHidden = true
        }
        self.scrollPager.delegate = self
        self.scrollPager.addSegmentsWithTitlesAndViews(segments: [
            ("Order Id", self.firstView!),
            ("Order Date", self.secondView!),
            ("Order Status", self.thirdView!),
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getOrderHistory()
        getOrderStatusWith()
    }

    // MARK: - ScrollPagerDelegate -
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        print("scrollPager index changed: \(changedIndex)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getOrderHistory() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.orderHistory, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(OrderHistory.self, from: jsonData)
//            print(responseDict)
            
            self.orders = responseDict?.responseObj
            self.Originalorders = self.orders
            self.orderTableView.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func getOrderDetailsWithId(orderId: String,completionHandler: @escaping (OrderReviewData)->Void) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "OrderId": orderId,
            "StoreId": STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getOrderDetails, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(OrderReviewData.self, from: jsonData)
            completionHandler(responseDict ?? OrderReviewData())
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func getOrderStatusWith() {
           guard let id = UserDefaults.standard.object(forKey: userId) else { return }
           
           let params = [
               "ApiKey":API_KEY,
               "StoreId": STORE_ID ]
           
           Loader.show(animated: true)
           
        WebServiceManager.instance.post(url: Urls.postOrderStatus, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let statusData = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            print(statusData)
            if let objectsDict = (statusData as? Dictionary<String, Any>),let arr = objectsDict["ResponseObj"] as? Array<Dictionary<String, Any>> {
                let newArr = arr.map { (dict) -> StatusData in
                    
                    return StatusData(status: dict.stringFor("Status"), statusId: dict.intFor("StatusId"))
                }
                self.statusData = newArr
                self.thirdView?.dataArray = (self.statusData ?? []).map({$0.status ?? ""})
            }
            let responseDict = try? JSONDecoder().decode(OrderStatusData.self, from: jsonData)
            
            
        }) { (ResponseStatus) in
               Loader.hide()
               //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
           }
       }

}

//Ibactions
extension OrderHistoryViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetAllButtonAction(_ sender: Any) {
        self.firstView?.textView.text = ""
        self.secondView?.textView.text = ""
        self.thirdView?.textView.text = ""
        
        self.orders = self.Originalorders
        self.orderTableView.reloadData()
    }
}


extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let orderInfo = self.orders?[indexPath.row]
        
        //10 means on the way self.order?.orderStatus == 40
        // do not show cancelled order
        if orderInfo?.orderStatus != 40 {
            //if Order is Confirmed
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TrackOrderViewController") as? TrackOrderViewController else {return}
            newVC.orderId = orderInfo?.orderID ?? 0
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(OrderTableViewCell.identifier, owner: self, options: nil)?.first as? OrderTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.order = self.orders?[indexPath.row]
        mainCell.delegate = self
        mainCell.setCell()
        return mainCell
    }
}

extension OrderHistoryViewController: OrderTableViewCellCommunication, OrderFilterTextViewCommunication, ReviewOrderViewControllerCommunication {
    
    func refreshOrderHistory() {
        self.getOrderHistory()
    }
    
    func enteringCharacted(text: Any, type: OrderFilterTextViewType) {
//        print(text)
//        print(type)
        
        if type == OrderFilterTextViewType.number {
            guard let text = text as? String else { return }
            self.firstViewFilterText = text
            if text == "" {
                self.orders = self.Originalorders
            } else {
                self.orders = self.Originalorders?.filter({ (Order) -> Bool in
                    return Order.orderNumber?.contains(text) ?? false
                })
            }
            
            self.filterRemaningOptions(withArray: self.orders, type: OrderFilterTextViewType.date)
            self.filterRemaningOptions(withArray: self.orders, type: OrderFilterTextViewType.array)
        }
        
        if type == OrderFilterTextViewType.date {
            guard let text = text as? Date else { return }
            self.secondViewFilterText = text

            self.orders = self.Originalorders?.filter({ (Order) -> Bool in
                let dateTo = DateFormatter.date(fromISO8601String: Order.orderTime ?? "")
                return Calendar.current.isDate(text, inSameDayAs:dateTo ?? Date())
            })
            
            self.filterRemaningOptions(withArray: self.orders, type: OrderFilterTextViewType.array)
            self.filterRemaningOptions(withArray: self.orders, type: OrderFilterTextViewType.number)
        }
   
        if type == OrderFilterTextViewType.array {
            guard let text = text as? String else { return }
            self.thirdViewFilterText = text
            if let statusSelected = statusData?.filter({$0.status == text}).first {
                self.orders = self.Originalorders?.filter({$0.orderStatus == statusSelected.statusId })
            }
            
            self.filterRemaningOptions(withArray: self.orders, type: OrderFilterTextViewType.date)
            self.filterRemaningOptions(withArray: self.orders, type: OrderFilterTextViewType.number)
        }
        
        self.orderTableView.reloadData()
    }
    
    func filterRemaningOptions(withArray: [Order]?, type: OrderFilterTextViewType) {

        if type == OrderFilterTextViewType.number {
            guard let text = self.firstViewFilterText else { return }
            if text == "" {
                self.orders = withArray
            } else {
                self.orders = withArray?.filter({ (Order) -> Bool in
                    return Order.orderNumber?.contains(text) ?? false
                })
            }
        }
        
        if type == OrderFilterTextViewType.date {
            guard let text = self.secondViewFilterText else { return }
            
            self.orders = withArray?.filter({ (Order) -> Bool in
                let dateTo = DateFormatter.date(fromISO8601String: Order.orderTime ?? "")
                return Calendar.current.isDate(text, inSameDayAs:dateTo ?? Date())
            })
        }
        
        if type == OrderFilterTextViewType.array {
            guard let text = self.thirdViewFilterText else { return }
            
            self.orders = withArray?.filter({ (Order) -> Bool in
                if text == "Confirmed" {
                    return Order.orderStatus == 20
                } else if text == "Delivered" {
                    return Order.orderStatus == 4
                } else if text == "Canceled" {
                    return Order.orderStatus == 40
                } else {
                    return true
                }
            })
        }
    }
    
    func touchReviewButton(onaddress: Order) {
        //Presenter
        guard let orderId = onaddress.orderID else { return }
        
        self.getOrderDetailsWithId(orderId: "\(orderId)") { (data) in
            
            debugPrint(data)
            
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewPopUpViewController") as? ReviewPopUpViewController else {return}
            newVC.reviewModel = data.responseObj?[0].agentReview
            if let reviewModel = data.responseObj?[0].agentReview {
                self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion:nil)
                newVC.dismissReview = { agentReview in
                    newVC.dismiss(animated: true, completion:nil)
                    
                    guard let restaurantPopVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewRestaurantViewController") as? ReviewRestaurantViewController else {
                        return
                    }
                    restaurantPopVC.reviewModel = data.responseObj?[0].merchantReview
                    self.customPresentViewController(self.presenter, viewController: restaurantPopVC, animated: true, completion: nil)
                    restaurantPopVC.dismissRestaurantReview = { restReview in
                        restaurantPopVC.dismiss(animated: true, completion:nil)
                        
                        guard let dishReviewPopUp = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewDishViewController") as? ReviewDishViewController else {return}
                        dishReviewPopUp.products = data.responseObj?[0].products
                        self.customPresentViewController(self.presenter, viewController: dishReviewPopUp, animated: true, completion:nil)
                        dishReviewPopUp.dismissReview = { productReview in
                            dishReviewPopUp.dismiss(animated: true, completion:nil)
                            self.submitReview(orderId: String(orderId), vendorReview: restReview, productReview: productReview, agentReview: agentReview)
                        }
                    }
                }
            } else if let reviewModel = data.responseObj?[0].merchantReview {
                guard let restaurantPopVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewRestaurantViewController") as? ReviewRestaurantViewController else {
                    return
                }
                restaurantPopVC.reviewModel = reviewModel
                self.customPresentViewController(self.presenter, viewController: restaurantPopVC, animated: true, completion: nil)
                restaurantPopVC.dismissRestaurantReview = { restReview in
                    restaurantPopVC.dismiss(animated: true, completion:nil)
                    
                    guard let dishReviewPopUp = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewDishViewController") as? ReviewDishViewController else {return}
                    dishReviewPopUp.products = data.responseObj?[0].products
                    self.customPresentViewController(self.presenter, viewController: dishReviewPopUp, animated: true, completion:nil)
                    dishReviewPopUp.dismissReview = { productReview in
                        dishReviewPopUp.dismiss(animated: true, completion:nil)
                        self.submitReview(orderId: String(orderId), vendorReview: restReview, productReview: productReview, agentReview: nil)
                    }
                    
                }
            }
            else {
                guard let dishReviewPopUp = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewDishViewController") as? ReviewDishViewController else {return}
                dishReviewPopUp.products = data.responseObj?[0].products
                self.customPresentViewController(self.presenter, viewController: dishReviewPopUp, animated: true, completion:nil)
                dishReviewPopUp.dismissReview = { productReview in
                    dishReviewPopUp.dismiss(animated: true, completion:nil)
                    self.submitReview(orderId: String(orderId), vendorReview: nil, productReview: productReview, agentReview: nil)
                }
            }
        }
    }
    
    func submitReview(orderId:String, vendorReview: [String: Any]?, productReview: [[String: Any]], agentReview: [String: Any]?) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "OrderId": orderId,
            "StoreId": STORE_ID,
            "agentReviews": agentReview,
            "vendorReviews": vendorReview,
            "ReviewProducts": productReview
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.postOrderReview, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            self.getOrderHistory()
            //self.getOnGoingOrderApi()
            //let responseDict = try? JSONDecoder().decode(OrderReviewData.self, from: jsonData)
            //completionHandler(responseDict ?? OrderReviewData())
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            if self.tableViewTopConstraint.constant == 125 {
                self.tableViewTopConstraint.constant = 5
                self.filterView.isHidden = true
            } else {
                self.tableViewTopConstraint.constant = 125
                self.filterView.isHidden = false
            }
        }
    }
}
