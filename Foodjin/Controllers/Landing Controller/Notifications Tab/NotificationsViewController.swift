//
//  NotificationsViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet var notiTableView: UITableView!
    var notifications: [Notification]?
    @IBOutlet var notiLableCount: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.notiLableCount.text = ""
       
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getNotifications()
        UserDefaults.standard.set(false, forKey: "badgeval")
        let tabBarItem = self.tabBarController!.tabBar.items![3]
        tabBarItem.badgeValue = ""
        tabBarItem.badgeColor = .clear
        tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: primaryColor], for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getNotifications() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getNotifications, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(NotificationResponse.self, from: jsonData)
            //print(responseDict)
            
            self.notifications = responseDict?.responseObj
            
            self.notiLableCount.text = "You have \(self.notifications?.count ?? 0) new notifications"
            
            self.notiTableView.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
            self.notifications = []
            self.notiLableCount.text = "You have \(self.notifications?.count ?? 0) new notifications"
            self.notiTableView.reloadData()
        }
    }

}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        print("Dissmiss")
//        self.showAlert(for: "Dissmiss")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(NotificationTableViewCell.identifier, owner: self, options: nil)?.first as? NotificationTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.notification = self.notifications?[indexPath.row]
        mainCell.setUp()
        return mainCell
    }
}
