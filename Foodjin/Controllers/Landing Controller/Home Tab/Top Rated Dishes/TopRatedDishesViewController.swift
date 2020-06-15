//
//  TopRatedDishesViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Presentr

class TopRatedDishesViewController: UIViewController {

    var topRatedDishes: [Dish]?
    @IBOutlet weak var dishesTableView: UITableView!
    @IBOutlet weak var navLable: UILabel!
    var isDrinksCtrl:Bool?

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
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addToCartOnShowItemController(notification:)), name: NSNotification.Name(rawValue: "addToCartOnShowItemController"), object: nil)
        
        if self.isDrinksCtrl ?? false {
            //Get Drinks
            self.navLable.text = "Top Rates Drinks"
            self.getTopRatedDrinksApi()
        } else {
            //Get Dish
            self.getTopRatedDishesApi()
        }
    }
    
    @objc func addToCartOnShowItemController(notification: NSNotification) {
        self.dishesTableView.reloadData()
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

    
    func getTopRatedDishesApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let params = [
            "CustomerId": id,
            "APIKey": API_KEY,
            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
            "LongPos": appDelegate.longitudeLabel  ?? "0.0",
            "StoreId": STORE_ID,
            "SplitSize": 5,
            "EndItemCount": 0
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.topRatedDishes, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(TopRatedDishes.self, from: jsonData)
             //print(responseDict)
            
            self.topRatedDishes = responseDict?.responseObj
            self.dishesTableView.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }

    func getTopRatedDrinksApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let params = [
            "CustomerId": id,
            "APIKey": API_KEY,
            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
            "LongPos": appDelegate.longitudeLabel  ?? "0.0",
            "StoreId": STORE_ID,
            "SplitSize": 5,
            "EndItemCount": 0
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.topRatedDrinks, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(TopRatedDishes.self, from: jsonData)
            //            print(responseDict)
            
            self.topRatedDishes = responseDict?.responseObj
            self.dishesTableView.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//Ibactions
extension TopRatedDishesViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TopRatedDishesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topRatedDishes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cookId = self.topRatedDishes?[indexPath.row].restnCookID else {return}
        guard let prodId = self.topRatedDishes?[indexPath.row].itemID else {return}
        
        self.getDishDetailApi(cookId: "\(cookId)", productId: "\(prodId)") { [unowned self] (DishDetails) in
            //Presenter
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ShowItemViewController") as? ShowItemViewController else {return}
            newVC.itemDetail = DishDetails
            newVC.dishInfo = self.topRatedDishes?[indexPath.row]
            self.customPresentViewController(self.presenter, viewController: newVC, animated: true, completion: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(TopRatedDishesCell.identifier, owner: self, options: nil)?.first as? TopRatedDishesCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.dishInfo = self.topRatedDishes?[indexPath.row]
        mainCell.isDrinkCell = self.isDrinksCtrl
        mainCell.delegate = self
        mainCell.setCell()
        return mainCell
    }
}

extension TopRatedDishesViewController: TopRatedDishesCellCommunication {
    func showDetail(dish: Dish?) {
        print("Shoing Details")
    }
    
    func nowRefreshForCartItems() {
        var paths:[IndexPath] = []
        
        for i in 0...(self.topRatedDishes?.count ?? 0)-1 {
            paths.append(IndexPath(row: i, section: 0))
        }
        
        if paths.count > 0 {
            //print(paths)
            self.dishesTableView.reloadRows(at: paths, with: .none)
        }
    }
}
