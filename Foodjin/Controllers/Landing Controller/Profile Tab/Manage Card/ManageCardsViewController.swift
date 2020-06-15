//
//  ManageCardsViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Stripe

class ManageCardsViewController: UIViewController {

    @IBOutlet weak var cardTableLable: UILabel!
    @IBOutlet weak var cardTable: UITableView!
    
    var cards: [Card]?
    var orderIdForPayment: Int?
    var paymentMethodId: Int?
    var tabBarCtrl:LandingTabbarController?
    
    @IBOutlet weak var cardTableHeight: NSLayoutConstraint!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cardTableHeight.constant = 0
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
            
            self.cardTableHeight.constant = CGFloat((self.cards?.count ?? 0)*110)
            
            if self.cardTableHeight.constant > 330 {
                self.cardTableHeight.constant = 330
            }
            
            if self.cards?.count ?? 0 > 0 {
                self.cardTableLable.text = "Saved Cards"
            } else {
                self.cardTableLable.text = "No Saved Cards"
            }
            
        }) { (ResponseStatus) in
            Loader.hide()
            
            self.cards = []
            self.cardTable.reloadData()
            
           // self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func deleteCardApi(cardId : String) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "CardId":cardId ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.deleteCard, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()

            self.getCardsApi()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }

}

//Ibactions
extension ManageCardsViewController: STPAddCardViewControllerDelegate {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewCardButtonAction(_ sender: Any) {
        //Custom Card Generator
        // Setup add card view controller
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//
//        // Present add card view controller
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        present(navigationController, animated: true)
        customUIForAddCard()
    }
    
    func  customUIForAddCard()  {
        if let addCard = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController {
            addCard.sendTokenToBackend = { token in
                if let tokenIn = token {
                    self.addNewCard(token: tokenIn)
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            addCard.modalPresentationStyle = .fullScreen
            present(addCard, animated: true, completion: nil)
        }
        
        
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func submitTokenToBackend(token: STPToken, completion: (_ error:Error)->()){
        print("doing this")
        self.addNewCard(token: token.tokenId)
    }
    
    func addNewCard(token: String) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "CardToken":token,
            "StoreId": STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.addNewCard, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            self.paymentConfirmation(token: token, isNew: true, cardId: "")
            let status = try? JSONDecoder().decode(ResponseStatus.self, from: jsonData)
            
            self.dismiss(animated: true)
            //self.showAlertWithTitle(title: status?.errorMessageTitle ?? "", msg: status?.errorMessage ?? "")

        }) { (ResponseStatus) in
            Loader.hide()
            self.dismiss(animated: true)
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
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
    
    func paymentConfirmation(token: String, isNew: Bool, cardId: String) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        guard let orderId = orderIdForPayment else {self.getCardsApi(); return}
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "PaymentToken":token,
            "OrderId": orderId ,
            "PaymentMethodId": self.paymentMethodId ?? 0,
            "IsNew": isNew,
            "CardId": cardId]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.checkoutPayment, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
//            do {
//                let responseDict = try JSONDecoder().decode(PaymentCheckout.self, from: jsonData)
//                debugPrint(responseDict)
//            } catch let error {
//                debugPrint(error)
//            }
            let response = try? JSONDecoder().decode(PaymentCheckout.self, from: jsonData)
            self.dismiss(animated: true)
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearCart"), object: nil)
//
//            if let vcs = self.navigationController?.viewControllers {
//                let countVC = vcs.count - 4
//                self.navigationController?.popToViewController(vcs[countVC], animated: true)
//            }
            (self.tabBarCtrl)?.presentThanyouPopUp(value: response?.responseObj, oderId: self.orderIdForPayment ?? 0)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setRootViewController()
            

        }) { (ResponseStatus) in
            Loader.hide()
            self.dismiss(animated: true)
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
}


extension ManageCardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        paymentConfirmation(token: "", isNew: false, cardId: self.cards?[indexPath.row].id ?? "0")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(CardTableViewCell.identifier, owner: self, options: nil)?.first as? CardTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.cardInfo = self.cards?[indexPath.row]
        mainCell.setCell()
        mainCell.delegate = self
        return mainCell
    }
}

extension ManageCardsViewController : CardTableViewCellCommunication {
    func touchDeleteButton(onaddress: Card) {
//        print("delete card Api")
        
        let alertController = UIAlertController(title: "Alert", message: "Do you want to Delete this Card?", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteCardApi(cardId: onaddress.id ?? "0")
        }
        let alertAction2 = UIAlertAction(title: "No", style: .destructive) { (action) in
        }
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
        self.appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
