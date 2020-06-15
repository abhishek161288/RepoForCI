//
//  CookViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 01/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import TagListView
import MapleBacon
import Presentr

class CookViewController: UIViewController, ScrollPagerDelegate {

    //dynamic Contraints
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationTopTuck: NSLayoutConstraint!

    
    @IBOutlet var scrollPager: ScrollPager!
    @IBOutlet var filterView: UIView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    
    //Availiable
    @IBOutlet weak var availiableCenter: NSLayoutConstraint!
    @IBOutlet weak var availiableBottom: NSLayoutConstraint!
    @IBOutlet weak var availiableTrailing: NSLayoutConstraint!

    //Views
    @IBOutlet weak var cusineImage: UIImageView!
   

    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var cookImageHeight: NSLayoutConstraint!
    @IBOutlet weak var cookImageWidth: NSLayoutConstraint!
    @IBOutlet weak var cookImageCenter: NSLayoutConstraint!
    @IBOutlet weak var cookImageBottom: NSLayoutConstraint!
    @IBOutlet weak var nameLabelCenter: NSLayoutConstraint!
    
    @IBOutlet weak var ratingViewCenter: NSLayoutConstraint!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    @IBOutlet weak var tagViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var cookCusine: UILabel!
    @IBOutlet weak var cookTime: UILabel!

    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var cookRating: FloatRatingView!
    @IBOutlet weak var cookRatingLable: UILabel!
    @IBOutlet weak var cookLocation: UILabel!
    @IBOutlet weak var cookTags: TagListView!

    @IBOutlet weak var tabStackView: UIStackView!
    @IBOutlet weak var productTableView: UITableView!
    
    var restaurantType: RestaurantType = .none
    var products: CookProducts?
    var categoryItems: [CategoryItem]?
    
    var detaiala : CookDetails?
    
    var filters:[[String:String]] = []

    var cookId : String?
    var selectedCategory: Int = 0

    //Filter View
    var sortView:SortView?
    var priceView:DistanceView?
    var ratingView:RatingView?
    var preferencesView:PreferencesView?
    
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
        
        self.filterViewHeight.constant = 0
        self.filterView.isHidden = true
        
        //get Cook Detial
        self.getCookDetailsApi()
        
        //get Filter Values
        self.getFilterValues()
        
        //get products
        self.getCookProductsById(withFilters: self.filters)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addToCartOnShowItemController(notification:)), name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
    }
    
    @objc func addToCartOnShowItemController(notification: NSNotification) {
        self.productTableView.reloadData()
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
    
    func getCookGallery(cookId: Int, completionHandler: @escaping ((CookGallery) -> Void)) {

        let params = [
            "RestnCookId": cookId,
            "APIKey": API_KEY,
            ] as [String : Any]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.galleryApi, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(CookGallery.self, from: jsonData)
            completionHandler(responseDict!)
            
        }) { (ResponseStatus) in
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
        
    }
    
    func getDishDetailApi(cookId: String, productId: String, completionHandler: @escaping ((DishDetails) -> Void)) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustId": id,
            "RestnCookId": cookId,
            "ProductId": productId,
            "APIKey": API_KEY,
            "StoreId": STORE_ID
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.dishDetails, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(DishDetails.self, from: jsonData)
            completionHandler(responseDict!)
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func getCookDetailsApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let params = [
            "CustId": id,
            "APIKey": API_KEY,
            "CustLat": appDelegate.latitudeLabel  ?? "0.0",
            "CustLong": appDelegate.longitudeLabel  ?? "0.0",
            "StoreId": STORE_ID,
            "RestnCookId": self.cookId ?? "0"
        ]
        
        debugPrint(params)
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.cookDetails, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            do {
                let responseDict = try JSONDecoder().decode(CookDetails.self, from: jsonData)
                debugPrint(responseDict)
                //                self.OnGoingDeliveryOrders = responseDict.responseObj?.delivery
                //                self.OnGoingTakeAwayOrders = responseDict.responseObj?.takeaway
            } catch let error{
                debugPrint(error)
            }
            
            let responseDict = try? JSONDecoder().decode(CookDetails.self, from: jsonData)
            //print(responseDict)
            
            self.detaiala = responseDict
            
            guard let details = responseDict?.responseObj?[0] else { return }
            
            self.cookImage.setImage(with: URL(string: details.cooknRESTImageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "No image"))
            var availableText = ""
            if details.isStatusAvailable == true {
                
                self.cookCusine.text = " Available "
                self.cookCusine.isHidden = true
                self.cookCusine.backgroundColor = foodJinGreenColor
            } else {
                
                if let _ = details.openTime {
                    availableText = "\(details.openTime ?? "")"
                    if let _ = details.closeTime {
                        availableText = "\(details.openTime ?? "") - \(details.closeTime ?? "")"
                    }
                }
                self.cookCusine.isHidden = false
                self.cookCusine.text = " Available \(availableText) "
                self.cookCusine.backgroundColor = foodJinRedColor
            }
            //self.cookTime.text = ""
            
