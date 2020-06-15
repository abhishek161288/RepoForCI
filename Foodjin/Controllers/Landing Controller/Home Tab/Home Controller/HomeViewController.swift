//
//  HomeViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Presentr

enum RestaurantType: String {
    case Delivery = "1"
    case TakeAway = "2"
    case none = "0"
}


class HomeViewController: UIViewController {

   // @IBOutlet weak var controllerTableView: UITableView!
    var topRatedCooks: [Cook]?
    var topRatedDishes: [Dish]?
    var topRatedDrinks: [Dish]?
    var OnGoingDeliveryOrders: [OnGoIngOrderResponseObj]?
    var OnGoingTakeAwayOrders: [OnGoIngOrderResponseObj]?
   // var storeOptions: [GetStoreOptionsResponseObj]?
    var restautants: [Restaurant]?
    var restaurantType = RestaurantType.Delivery
    var shouldReload:Bool = false
   
    @IBOutlet weak var searchBGView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    @IBOutlet weak var takeAwayCollectionView: UICollectionView!
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var takeAwayBtn: UIButton!
    @IBOutlet weak var changeXpositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: MVPlaceSearchTextField!
    
    var deliveryLocationString = ""
    var takeAwayLocationString = ""
    
    weak var CookCollectionView: UICollectionView?
    
    //var headerArray:[String] = []

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
        self.setNeedsStatusBarAppearanceUpdate()
        initializeUIRelated()
        self.textField.placeSearchDelegate                 = self;
        self.textField.strApiKey                           = "AIzaSyA0yZVwZSRvey9NwyLHv8m_jrnqsyzUhhs";
        self.textField.superViewOfList                     = self.searchBGView;  // View, on which Autocompletion list should be appeared.
        self.textField.autoCompleteShouldHideOnSelection   = true;
        self.textField.maximumNumberOfAutoCompleteRows     = 5;
        self.textField.delegate = self
        self.textField.modifyClearButton(with: UIImage(named: "cross_Text")!)
        takeAwayCollectionView.register(UINib(nibName: "OnGoingOrderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OnGoingOrderView")
        foodCollectionView.register(UINib(nibName: "OnGoingOrderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OnGoingOrderView")
        
        //Get Current Location
        self.getCurrentLocation()
      
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addToCartOnShowItemController(notification:)), name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func addToCartOnShowItemController(notification: NSNotification) {
     //   self.controllerTableView.reloadData()
    }
    
    @objc func setTosklskd(notification: NSNotification) {
        print("Home table view Relode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getRestaurantsAndOnGoingOrders()
    }
    
    func getRestaurantsAndOnGoingOrders() {
        //Get OnGoing Order
        self.getOnGoingOrderApi()
        getRestaurants(restaurantType: restaurantType)
    }
    
    func getRestaurants(restaurantType: RestaurantType) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let latititude = restaurantType.rawValue == RestaurantType.Delivery.rawValue ? appDelegate.latitudeDeliveryLabel : appDelegate.latitudeTakeAwayLabel
        let longitude = restaurantType.rawValue == RestaurantType.Delivery.rawValue ? appDelegate.longitudeDeliveryLabel : appDelegate.longitudeTakeAwayLabel
        
        let params = [
            "CustomerId": id,
            "StoreId": STORE_ID,
            "ApiKey": API_KEY,
            "LatPos":latititude ?? "",
            "LongPos":longitude ?? "",
            "SplitSize": 10,
            "EndItemCount": 0,
            "CurrentDate": Date().toString(format: .isoDateTimeSec), //"2019-10-23T14:37:47.313Z"
            "RestType": restaurantType.rawValue
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getRestaurantsByTypeApi, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            print(jsonData)
            Loader.hide()
//            
//            do {
//                let responseDict = try JSONDecoder().decode(GetRestaurantsByType.self, from: jsonData)
//                debugPrint(responseDict)
////                self.OnGoingDeliveryOrders = responseDict.responseObj?.delivery
////                self.OnGoingTakeAwayOrders = responseDict.responseObj?.takeaway
//            } catch let error{
//                debugPrint(error)
//            }
//            
            let responseDict = try? JSONDecoder().decode(GetRestaurantsByType.self, from: jsonData)
            //print(responseDict)
            
            self.restautants = responseDict?.responseObj
           // if self.restautants != nil {
            if restaurantType == RestaurantType.Delivery {
                self.foodCollectionView.reloadData()
            } else {
                self.takeAwayCollectionView.reloadData()
            }
        }) { (ResponseStatus) in
            Loader.hide()
        }
    }
    
