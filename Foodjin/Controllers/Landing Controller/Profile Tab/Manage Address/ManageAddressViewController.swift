//
//  ManageAddressViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 28/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import GoogleMaps


protocol ManageAddressViewControllerCommunication: class {
    func addressPicked(address: AddressArray?)
}

class ManageAddressViewController: UIViewController {

    weak var delegate: ManageAddressViewControllerCommunication?

    @IBOutlet weak var addresTable: UITableView!
    @IBOutlet weak var addressLable: UILabel!
    var addressArray: [AddressArray]?
    @IBOutlet weak var textField: MVPlaceSearchTextField!

    var isToPick: Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.textField.placeSearchDelegate                 = self;
        self.textField.strApiKey                           = "AIzaSyDwhX90LbY7RdQ1yGT7WvI0IQ_J2na-5gg";
        self.textField.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
        self.textField.autoCompleteShouldHideOnSelection   = true;
        self.textField.maximumNumberOfAutoCompleteRows     = 5;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getAddressData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getAddressData() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.getAddress, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(AddressResponse.self, from: jsonData)
//            print(responseDict)
            
            self.addressArray = responseDict?.responseObj
            self.addresTable.reloadData()
            self.addressLable.text = "Saved Addresses"
            
        }) { (ResponseStatus) in
            Loader.hide()
//            self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
            self.addressLable.text = ResponseStatus.errorMessage ?? ""
            
            self.addressArray = nil
            self.addresTable.reloadData()
        }
    }

}

extension ManageAddressViewController: PlaceSearchTextFieldDelegate,UITextFieldDelegate {
    
    func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
        self.view.endEditing(true)
        print("SELECTED ADDRESS : \(responseDict)")
        
        var line1 = ""
        var line2 = ""
        var country = ""
        var city = ""
        var zipCode = ""

        for addressComponent in (responseDict.addressComponents)! {
            for type in (addressComponent.types){
                
                switch(type){
                    
                case "sublocality_level_1":
                    line1 = addressComponent.name
                    
                case "locality":
                    line2 = addressComponent.name

                case "political":
                    city = addressComponent.name
                    
                case "country":
                    country = addressComponent.name
                    
                case "city":
                    city = addressComponent.name
                    
                case "postal_code":
                    zipCode = addressComponent.name
                    
                default:
                    break
                }
            }
        }
        
        let address = AddressArray(id: 0, label: "Other",
                                   addressLine1: line1,
                                   addressLine2: line2+","+country,
                                   zipCode: zipCode,
                                   city: city,
                                   latPos: responseDict.coordinate.latitude,
                                   longPos: responseDict.coordinate.longitude)
        self.addAddressFromCurrentLoction(onaddress: address)
    }
    
    func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
    }
    
    func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
    }
    
    func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
    }
}

//Ibactions
extension ManageAddressViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func useCurrentLocationButtonAction(_ sender: Any) {
        Loader.show(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let lat = CLLocationDegrees(Double(appDelegate.latitudeLabel ?? "0.0") ?? 0.0)
        let long = CLLocationDegrees(Double(appDelegate.longitudeLabel ?? "0.0") ?? 0.0)
        let cordinates = CLLocationCoordinate2DMake(lat, long)
        GMSGeocoder().reverseGeocodeCoordinate(cordinates) { (res, err) in
//            print(res?.results())
            Loader.hide()
            
            if res?.results()?.count ?? 0 > 0 {
                for address in res?.results() ?? [] {
                    let address = AddressArray(id: 0, label: "Home", addressLine1: address.lines?.joined(separator: ","), addressLine2: address.locality, zipCode: address.postalCode, city: address.administrativeArea, latPos: address.coordinate.latitude, longPos: address.coordinate.longitude)
                    self.addAddressFromCurrentLoction(onaddress: address)
                    break
                }
            } else {
                self.showAlertWithTitle(title: "Error", msg: "Unable to get your location!")
            }
            
        }
    }
    
    @IBAction func addNewAddressButtonAction(_ sender: Any) {
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}


extension ManageAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if self.isToPick == true {
            let address = self.addressArray?[indexPath.row]
            self.delegate?.addressPicked(address: address)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(AddressTableViewCell.identifier, owner: self, options: nil)?.first as? AddressTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.address = self.addressArray?[indexPath.row]
        mainCell.delegate = self
        mainCell.setCell()
        return mainCell
    }
}


extension ManageAddressViewController: AddressTableViewCellCommunication {
    
    func addAddressFromCurrentLoction(onaddress: AddressArray) {
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        newVC.address = onaddress
        newVC.isFromAddLocationButton = true
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func touchEditButton(onaddress: AddressArray) {
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        newVC.address = onaddress
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func touchDeleteButton(onaddress: AddressArray) {
        //delete Api
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustId":id,
            "ApiKey":API_KEY,
            "AddressId":"\(onaddress.id ?? 0)" ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.deleteAddress, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(AddressResponse.self, from: jsonData)
            //print(responseDict)
            
            //self.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
            
            self.getAddressData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
            self.addressLable.text = ResponseStatus.errorMessage ?? ""
            
            self.getAddressData()
        }
    }
}
