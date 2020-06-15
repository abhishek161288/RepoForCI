//
//  ProfileViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 26/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon

class ProfileViewController: UIViewController {

    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    var profileDict: Profile? = nil
    let dataArray:[[String]] = [  ["manageAddrsIcon","Manage Address"],
                                  ["orderHistory_Icon","Order History"],
                                  ["changePwd_Icon","Change Password"],
                                  ["managingCard_Icon","Manage Card"],
                                  ["helpIcon","Help"],
                                  ["logoutIcon","Logout"],
                               ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        (self.tabBarController as! LandingTabbarController).hideShowCart(show: true)
        self.getProfileData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getProfileData() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getCustomerDetails, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            
            self.profileDict = try? JSONDecoder().decode(Profile.self, from: jsonData)
//            print(self.profileDict)
            
            //settings
            self.profileImage.setImage(with: URL(string: self.profileDict?.responseObj?.profilePic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
            self.name.text = "\(self.profileDict?.responseObj?.firstName ?? "") " + "\(self.profileDict?.responseObj?.lastName ?? "")"
            self.phone.text = "\(self.profileDict?.responseObj?.mobileNo ?? "")"
            self.email.text = "\(self.profileDict?.responseObj?.email ?? "")"
            
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        
        cell.cellImage.image = UIImage(named: self.dataArray[indexPath.row][0])
        cell.cellTitle.text = self.dataArray[indexPath.row][1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ManageAddressViewController") as? ManageAddressViewController else {return}
            (self.tabBarController as! LandingTabbarController).hideShowCart(show: false)
            self.navigationController?.pushViewController(newVC, animated: true)
        case 1:
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "OrderHistoryViewController") as? OrderHistoryViewController else {return}
            (self.tabBarController as! LandingTabbarController).hideShowCart(show: false)
            self.navigationController?.pushViewController(newVC, animated: true)
        case 2:
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {return}
            (self.tabBarController as! LandingTabbarController).hideShowCart(show: false)
            self.navigationController?.pushViewController(newVC, animated: true)
        case 3:
            guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ManageCardsViewController") as? ManageCardsViewController else {return}
            (self.tabBarController as! LandingTabbarController).hideShowCart(show: false)
            self.navigationController?.pushViewController(newVC, animated: true)
        case 4:
//            guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "PolicyViewController") as? PolicyViewController else {return}
//            pVC.titleLableText = "Help"
//            self.navigationController?.pushViewController(pVC, animated: true)
            guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
            pVC.titleLableText = "Help"
            pVC.toOpenHTML = GetHelp
            (self.tabBarController as! LandingTabbarController).hideShowCart(show: false)
            self.navigationController?.pushViewController(pVC, animated: true)
        case 5:
            print("Logout From Application")
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                UserDefaults.standard.set(nil, forKey: userId)
                (self.tabBarController as? LandingTabbarController)?.logoutFromApplication()
            }
            let alertAction2 = UIAlertAction(title: "No", style: .destructive) { (action) in
            }
            alertController.addAction(alertAction)
            alertController.addAction(alertAction2)
            self.present(alertController, animated: true, completion: nil)
            
        default:
            print("None")
        }
    }
    
}

//Ib actions
extension ProfileViewController {
    @IBAction func editProfileAction(_ sender: Any) {
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {return}
        newVC.profileDict = self.profileDict
        (self.tabBarController as! LandingTabbarController).hideShowCart(show: false)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
