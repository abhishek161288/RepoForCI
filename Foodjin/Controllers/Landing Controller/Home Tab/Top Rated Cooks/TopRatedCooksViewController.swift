//
//  TopRatedChefsViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class TopRatedCooksViewController: UIViewController, ScrollPagerDelegate {

    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ChefstableView: UITableView!
    @IBOutlet var scrollPager: ScrollPager!
    @IBOutlet var filterView: UIView!
    
    var topRatedCooks: [Cook]?

    //Filter View
    var sortView:SortView?
    var distanceView:DistanceView?
    var cusineView:CuisineView?
    var ratingView:RatingView?
    var preferencesView:PreferencesView?

    var filters:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableViewTopConstraint.constant = 0
        self.filterView.isHidden = true
        
        //Get Filter Values
        self.getFilterValues()
        
        //Get Cook
        self.getTopRatedCooksApi(withFilters: self.filters)
    }
    
    // MARK: - ScrollPagerDelegate -
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        print("scrollPager index changed: \(changedIndex)")
    }
    
    func getTopRatedCooksApi(withFilters: [[String:String]]) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let params = [
            "CustomerId": id,
            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
            "LongPos": appDelegate.longitudeLabel  ?? "0.0",
            "StoreId": STORE_ID,
            "SplitSize": 5,
            "EndItemCount": 0,
            "CurrentDate": Date().toString(format: .isoDateTimeSec),
            "ApiKey": API_KEY,
            "Filters": withFilters
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.topRatedCook, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(TopRatedCook.self, from: jsonData)
            //print(responseDict)
            
            self.topRatedCooks = responseDict?.responseObj
            self.ChefstableView.reloadData()
            
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
        WebServiceManager.instance.post(url: Urls.topRatedCooksFilterValue, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(CookFilterValues.self, from: jsonData)
            //print(responseDict)
            
            guard var valuesArray = responseDict?.responseObj else { return }
            
            var segementTitlesAndViews:[(title: String, view: UIView)] = []
            
            for tab in valuesArray {
//                print(tab)
                
                if tab.titleName == "Sort" {
                    self.sortView = Bundle.main.loadNibNamed(SortView.identifier, owner: self, options: nil)?.first as? SortView
                    self.sortView?.value = tab
                    self.sortView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.sortView!))
                }
                
                if tab.titleName == "Distance" {
                    self.distanceView = Bundle.main.loadNibNamed(DistanceView.identifier, owner: self, options: nil)?.first as? DistanceView
                    self.distanceView?.value = tab
                    self.distanceView?.sliderType = DistanceViewType.Price
                    self.distanceView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.distanceView!))
                }
                
                if tab.titleName == "Cuisine" {
                    self.cusineView = Bundle.main.loadNibNamed(CuisineView.identifier, owner: self, options: nil)?.first as? CuisineView
                    self.cusineView?.value = tab
                    self.cusineView?.refreshView()
                    
                    segementTitlesAndViews.append((tab.titleName ?? "", self.cusineView!))
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

}


//Ibactions
extension TopRatedCooksViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            if self.tableViewTopConstraint.constant == 200 {
                self.tableViewTopConstraint.constant = 0
                self.filterView.isHidden = true
            } else {
                self.tableViewTopConstraint.constant = 200
                self.filterView.isHidden = false
            }
        }
    }
    
    @IBAction func resetAllButtonAction(_ sender: Any) {
       print("Reset All Button Action")
        
        self.sortView?.clear()
        self.distanceView?.clear()
        self.cusineView?.clear()
        self.ratingView?.clear()
        self.preferencesView?.clear()
        
        self.filters = []
        self.getTopRatedCooksApi(withFilters: self.filters)
    }
    
    @IBAction func ApplyFilterButtonAction(_ sender: Any) {
        print("Apply Filter Button Action")
        
        self.filters = []
        
//        print(self.sortView?.selectedRadio)
//        print(self.distanceView?.brightnessSlider.value)
//        print(self.cusineView?.selectedCusines)
//        print(self.ratingView?.selectedRating)
//        print(self.preferencesView?.selectedRadio)
        
        
        //adding sort filter
        if self.sortView?.selectedRadio != nil {
            self.filters.append(["Title":"Sort",
                                 "TitleValueName":self.sortView?.selectedRadio?.titleValueName ?? ""])
        }
        
        //adding Distance filter
        if Int(self.distanceView?.brightnessSlider.value ?? 0) > 0 {
            self.filters.append(["Title":"Distance",
                                 "TitleValueName":"\(Int(self.distanceView?.brightnessSlider.value ?? 0))"])
        }
        
        //adding Cuisine filter
        if self.cusineView?.selectedCusines?.count ?? 0 > 0 {
            var values:[String] = []
            for vv in self.cusineView?.selectedCusines ?? [] {
                values.append(vv.titleValueName ?? "")
            }
            self.filters.append(["Title":"Cuisine",
                                 "TitleValueName": values.joined(separator: ",")])
        }
        
        //adding Radio filter
        if self.ratingView?.selectedRating?.count ?? 0 > 0 {
            var values:[String] = []
            for vv in self.ratingView?.selectedRating ?? [] {
                values.append(vv.titleValueName ?? "")
            }
            self.filters.append(["Title":"Rating",
                                 "TitleValueName": values.joined(separator: ",")])
        }
        
        //adding Preferences filter
        if self.preferencesView?.selectedRadio != nil {
            self.filters.append(["Title":"Preferences",
                                 "TitleValueName": self.preferencesView?.selectedRadio?.titleValueName ?? ""])
        }
        
        self.getTopRatedCooksApi(withFilters: self.filters)
    }
}


extension TopRatedCooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topRatedCooks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

//        print(self.topRatedCooks?[indexPath.row])
        
        guard let cookId = self.topRatedCooks?[indexPath.row].restnCookID else { return }
        
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CookViewController") as? CookViewController else {return}
        newVC.cookId = "\(cookId)"
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()

        guard let mainCell = Bundle.main.loadNibNamed(TopRatedChefsTableViewCell.identifier, owner: self, options: nil)?.first as? TopRatedChefsTableViewCell else {
                return cell
            }
        mainCell.selectionStyle = .none
        mainCell.cookInfo = self.topRatedCooks?[indexPath.row]
        mainCell.delegate = self
        mainCell.setCell()
        return mainCell
    }
}

extension TopRatedCooksViewController: TopRatedChefsTableViewCellCommunication {
    
    func addToFavorite(cook: Cook?) {
        print(cook)
        if cook?.isLike == true {
            //dislike
            self.likeThisCook(cook: cook,like: false)
        } else {
            //like
            self.likeThisCook(cook: cook,like: true)
        }
    }
    
    func likeThisCook(cook: Cook?, like: Bool) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId": id,
            "RestnCookId": "\(cook?.restnCookID ?? 0)",
            "APIKey": API_KEY,
            "IsLike": like.description,
            "StoreId": STORE_ID
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.markCookLike, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(VerifyRegistration.self, from: jsonData)
            print(responseDict)
            
            self.modifyitsStructure(id: cook?.restnCookID ?? 0, isLike: like)
            
            self.ChefstableView.reloadData()
            
            //self.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func modifyitsStructure(id: Int, isLike: Bool) {
        var jj: [Cook] = []
        for var ff in self.topRatedCooks ?? [] {
            if ff.restnCookID == id {
                ff.isLike = isLike
            }
            jj.append(ff)
        }
        self.topRatedCooks = jj
    }
}