//            self.cookTime.isHidden = (self.cookTime.text!.count == 0)
//
//            self.cookTime.backgroundColor = UIColor.brown
//            self.cookTime.layer.cornerRadius = 5.0
//            self.cookTime.clipsToBounds = true

            
            self.cookName.text = details.cooknRESTName ?? ""
            self.cookRating.rating = Double(details.rating ?? 0)
            self.cookRatingLable.text = "Rating \(details.rating ?? 0) (5)"
            //self.cookLocation.text = details.restnCookAddress ?? ""
            
            self.cookTags.removeAllTags()
            self.cookTags.textFont = UIFont.italicSystemFont(ofSize: 12.0)
            for item in details.cousinItems ?? [] {
                self.cookTags.addTag("#\(item.name ?? "")")
            }
            
            //hide cusine image
            if details.cousinItems?.count ?? 0 <= 0 {
                self.cusineImage.isHidden = true
            } else {
                self.cusineImage.isHidden = false
            }
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func getFilterValues() {
        
        let params = [
            "ApiKey": API_KEY,
            "StoreId": STORE_ID
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.cookScreenFilterValues, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(CookFilterValues.self, from: jsonData)
//            print(responseDict)
            
            guard var valuesArray = responseDict?.responseObj else { return }
            
            var segementTitlesAndViews:[(title: String, view: UIView)] = []
            
            for tab in valuesArray {
                
                if tab.titleName == "Sort" {
                    self.sortView = Bundle.main.loadNibNamed(SortView.identifier, owner: self, options: nil)?.first as? SortView
                    self.sortView?.value = tab
                    self.sortView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.sortView!))
                }
                
                if tab.titleName == "Price" {
                    self.priceView = Bundle.main.loadNibNamed(DistanceView.identifier, owner: self, options: nil)?.first as? DistanceView
                    self.priceView?.value = tab
                    self.priceView?.sliderType = DistanceViewType.Price
                    self.priceView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.priceView!))
                }
                
                if tab.titleName == "Rating" {
                    self.ratingView = Bundle.main.loadNibNamed(RatingView.identifier, owner: self, options: nil)?.first as? RatingView
                    self.ratingView?.value = tab
                    self.ratingView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.ratingView!))
                }
                
                if tab.titleName == "Preferences" {
                    self.preferencesView = Bundle.main.loadNibNamed(PreferencesView.identifier, owner: self, options: nil)?.first as? PreferencesView
                    self.preferencesView?.value = tab
                    self.preferencesView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.preferencesView!))
                }
            }
            
            self.scrollPager.delegate = self
            self.scrollPager.scrollView?.delaysContentTouches = false
            self.scrollPager.addSegmentsWithTitlesAndViews(segments: segementTitlesAndViews)
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func getCookProductsById(withFilters: [[String:String]]) {
        
        self.tabStackView.isHidden = true
        
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustId": id,
            "StoreId": STORE_ID,
            "RestnCookId": self.cookId ?? "",
            "ApiKey": API_KEY,
            "Filters": withFilters
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.cookProductsDetail, params: params, successCompletionHandler: { [weak self] (jsonData) in
            Loader.hide()
            
            do {
                let responseDict = try JSONDecoder().decode(CookProducts.self, from: jsonData)
                debugPrint(responseDict)
                //                self.OnGoingDeliveryOrders = responseDict.responseObj?.delivery
                //                self.OnGoingTakeAwayOrders = responseDict.responseObj?.takeaway
            } catch let error{
                debugPrint(error)
            }

            
            let responseDict = try? JSONDecoder().decode(CookProducts.self, from: jsonData)
            //print(responseDict)
            
            
            
            
            self?.products = responseDict
            
            self?.tabStackView.isHidden = false
            self?.tabStackView.removeAllArrangedSubviews()

            var tag = 0
            for categories in responseDict?.responseObj ?? [] {
                let stackButton = UIButton()
                
                stackButton.backgroundColor = UIColor.clear
                stackButton.tag = tag
                stackButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
                stackButton.setTitle(categories.categoryName ?? "", for: .normal)
                stackButton.setTitleColor(UIColor.gray, for: .normal)
                //stackButton.addBottomBorderWithColor(color: foodJinRedColor, width: 1)
                stackButton.layer.borderColor = primaryColor.cgColor
                stackButton.layer.borderWidth = 1.0

                stackButton.addTarget(self, action: #selector(CookViewController.handleCategoryClick), for: .touchUpInside)
                self?.tabStackView.addArrangedSubview(stackButton)
                tag = tag+1
            }
            
//            let currentWidth = self?.tabStackView.frame.size.width ?? 0.0
//            let viewWidth = self?.view.frame.size.width ?? 0.0 - 10.0
//            self?.tabStackView.distribution = UIStackView.Distribution.fillEqually
//            if currentWidth < viewWidth {
//                self?.tabStackView.spacing = (viewWidth - currentWidth) / CGFloat(tag - 1)
//            }
//            else {
//                self?.tabStackView.spacing = 0
//            }
//            self?.tabStackView.alignment = .fill
//            self?.tabStackView.layoutSubviews()
//            self?.tabStackView.setNeedsLayout()
//            self?.tabStackView.layoutIfNeeded()
            
//            self.categoryItems = self.products?.responseObj?[self.selectedCategory].categoryItems
//            self.productTableView.reloadData()
            
            if responseDict?.responseObj?.count ?? 0 > 0 {
                self?.handleCategoryClick(sender: self?.tabStackView.arrangedSubviews[0] as! UIButton)
            }
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    @objc func handleCategoryClick(sender: UIButton) {
        for i in self.tabStackView.arrangedSubviews {
            (i as? UIButton)?.setTitleColor(UIColor.darkGray, for: .normal)
        }
        
        sender.setTitleColor(primaryColor, for: .normal)
        self.selectedCategory = sender.tag
        self.categoryItems = self.products?.responseObj?[sender.tag].categoryItems
        self.productTableView.reloadData()
    }
}

//Ibactions
extension CookViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            if self.filterViewHeight.constant == 200 {
                self.filterViewHeight.constant = 0
                self.filterView.isHidden = true
            } else {
                self.filterViewHeight.constant = 200
                self.filterView.isHidden = false
            }
        }
    }
    
    @IBAction func resetAllButtonAction(_ sender: Any) {
        print("Reset All Button Action")
        
        self.sortView?.clear()
        self.priceView?.clear()
        self.ratingView?.clear()
        self.preferencesView?.clear()
        
        self.filters = []
        self.getCookProductsById(withFilters: self.filters)
    }
    
    @IBAction func ApplyFilterButtonAction(_ sender: Any) {
        print("Apply Filter Button Action")
        
        let categoryName = self.products?.responseObj?[self.selectedCategory].categoryName ?? ""
        
        self.filters = []

//        print(self.sortView?.selectedRadio)
//        print(self.priceView?.brightnessSlider.value)
//        print(self.ratingView?.selectedRating)
//        print(self.preferencesView?.selectedRadio)
    
        
        //adding sort filter
        if self.sortView?.selectedRadio != nil {
            self.filters.append(["Title":"Sort",
                                 "TitleValueName":self.sortView?.selectedRadio?.titleValueName ?? "",
                                 "CategoryName":categoryName])
        }
        
        //adding Distance filter
        if Int(self.priceView?.brightnessSlider.value ?? 0) > 0 {
            self.filters.append(["Title":"Price",
                                 "TitleValueName":"\(Int(self.priceView?.brightnessSlider.value ?? 0))",
                                 "CategoryName":categoryName])
        }
        
        //adding Radio filter
        if self.ratingView?.selectedRating?.count ?? 0 > 0 {
            var values:[String] = []
            for vv in self.ratingView?.selectedRating ?? [] {
                values.append(vv.titleValueName ?? "")
            }
            self.filters.append(["Title":"Rating",
                                 "TitleValueName": values.joined(separator: ","),
                                 "CategoryName":categoryName])
        }
        
        //adding Preferences filter
        if self.preferencesView?.selectedRadio != nil {
            self.filters.append(["Title":"Preferences",
                                 "TitleValueName": self.preferencesView?.selectedRadio?.titleValueName ?? "",
                                 "CategoryName":categoryName])
        }
        
        self.getCookProductsById(withFilters: self.filters)
    }
    
    @IBAction func showGalleryButtonAction(_ sender: Any) {
        
        guard let details = self.detaiala?.responseObj?[0] else { return }

        self.getCookGallery(cookId: details.restnCookID ?? 0) { (cookGallery) in
            //Presenter
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CookGalleryViewController") as? CookGalleryViewController else {return}
            newVC.locationValue = details.restnCookAddress ?? ""
            newVC.gallery = cookGallery
            self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
        }
    }
}


