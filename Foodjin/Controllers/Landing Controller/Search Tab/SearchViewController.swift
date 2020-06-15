//
//  SearchViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchTextField: CustomTextField!
    var results: [Cook]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchTextField.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func clearSearch() {
        if let textField = self.searchTextField {
            textField.text = ""
            self.results = nil
            self.searchTable.reloadData()
        }
        
    }
    
    func searchApi(searchValue: String) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "LatPos": appDelegate.latitudeLabel  ?? "0.0",
            "LongPos": appDelegate.longitudeLabel  ?? "0.0",
            "StoreId": STORE_ID,
            "SearchValue": searchValue ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.search, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(SearchResult.self, from: jsonData)
            //print(responseDict)
            self.results = responseDict?.responseObj
            self.searchTable.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
           // self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }

}

extension SearchViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(self.searchTextField.text)
        
        self.searchApi(searchValue: self.searchTextField.text ?? "")
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "CookViewController") as? CookViewController else {return}
        newVC.cookId = "\(self.results?[indexPath.row].restnCookID ?? 0)"
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
        mainCell.cookInfo = self.results?[indexPath.row]
        mainCell.setCell()
        mainCell.delegate = self
        return mainCell
    }
}

extension SearchViewController: TopRatedChefsTableViewCellCommunication {
    
    func addToFavorite(cook: Cook?) {
        //print(cook)
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
            
            self.searchTable.reloadData()
            
            //self.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func modifyitsStructure(id: Int, isLike: Bool) {
        var jj: [Cook] = []
        for var ff in self.results ?? [] {
            if ff.restnCookID == id {
                ff.isLike = isLike
            }
            jj.append(ff)
        }
        self.results = jj
    }
}
