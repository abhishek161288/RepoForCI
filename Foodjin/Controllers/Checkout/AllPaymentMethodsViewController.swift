//
//  AllPaymentMethodsViewController.swift
//  Foodjin
//
//  Created by Archit Dhupar on 07/11/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Stripe

class AllPaymentMethodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STPAddCardViewControllerDelegate {
    
    var selectedIndex: Int? = nil
    var paymentMethods: [AllPaymentMethodsResponseObj]?
    
    var orderIdForPayment: Int?
    var tabBarCtrl:LandingTabbarController?
    var paymentMethodId:Int?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllPaymentMethods()
        getCardsApi()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    func getAllPaymentMethods() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        let params = [
            "CustomerId": id,
            "StoreId": STORE_ID,
            "ApiKey": API_KEY ]
        
        debugPrint(params)
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getAllPaymentMethods, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            let responseDict = try? JSONDecoder().decode(AllPaymentMethods.self, from: jsonData)
            self.paymentMethods = responseDict?.responseObj?.filter{ $0.isShow == true}
            if self.paymentMethods != nil {
                self.tableView.reloadData()
            }
            
            //self.addToCartResponse?.clear(forKey: "SavedCart")
            //(self.tabBarController as? LandingTabbarController)?.clear()
            
            // Till here
            
        }) { (ResponseStatus) in
            Loader.hide()
            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.paymentMethods?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPaymentMethodTypeTableViewCell") as! AllPaymentMethodTypeTableViewCell
        cell.selectionStyle = .none
        if selectedIndex != nil && selectedIndex == section {
            cell.selectedCellIndicator.image = #imageLiteral(resourceName: "TickCheck")
        } else {
            cell.selectedCellIndicator.image = #imageLiteral(resourceName: "UnselectedRadio")
        }
        cell.index = section
        cell.clickedHeader = { index in
            self.selectedIndex = index
            self.paymentMethodId = self.paymentMethods![index].paymentMethodId
            self.tableView.reloadData()
        }
        cell.paymentMethodLabel.text = self.paymentMethods?[section].paymentMethodName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.paymentMethods![section].paymentMethodId == 3 && selectedIndex == section {
            return cards.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == cards.count {
//            let addCardViewController = STPAddCardViewController()
//            addCardViewController.delegate = self
//
//            // Present add card view controller
//            let navigationController = UINavigationController(rootViewController: addCardViewController)
//            present(navigationController, animated: true)
            cards = cards.map({ (card) -> Card in
                var cardNew = card
                cardNew.isSelected = false
                return cardNew
            })
            self.tableView.reloadData()
            customUIForAddCard()
            
        }
        else {
            cards = cards.map({ (card) -> Card in
                var cardNew = card
                 cardNew.isSelected = false
                return cardNew
            })
            cards[indexPath.row].isSelected = true
            self.tableView.reloadData()
        }
        //        selectedIndex = indexPath.row
        //        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cards.count {
            return 44
        }
        return 92
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        if indexPath.row == cards.count {
            let addCardCell = tableView.dequeueReusableCell(withIdentifier: "addcardCell")
            return addCardCell ?? cell
        }
        
        
        guard let mainCell = Bundle.main.loadNibNamed(CardTableViewCell.identifier, owner: self, options: nil)?.first as? CardTableViewCell else {
            return cell
        }
        mainCell.deleteButton.isHidden = true
        mainCell.selectionStyle = .none
        mainCell.accessoryType = self.cards[indexPath.row].isSelected ? .checkmark : .none
        mainCell.cardInfo = self.cards[indexPath.row]
        mainCell.setCell()
        //mainCell.delegate = self
        return mainCell
    }
    
    var cards: [Card] = []
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
            
            self.cards = response?.responseObj ?? []
            self.tableView.reloadData()
            
            
        }) { (ResponseStatus) in
            Loader.hide()
            
            self.cards = []
            self.tableView.reloadData()
            
            // self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func payButtonPressed(_ sender: Any) {
        if selectedIndex == nil {
            self.showAlert(for: "Please select a payment method.")
            return
        }
        if selectedIndex == 0 {
            if let id = self.paymentMethods?[selectedIndex!].paymentMethodId {
                paymentConfirmation(token: "", paymentMethodId: id)
            }
            //self.navigationController?.popViewController(animated: true)
        } else {
            if let card = cards.filter({$0.isSelected}).first {
                self.paymentConfirmation(token: "", isNew: false, cardId: card.id!)
            }
        }
    }
}

extension AllPaymentMethodsViewController {
    
    func paymentConfirmation(token: String, paymentMethodId: Int) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "PaymentToken":token,
            "OrderId": self.orderIdForPayment ?? 0 ,
            "PaymentMethodId": paymentMethodId,
            "IsNew": true,
            "CardId": ""]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.checkoutPayment, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            do {
                let responseDict = try JSONDecoder().decode(PaymentCheckout.self, from: jsonData)
                debugPrint(responseDict)
            } catch let error {
                debugPrint(error)
            }
            let response = try? JSONDecoder().decode(PaymentCheckout.self, from: jsonData)
            self.dismiss(animated: true)
            
            //alterCart
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearCart"), object: nil)
            
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


class AllPaymentMethodTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedCellIndicator: UIImageView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    var index: Int!
    var clickedHeader:((_ index: Int) -> Void)?
    
    @IBAction func cellClicked(sender:UIButton) {
        clickedHeader?(index)
    }
}