extension CookViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Scrolling \(scrollView.contentOffset)")
//        print("\((scrollView.contentOffset.y)*3)")
        
        let y = scrollView.contentOffset.y
        
        self.topViewHeight.constant = (220 - y) > 130 ? 220 - y : 130
        cookImageWidth.constant = (80 - y/2) > 40 ? (80 - y/2) : 40
        cookImageHeight.constant = (80 - y/2) > 40 ? (80 - y/2) : 40
        let lastX = (self.view.frame.size.width/2 - 30)
        let val = (lastX/90.0) * y
        cookImageCenter.constant = val > lastX ?  -1 * lastX : val * -1
        self.cookImage.layer.cornerRadius = self.cookImage.frame.width/2
        // name Label
        let namePixelsToMove = ((self.view.frame.size.width/2) - (cookName.frame.size.width / 2) - 55)
        let namePixelsToMoveLast = (self.view.frame.size.width/2) - (cookName.frame.size.width / 2) - 55.0
        nameLabelCenter.constant = ((namePixelsToMove / 90.0) * y) < (namePixelsToMoveLast) ? ((namePixelsToMove / 90) * y * -1.0) : CGFloat(namePixelsToMoveLast * -1.0)
        // Available Label
        let distance = (namePixelsToMoveLast - (cookName.frame.size.width / 2)  - (cookCusine.frame.size.width / 2) - 5)
        let availablePixelsToMove = distance
        print("distance: \(distance)")
        print("availablePixelsToMove: \(availablePixelsToMove)")
        let availablePixelsToMoveLast = availablePixelsToMove
        if availablePixelsToMove > 0 {
            availiableCenter.constant = ((availablePixelsToMove / 90.0) * y) < availablePixelsToMoveLast ? ((availablePixelsToMove / 90.0) * y * -1) : (availablePixelsToMoveLast * -1)
        }
        else {
            let val = availablePixelsToMove * -1
            availiableCenter.constant = ((val / 90.0) * y) < (val) ? ((val / 90.0) * y ) : (val )
        }
        availiableBottom.constant = ((16 / 90.0) * y) > 25 ? 25 : (((16 / 90.0) * y) < 10 ? 10 :((16 / 90.0) * y))
        
        
        let ratingPixelsToMove = ((self.view.frame.size.width/2) - (ratingStackView.frame.size.width / 2) - 55)
        let ratingPixelsToMoveLast = (self.view.frame.size.width/2) - (ratingStackView.frame.size.width / 2) - 55.0
        ratingViewCenter.constant = ((ratingPixelsToMove / 90.0) * y) < (ratingPixelsToMoveLast) ? ((ratingPixelsToMove / 90) * y * -1.0) : CGFloat(ratingPixelsToMoveLast * -1.0)
        
        tagViewBottom.constant = (33 - ((59/90) * y)) < ( -18) ? -18 : (33 - ((59/90) * y))
        cookImageBottom.constant = (13 - ((53/90) * y)) < (-40) ? -40 : (13 - ((53/90) * y))
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
//        guard let prodId = self.categoryItems?[indexPath.row].itemID else {return}
//
//        self.getDishDetailApi(cookId: "\(self.cookId ?? "")", productId: "\(prodId)") { [unowned self] (DishDetails) in
//
//            //Presenter
//            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ShowItemViewController") as? ShowItemViewController else {return}
//            newVC.itemDetail = DishDetails
//            newVC.restaurantType = self.restaurantType
//            //todo: dishinfo
//            self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(TopRatedDishesCell.identifier, owner: self, options: nil)?.first as? TopRatedDishesCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.categoryItem = self.categoryItems?[indexPath.row]
        mainCell.setCellForCategory()
        mainCell.restaurantType = restaurantType
        mainCell.delegate = self
        return mainCell
    }
}

extension CookViewController: TopRatedDishesCellCommunication {
    func showDetail(dish: Dish?) {
        print("Shwoing Detil at Cook")
    }
    
    func nowRefreshForCartItems() {
        var paths:[IndexPath] = []
        
        for i in 0...(self.categoryItems?.count ?? 0)-1 {
            paths.append(IndexPath(row: i, section: 0))
        }
        
        if paths.count > 0 {
            //print(paths)
            self.productTableView.reloadRows(at: paths, with: .none)
        }
    }
}
