//
//  TrackOrderViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 04/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MessageUI


class TrackOrderViewController: UIViewController {

    var isViewSummary:Bool = true
    var orderId:Int?
    var orderDetails: TrackOrder?

    @IBOutlet weak var orderIdentifier: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var trackOrderTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.trackOrderTableView.isHidden = true
        guard let id = self.orderId else {
            return
        }
        self.trackOrder(orderId: Int(id) ?? 0)
        
        self.trackOrderTableView.estimatedRowHeight = UITableView.automaticDimension
        //self.trackOrder(orderId: 1880)
    }
    
    func trackOrder(orderId: Int) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "ApiKey": API_KEY,
            "CustomerId": id,
            "OrderId": orderId,
            "StoreId": STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.trackOrder, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(TrackOrder.self, from: jsonData)
            //print(responseDict)
            self.orderDetails = responseDict
            
            self.settingView()
            
            self.trackOrderTableView.isHidden = false
            self.trackOrderTableView.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }

    
    func settingView() {
        guard var obj = self.orderDetails?.responseObj?[0] else { return }
        
        self.orderIdentifier.text = obj.orderNumber ?? ""
        let dateTo = DateFormatter.date(fromISO8601String: obj.orderDate ?? "")
        self.orderTime.text = dateTo?.toString(format: DateFormatType.custom(foodjinDateFormat))
        self.orderStatus.text = obj.orderStatus ?? ""
        self.orderAmount.text = STORE_CURRENCY + (obj.amount?.until(".") ?? "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewSummary(status: false)
    }
}

//Ibactions
extension TrackOrderViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension TrackOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (3 + ((self.orderDetails?.responseObj?[0].orderNotes ?? "").count > 0 ? 1 : 0))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 2) {
            if self.isViewSummary {
                return 0
            } else {
                return CGFloat(110*(self.orderDetails?.responseObj?[0].orderedItems?.count ?? 0)) + 200.0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch indexPath.row {
            
        case 0:
            guard let mainCell = Bundle.main.loadNibNamed(TrackOrderAddressTableViewCell.identifier, owner: self, options: nil)?.first as? TrackOrderAddressTableViewCell else {
                return cell
            }
            mainCell.selectionStyle = .none
            mainCell.contanningController = self
            mainCell.heading.text = "Delivery Address"
            mainCell.addressImage.image = UIImage(named: "homeIcon_AddAddress")
            mainCell.addressType.text = "Home"
            mainCell.detail.text = self.orderDetails?.responseObj?[0].billingAddress
            return mainCell
            
        case 1:
            guard let mainCell = Bundle.main.loadNibNamed(TrackOrderAddressTableViewCell.identifier, owner: self, options: nil)?.first as? TrackOrderAddressTableViewCell else {
                return cell
            }
            mainCell.selectionStyle = .none
            mainCell.contanningController = self
            mainCell.heading.text = "Restaurant Address"
            mainCell.addressImage.image = UIImage(named: "restaurantIcon")
            mainCell.addressType.text = self.orderDetails?.responseObj?[0].merchantAddressType
            mainCell.detail.text = self.orderDetails?.responseObj?[0].cooknChefAddress
            return mainCell
        case 2:
            guard let mainCell = Bundle.main.loadNibNamed(TrackOrderItemsTableViewCell.identifier, owner: self, options: nil)?.first as? TrackOrderItemsTableViewCell else {
                return cell
            }
            mainCell.selectionStyle = .none
            mainCell.contanningController = self
            mainCell.responseObject = self.orderDetails?.responseObj?[0]
            mainCell.orderedItems = self.orderDetails?.responseObj?[0].orderedItems
            return mainCell
        case 3:
            guard let mainCell = Bundle.main.loadNibNamed(OrderNotesTableViewCell.identifier, owner: self, options: nil)?.first as? OrderNotesTableViewCell else {
                return cell
            }
            mainCell.selectionStyle = .none
            mainCell.descriptionLbl.text = self.orderDetails?.responseObj?[0].orderNotes
            return mainCell
            
        default:
            return cell
        }
    }
}

extension TrackOrderViewController: TrackOrderContactUsTableViewCellCommunication, MFMailComposeViewControllerDelegate {
    func havingIssueFoodjin() {
        //print("Having Issue Chatting")
        
        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
        pVC.titleLableText = "Contact Us"
        pVC.toOpenUrl = "https://nestorbird.com/contact-us/"
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    func emailFoodjin() {
        //print("email Foodjin")
        
        if MFMailComposeViewController.canSendMail() {
            let toRecipents = ["support@foodjin.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    func callFoodjin() {
        //print("Call Foodjin")
        
        if let phoneCallURL = URL(string: "tel://\(18000040548)"), UIApplication.shared.canOpenURL(phoneCallURL)
        {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue :
            print("Cancelled")
        case MFMailComposeResult.failed.rawValue :
            print("Failed")
        case MFMailComposeResult.saved.rawValue :
            print("Saved")
        case MFMailComposeResult.sent.rawValue :
            print("Sent")
        default: break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewSummary(status: Bool?) {
        self.isViewSummary = false//status ?? false
        self.trackOrderTableView.beginUpdates()
        self.trackOrderTableView.reloadRows(at: [IndexPath(row: 0, section: 0),
                                                 IndexPath(row: 1, section: 0),
                                                 IndexPath(row: 2, section: 0)], with: .automatic)
        self.trackOrderTableView.endUpdates()
    }
}
