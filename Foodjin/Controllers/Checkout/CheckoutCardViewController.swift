//
//  CheckoutCardViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 07/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class CheckoutCardViewController: UIViewController {

    @IBOutlet weak var cardTable: UITableView!
    var cards: [Card]?
    //@IBOutlet weak var cardTableHeight: NSLayoutConstraint!
    var chkOutResponse: CheckoutResponseObj?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.chkOutResponse)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getCardsApi()
    }
    
    func getCardsApi() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getCards, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let response = try? JSONDecoder().decode(AllCardResponse.self, from: jsonData)
            print(response)
            
            self.cards = response?.responseObj
            self.cardTable.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            
            self.cards = []
            self.cardTable.reloadData()
            
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
}

extension CheckoutCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(CheckoutCardTableViewCell.identifier, owner: self, options: nil)?.first as? CheckoutCardTableViewCell else {
            return cell
        }
        
        mainCell.selectionStyle = .none
        mainCell.cardInfo = self.cards?[indexPath.row]
        mainCell.delegate = self
        mainCell.setCell()
        return mainCell
    }
}


extension CheckoutCardViewController: CheckoutCardTableViewCellCommunication {
    func addedCvv(onCard: Card?, cvv: String) {
        print(onCard)
        print(cvv)
    }
}