    func getOnGoingOrderApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }

        let params = [
            "CustomerId": id,
            "StoreId": STORE_ID,
            "ApiKey": API_KEY,
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.OnGoingOrderApi, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            do {
                let response = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                debugPrint(response)
                let responseDict = try JSONDecoder().decode(OnGoIngOrder.self, from: jsonData)
                debugPrint(responseDict)
                let notToShowOrder: String = (UserDefaults.standard.value(forKey: "not-toshow") as? String) ?? ""
                self.OnGoingDeliveryOrders = responseDict.responseObj?.delivery?.filter({($0.status  ?? "") != "Cancelled" && (($0.orderID  ?? "") != notToShowOrder)})
                self.OnGoingTakeAwayOrders = responseDict.responseObj?.takeaway?.filter({($0.status  ?? "") != "Cancelled"})
            } catch let error{
                debugPrint(error)
            }

            self.takeAwayCollectionView.reloadData()
            self.foodCollectionView.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
        }
    }

 
    //Mark:- Custom Methods
    func initializeUIRelated() {
        horizontalScrollView.delegate = self
        foodCollectionView.register(UINib(nibName:"FoodItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"FoodItemCollectionViewCellIdentifier")
        takeAwayCollectionView.register(UINib(nibName:"FoodItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"FoodItemCollectionViewCellIdentifier")
    }
    
    func deliveryBtnUISetup(sender : UIButton) {
        sender.setTitleColor( UIColor.white, for: .normal)
        takeAwayBtn.setTitleColor(UIColor.lightGray, for: .normal)
        setAnimationOfSegmentIndicator(xPos: sender.frame.origin.x, isDeliveryBtn: true)
        self.horizontalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func takeAwayBtnUISetup(sender : UIButton) {
        sender.setTitleColor( UIColor.white, for: .normal)
        deliveryBtn.setTitleColor(UIColor.lightGray, for: .normal)
        setAnimationOfSegmentIndicator(xPos: sender.frame.origin.x, isDeliveryBtn: false)
        self.horizontalScrollView.setContentOffset(CGPoint(x: horizontalScrollView.frame.size.width, y: 0), animated: true)
    }
    
    func setAnimationOfSegmentIndicator(xPos : CGFloat, isDeliveryBtn: Bool) {
        if xPos != segmentView.frame.origin.x {
            if isDeliveryBtn {
                foodCollectionView.reloadData()
            } else{
                takeAwayCollectionView.reloadData()
            }
            UIView .animate(withDuration: 0.3, animations: {
                self.changeXpositionConstraint.constant = xPos
                self.view.layoutIfNeeded()
            }
            )
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func deliveryBtnAction(_ sender: UIButton) {
        removeAllRestaurants()
        restaurantType = RestaurantType.Delivery
        getRestaurants(restaurantType: restaurantType)
        deliveryBtnUISetup(sender: sender)
        setUpLocationText()
    }
    
    @IBAction func takeAwayBtnAction(_ sender: UIButton) {
        removeAllRestaurants()
        restaurantType = RestaurantType.TakeAway
        getRestaurants(restaurantType: restaurantType)
        takeAwayBtnUISetup(sender: sender)
        setUpLocationText()
    }
    
    func removeAllRestaurants() {
        self.restautants?.removeAll()
    }
    
    func setUpLocationText() {
        if restaurantType == RestaurantType.Delivery {
            self.textField.text = self.deliveryLocationString
        } else if (restaurantType == RestaurantType.TakeAway) {
            self.textField.text = self.takeAwayLocationString
        }
    }
}

//MARK:- Collection Delegate And Data Source
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if restaurantType == RestaurantType.Delivery {
            if self.OnGoingDeliveryOrders?.count ?? -1 > 0 {
                return CGSize(width: takeAwayCollectionView.frame.width, height: 70.0)
            }
        } else if (restaurantType == RestaurantType.TakeAway) {
            if self.OnGoingTakeAwayOrders?.count ?? -1 > 0 {
                return CGSize(width: takeAwayCollectionView.frame.width, height: 70.0)
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OnGoingOrderView", for: indexPath) as! OnGoingOrderView
            headerView.delegate = self
            if collectionView == foodCollectionView {
                headerView.OnGoingOrders = self.OnGoingDeliveryOrders
                headerView.collectionView.reloadData()
            } else if collectionView == takeAwayCollectionView {
                headerView.OnGoingOrders = self.OnGoingTakeAwayOrders
                headerView.collectionView.reloadData()
            }
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width) / 2 - 10
        return CGSize(width: itemSize, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.restautants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCollectionViewCellIdentifier", for: indexPath as IndexPath) as! FoodItemCollectionViewCell
        let restaurant = restautants![indexPath.row]
        cell.resturantName.text = restaurant.cooknRestName ?? ""
        
        cell.resturantAddressLbl.text = restaurant.restnCookAddress ?? ""
        cell.foodType.text = restaurant.cuisine ?? ""
        
        cell.isOpenLbl.text = restaurant.isRestAvailable ?? false ? "Open" : "Close"
        cell.isOpenLbl.backgroundColor = restaurant.isRestAvailable ?? false ? primaryColor : secondaryColor
        cell.resturantTimeLbl.text = restaurant.openTime ?? "" + "-" + (restaurant.closeTime ?? "")
        cell.resturantTimeLbl.text = ""
        if let _ = restaurant.openTime {
            cell.resturantTimeLbl.text = "\(restaurant.openTime ?? "")"
            cell.foodTime.text = restaurant.openTime ?? ""
            if let _ = restaurant.closeTime {
                cell.resturantTimeLbl.text = "\(restaurant.openTime ?? "") - \(restaurant.closeTime ?? "")"
            }
        }
        cell.resturantTimeLbl.isHidden = restaurant.isRestAvailable ?? false
        #if ECUADOR
        cell.foodTimeView.isHidden = false
        #else
        cell.foodTimeView.isHidden = true
        #endif
        if let imageUrl = restaurant.cooknRestImageURL {
            let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ImageCacheLoader.shared.obtainImageWithPath(imagePath: urlString!) { (image) in
                if let cellToUpdate = collectionView.cellForItem(at: indexPath) as? FoodItemCollectionViewCell {
                    cellToUpdate.foodImage.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(restaurantType)
        let restaurant = restautants![indexPath.row]
        debugPrint(restautants)
        if let restId = restaurant.restnCookId {
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CookViewController") as? CookViewController else {return}
            newVC.cookId = "\(restId)"
            newVC.restaurantType = self.restaurantType
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
}

//MARK:- Scrollview delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width
        if shouldReload {
            if indexOfPage == 0 {
                removeAllRestaurants()
                restaurantType = RestaurantType.Delivery
                getRestaurants(restaurantType: restaurantType)
                deliveryBtnUISetup(sender: deliveryBtn)
                setUpLocationText()
            }else {
                removeAllRestaurants()
                restaurantType = RestaurantType.TakeAway
                getRestaurants(restaurantType: restaurantType)
                takeAwayBtnUISetup(sender: takeAwayBtn)
                setUpLocationText()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let indexOfPage = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.size.width)
        if indexOfPage > 50 {
            shouldReload = true
        }
        else {shouldReload = false}
    }
}

extension HomeViewController: PlaceSearchTextFieldDelegate,UITextFieldDelegate {
    
    func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        self.view.endEditing(true)
//        print("SELECTED ADDRESS : \(responseDict)")
        
        if restaurantType == RestaurantType.Delivery {
            self.textField.text = responseDict.formattedAddress
            self.deliveryLocationString =  responseDict.formattedAddress ?? ""
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.latitudeDeliveryLabel = "\(responseDict.coordinate.latitude)"
            appDelegate.longitudeDeliveryLabel = "\(responseDict.coordinate.longitude)"
            
        } else if (restaurantType == RestaurantType.TakeAway) {
            self.textField.text = responseDict.formattedAddress
            self.takeAwayLocationString =  responseDict.formattedAddress ?? ""
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.latitudeTakeAwayLabel = "\(responseDict.coordinate.latitude)"
            appDelegate.longitudeTakeAwayLabel = "\(responseDict.coordinate.longitude)"
        }
        removeAllRestaurants()
        getRestaurantsAndOnGoingOrders()
    }
    
    func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
        debugPrint("Ended")
        self.searchBGView.isHidden = false
    }
    
    func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
        debugPrint("Ended")
        self.searchBGView.isHidden = true
    }
    
    func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func getCurrentLocation() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let lat = CLLocationDegrees(Double(appDelegate.latitudeDeliveryLabel ?? "0.0") ?? 0.0)
        let long = CLLocationDegrees(Double(appDelegate.longitudeDeliveryLabel ?? "0.0") ?? 0.0)
        let cordinates = CLLocationCoordinate2DMake(lat, long)
        GMSGeocoder().reverseGeocodeCoordinate(cordinates) { (res, err) in
            //print(res?.results())
            
            if res?.results()?.count ?? 0 > 0 {
                for address in res?.results() ?? [] {
                    self.textField.text = address.lines?.joined(separator: ",")
                    self.deliveryLocationString = address.lines?.joined(separator: ",") ?? ""
                    self.takeAwayLocationString = address.lines?.joined(separator: ",") ?? ""
                    break
                }
            } else {
                self.textField.text = ""
            }
            
        }
    }
}

extension HomeViewController: OnGoingOrderCollectionViewCellCommunication {
    
    func onGoingOrderCrossClick(TrackOrderId: String?) {
        UserDefaults.standard.set(TrackOrderId!, forKey: "not-toshow")
        self.OnGoingDeliveryOrders = self.OnGoingDeliveryOrders?.filter({$0.orderID != TrackOrderId})
        self.foodCollectionView.reloadData()
        self.takeAwayCollectionView.reloadData()
    }

    func onGoingOrderClick(TrackOrderId: String?, delivered: Bool) {
        
        if delivered {
            getOrderDetailsWithId(orderId: TrackOrderId!) { (data) in
                debugPrint(data)
                guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ReviewPopUpViewController") as? ReviewPopUpViewController else {return}
                if let reviewModel = data.responseObj?[0].agentReview {
                    newVC.reviewModel = reviewModel
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
                                self.submitReview(orderId: TrackOrderId!, vendorReview: restReview, productReview: productReview, agentReview: agentReview)
                            }
                        }
                        restaurantPopVC.dismissCloseButton = {
                            UserDefaults.standard.set(data.responseObj![0].orderID, forKey: "not-toshow")
                        }
                    }
                    newVC.dismissCloseButton = {
                        UserDefaults.standard.set(data.responseObj![0].orderID, forKey: "not-toshow")
                    }
                    
                } else {
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
                            self.submitReview(orderId: TrackOrderId!, vendorReview: restReview, productReview: productReview, agentReview: nil)
                            UserDefaults.standard.set(data.responseObj![0].orderID, forKey: "not-toshow")
                        }
                        dishReviewPopUp.dismissCloseButton = {
                            UserDefaults.standard.set(data.responseObj![0].orderID, forKey: "not-toshow")
                        }
                        
                    }
                    restaurantPopVC.dismissCloseButton = {
                        UserDefaults.standard.set(data.responseObj![0].orderID, forKey: "not-toshow")
                    }
                }
            }
        } else {
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TrackOrderViewController") as? TrackOrderViewController else {return}
            newVC.orderId = Int(TrackOrderId ?? "0")
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    func submitReview(orderId:String, vendorReview: [String: Any], productReview: [[String: Any]], agentReview: [String: Any]?) {
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
            
            self.getOnGoingOrderApi()
            //let responseDict = try? JSONDecoder().decode(OrderReviewData.self, from: jsonData)
            //completionHandler(responseDict ?? OrderReviewData())
            
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
            let response = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            print(response)
            let responseDict = try? JSONDecoder().decode(OrderReviewData.self, from: jsonData)
            completionHandler(responseDict ?? OrderReviewData())
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
}

//POST /api/v1/GetOrderedProdutsforReviewByID

//    func getStoreOptionsApi() {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//
//        let params = [
//            "CustomerId": id,
//            "StoreId": STORE_ID,
//            "ApiKey": API_KEY,
//        ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.getStoreOptionsApi, params: params, successCompletionHandler: { [unowned self] (jsonData) in
//            Loader.hide()
//            let responseDict = try? JSONDecoder().decode(GetStoreOptions.self, from: jsonData)
//            print(responseDict)
//
//            self.storeOptions = responseDict?.responseObj
//
//            if self.OnGoingOrders?.count ?? 0 > 0 {
//                self.headerArray[0] = "OnGoingOrder"
//              //  self.controllerTableView.reloadData()
//            }
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//        }
//    }


//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.headerArray.count
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.headerArray[indexPath.section] == "default" {
//            return 0
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = UITableViewCell()
//
//        switch self.headerArray[indexPath.section] {
//        case "OnGoingOrder":
//
//            guard let mainCell = Bundle.main.loadNibNamed(OnGoingOrderTableViewCell.identifier, owner: self, options: nil)?.first as? OnGoingOrderTableViewCell else {
//                return cell
//            }
//            mainCell.delegate = self
//            mainCell.OnGoingOrders = self.OnGoingOrders
//            return mainCell
//
//        case "TopRatedCooks":
//            guard let mainCell = Bundle.main.loadNibNamed(HorizontalTableViewCell.identifier, owner: self, options: nil)?.first as? HorizontalTableViewCell else {
//                return cell
//            }
//            mainCell.selectionStyle = .none
//            mainCell.CellTitle.text = "Top Rated Chefs"
//            mainCell.AllButton.setTitle("All Chefs", for: .normal)
//            mainCell.cellType = HorizontalTableViewCellType.CookCell
//            mainCell.delegate = self
//            mainCell.cooks = self.topRatedCooks
//            return mainCell
//
//        case "TopRatedDishes":
//            guard let mainCell = Bundle.main.loadNibNamed(HorizontalTableViewCell.identifier, owner: self, options: nil)?.first as? HorizontalTableViewCell else {
//                return cell
//            }
//            mainCell.selectionStyle = .none
//            mainCell.CellTitle.text = "Top Rated Dishes"
//            mainCell.AllButton.setTitle("All Dishes", for: .normal)
//            mainCell.cellType = HorizontalTableViewCellType.DishCell
//            mainCell.delegate = self
//            mainCell.dishes = self.topRatedDishes
//            return mainCell
//
//        case "TopRatedDrinks":
//            guard let mainCell = Bundle.main.loadNibNamed(HorizontalTableViewCell.identifier, owner: self, options: nil)?.first as? HorizontalTableViewCell else {
//                return cell
//            }
//            mainCell.selectionStyle = .none
//            mainCell.CellTitle.text = "Top Rated Drinks"
//            mainCell.AllButton.setTitle("All Drinks", for: .normal)
//            mainCell.cellType = HorizontalTableViewCellType.DrinksCell
//            mainCell.delegate = self
//            mainCell.dishes = self.topRatedDrinks
//            return mainCell
//
//        default:
//            return cell
//        }
//    }
//}

//extension HomeViewController: HorizontalTableViewCellCellCommunication, OnGoingOrderCollectionViewCellCommunication {
//
//    func nowRefresh() {
//        let index = self.headerArray.firstIndex(of: "TopRatedDishes")
//        guard let getCell = self.controllerTableView.cellForRow(at: IndexPath.init(row: 0, section: index ?? 0)) as? HorizontalTableViewCell else {
//            return
//        }
//
//        let index2 = self.headerArray.firstIndex(of: "TopRatedDrinks")
//        guard let getCell2 = self.controllerTableView.cellForRow(at: IndexPath.init(row: 0, section: index2 ?? 0)) as? HorizontalTableViewCell else {
//            return
//        }
//
//        getCell.refreshing()
//        getCell2.refreshing()
//    }
//
//    func onGoingOrderClick(TrackOrderId: String?) {
//
//        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TrackOrderViewController") as? TrackOrderViewController else {return}
//        newVC.orderId = Int(TrackOrderId ?? "0")
//        self.navigationController?.pushViewController(newVC, animated: true)
//    }
//
//    func touchOnHoriZontalCell(type: HorizontalTableViewCellType, indexNumber: Int) {
//        //print("Cell No: \(type), IndexNo: \(indexNumber)")
//
//        if type == HorizontalTableViewCellType.CookCell {
//
//            guard let cookId = self.topRatedCooks?[indexNumber].restnCookID else { return }
//
//            //Open Cook View Controller
//            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CookViewController") as? CookViewController else {return}
//            newVC.cookId = "\(cookId)"
//            self.navigationController?.pushViewController(newVC, animated: true)
//
//        } else if type == HorizontalTableViewCellType.DishCell {
//
//            guard let cookId = self.topRatedDishes?[indexNumber].restnCookID else {return}
//            guard let prodId = self.topRatedDishes?[indexNumber].itemID else {return}
//
//            self.getDishDetailApi(cookId: "\(cookId)", productId: "\(prodId)") { [unowned self] (DishDetails) in
//                //Presenter
//                guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ShowItemViewController") as? ShowItemViewController else {return}
//                newVC.itemDetail = DishDetails
//                newVC.dishInfo = self.topRatedDishes?[indexNumber]
//                self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
//            }
//
//        } else {
//            guard let cookId = self.topRatedDrinks?[indexNumber].restnCookID else {return}
//            guard let prodId = self.topRatedDrinks?[indexNumber].itemID else {return}
//
//            self.getDishDetailApi(cookId: "\(cookId)", productId: "\(prodId)") { [unowned self] (DishDetails) in
//                //Presenter
//                guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ShowItemViewController") as? ShowItemViewController else {return}
//                newVC.itemDetail = DishDetails
//                newVC.dishInfo = self.topRatedDrinks?[indexNumber]
//                self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
//            }
//        }
//    }
//
//    func touchOnTopButton(type: HorizontalTableViewCellType) {
//        if type == HorizontalTableViewCellType.CookCell {
//            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TopRatedCooksViewController") as? TopRatedCooksViewController else {return}
//            self.navigationController?.pushViewController(newVC, animated: true)
//        }
//
//        if type == HorizontalTableViewCellType.DishCell {
//            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TopRatedDishesViewController") as? TopRatedDishesViewController else {return}
//            newVC.isDrinksCtrl = false
//            self.navigationController?.pushViewController(newVC, animated: true)
//        }
//
//        if type == HorizontalTableViewCellType.DrinksCell {
//            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "TopRatedDishesViewController") as? TopRatedDishesViewController else {return}
//            newVC.isDrinksCtrl = true
//            self.navigationController?.pushViewController(newVC, animated: true)
//        }
//    }
//
//    func addToFavoriteThisChef(cook: Cook?,  atIndex: Int?) {
//        if cook?.isLike == true {
//            //dislike
//            self.likeThisCook(cook: cook,like: false, atIndex: atIndex)
//        } else {
//            //like
//            self.likeThisCook(cook: cook,like: true, atIndex: atIndex)
//        }
//    }
//
//    func likeThisCook(cook: Cook?, like: Bool, atIndex: Int?) {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//
//        let params = [
//            "CustomerId": id,
//            "RestnCookId": "\(cook?.restnCookID ?? 0)",
//            "APIKey": API_KEY,
//            "IsLike": like.description,
//            "StoreId": STORE_ID
//            ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.markCookLike, params: params, successCompletionHandler: { [unowned self] (jsonData) in
//            Loader.hide()
//            //let responseDict = try? JSONDecoder().decode(VerifyRegistration.self, from: jsonData)
//            //print(responseDict)
//
//            self.modifyitsStructure(id: cook?.restnCookID ?? 0, isLike: like, completionHandler: { _ in
//                let index = self.headerArray.firstIndex(of: "TopRatedCooks")
//                guard let getCell = self.controllerTableView.cellForRow(at: IndexPath.init(row: 0, section: index ?? 0)) as? HorizontalTableViewCell else {
//                    return
//                }
//                getCell.cooks = self.topRatedCooks
//                getCell.collectionView.reloadItems(at: [IndexPath.init(row: atIndex ?? 0, section: 0)])
//                //print("Please relode Cell At: \(atIndex)")
//            })
//
//            //self.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
//        }
//    }
//
//    func modifyitsStructure(id: Int, isLike: Bool, completionHandler: (Bool) -> Void) {
//        var jj: [Cook] = []
//        for var ff in self.topRatedCooks ?? [] {
//            if ff.restnCookID == id {
//                ff.isLike = isLike
//            }
//            jj.append(ff)
//        }
//        self.topRatedCooks = jj
//        completionHandler(true)
//    }
//}

// func getTopRatedCooksApi() {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let params = [
//            "CustomerId": id,
//            "LatPos":appDelegate.latitudeLabel  ?? "0.0",
//            "LongPos":appDelegate.longitudeLabel  ?? "0.0",
//            "StoreId": STORE_ID,
//            "SplitSize": 5,
//            "EndItemCount": 0,
//            "CurrentDate": Date().toString(format: .isoDateTimeSec),
//            "ApiKey": API_KEY,
//            "Filters": [
//                    [
//                    "Title": "",
//                    "TitleValueName": "",
//                    "OrderIndex": "",
//                    "CategoryName": ""
//                    ]
//                ]
//            ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.topRatedCook, params: params, successCompletionHandler: { [unowned self] (jsonData) in
//            Loader.hide()
//            let responseDict = try? JSONDecoder().decode(TopRatedCook.self, from: jsonData)
////            print(responseDict)
//
//            self.controllerTableView.isHidden = false
//
//            self.topRatedCooks = responseDict?.responseObj
//
//            if self.topRatedCooks?.count ?? 0 > 0 {
//                self.headerArray[1] = "TopRatedCooks"
//                self.controllerTableView.reloadData()
//            }
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//            self.controllerTableView.isHidden = false
//            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
//        }
//    }
//
//    func getTopRatedDishesApi() {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let params = [
//            "CustomerId": id,
//            "APIKey": API_KEY,
//            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
//            "LongPos": appDelegate.longitudeLabel  ?? "0.0",
//            "StoreId": STORE_ID,
//            "SplitSize": 5,
//            "EndItemCount": 0
//        ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.topRatedDishes, params: params, successCompletionHandler: { [unowned self] (jsonData) in
//            Loader.hide()
//            let responseDict = try? JSONDecoder().decode(TopRatedDishes.self, from: jsonData)
////            print(responseDict)
//            self.controllerTableView.isHidden = false
//
//            self.topRatedDishes = responseDict?.responseObj
//
//            if self.topRatedDishes?.count ?? 0 > 0 {
//                self.headerArray[2] = "TopRatedDishes"
//                self.controllerTableView.reloadData()
//            }
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//            self.controllerTableView.isHidden = false
//            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
//        }
//    }
//
//    func getTopRatedDrinksApi() {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let params = [
//            "CustomerId": id,
//            "APIKey": API_KEY,
//            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
//            "LongPos": appDelegate.longitudeLabel  ?? "0.0",
//            "StoreId": STORE_ID,
//            "SplitSize": 5,
//            "EndItemCount": 0
//        ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.topRatedDrinks, params: params, successCompletionHandler: { [unowned self] (jsonData) in
//            Loader.hide()
//            let responseDict = try? JSONDecoder().decode(TopRatedDishes.self, from: jsonData)
////            print(responseDict)
//            self.controllerTableView.isHidden = false
//
//            self.topRatedDrinks = responseDict?.responseObj
//
//            if self.topRatedDrinks?.count ?? 0 > 0 {
//                self.headerArray[3] = "TopRatedDrinks"
//                self.controllerTableView.reloadData()
//            }
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//            self.controllerTableView.isHidden = false
//            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
//        }
//    }
//
//    func getDishDetailApi(cookId: String, productId: String, completionHandler: @escaping ((DishDetails) -> Void)) {
//        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
//
//        let params = [
//            "CustId": id,
//            "RestnCookId": cookId,
//            "ProductId": productId,
//            "APIKey": API_KEY,
//            "StoreId": STORE_ID
//        ]
//
//        Loader.show(animated: true)
//
//        WebServiceManager.instance.post(url: Urls.dishDetails, params: params, successCompletionHandler: {  (jsonData) in
//            Loader.hide()
//            let responseDict = try? JSONDecoder().decode(DishDetails.self, from: jsonData)
//            guard let res = responseDict else { return }
//            completionHandler(res)
//
//        }) { (ResponseStatus) in
//            Loader.hide()
//            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
//        }
//    }
