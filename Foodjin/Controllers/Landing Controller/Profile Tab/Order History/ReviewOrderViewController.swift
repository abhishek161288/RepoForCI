//
//  ReviewOrderViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 09/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import MapleBacon
import UnderLineTextField

protocol ReviewOrderViewControllerCommunication: class {
    func refreshOrderHistory()
}

class ReviewOrderViewController: UIViewController {

    weak var delegate: ReviewOrderViewControllerCommunication?

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var commentWordCount: UILabel!
    
    var productIndex: Int = 0
    var orderDetails: OrderReviewData?
    var reviewArray:[[String:Any]]?
    var currentItem:[[String:Any]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.rating.delegate = self
        self.comments.delegate = self
        
        self.collectionView.register(UINib(nibName: ReviewOrderCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ReviewOrderCollectionViewCell.identifier)

        self.reviewArray = []
        for i in self.orderDetails?.responseObj?[0].products ?? [] {
            var item:[String: Any] = [ "ProductId": i.productID ?? 0,
                                       "ReviewItemAttributes": [["Name":"","IsLiked":false],["Name":"","IsLiked":false],["Name":"","IsLiked":false],["Name":"","IsLiked":false],["Name":"","IsLiked":false],["Name":"","IsLiked":false]],
                                       "Rating":0.0,
                                       "Comments":""]
            self.reviewArray?.append(item)
        }
        
        //print(self.reviewArray)
        self.configureReviewViewForIndex(index: self.productIndex)
    }
    
    func configureReviewViewForIndex(index: Int) {
        //Setting Review Order
        self.productImage.setImage(with: URL(string: self.orderDetails?.responseObj?[0].products?[index].productImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.productLable.text = self.orderDetails?.responseObj?[0].products?[index].productName ?? ""
        
        self.rating.rating = self.reviewArray?[self.productIndex]["Rating"] as! Double
        var ijskd = self.reviewArray?[self.productIndex]
        self.currentItem = ijskd?["ReviewItemAttributes"] as? [[String : Any]]
        self.comments.text = self.reviewArray?[self.productIndex]["Comments"] as? String
        
        //print(self.currentItem)
        
        self.collectionView.reloadData()
    }
    
    
    //Post Review Order
    func reviewOrderDetailsApi(withReviews: [[String:Any]]?, completionHandler:@escaping ()->()) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        guard let orderId = self.orderDetails?.responseObj?[0].orderID else { return }

        
        let params = [
            "CustomerId": id,
            "ApiKey": API_KEY,
            "OrderId": orderId,
            "StoreId": STORE_ID,
            "ReviewItems": self.reviewArray ?? [] ]

        Loader.show(animated: true)

        WebServiceManager.instance.post(url: Urls.postOrderReview, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(ResetPassword.self, from: jsonData)
            print(responseDict)

            self.delegate?.refreshOrderHistory()
            
            completionHandler()
            //self.navigationController?.popViewController(animated: true)
//            self.navigationController?.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")


        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//    }
}


//Ib Actions
extension ReviewOrderViewController {
    @IBAction func crossButtonAction(_ sender: Any) {
        self.reviewOrderDetailsApi(withReviews: self.reviewArray, completionHandler: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func prevButtonAction(_ sender: Any) {
        self.productIndex = self.productIndex-1
        if self.productIndex < 0 {
            self.productIndex = 0
            //refresh view
        } else {
            //refresh view
        }
        self.configureReviewViewForIndex(index: self.productIndex)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        self.productIndex = self.productIndex+1
        if self.productIndex >= self.orderDetails?.responseObj?[0].products?.count ?? 0 {
            self.productIndex = (self.orderDetails?.responseObj?[0].products?.count ?? 0)-1
            //refresh view
        } else {
            //refresh view
        }
        self.configureReviewViewForIndex(index: self.productIndex)
    }
}

extension ReviewOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.delegate?.touchOnHoriZontalCell(onCellNumber: self.superviewIndex ?? 0, indexNumber: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let returnCell = UICollectionViewCell()
        
        guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewOrderCollectionViewCell.identifier, for: indexPath) as? ReviewOrderCollectionViewCell
            else { return returnCell }
        reportsCell.delegate = self
        reportsCell.index = indexPath.row
        reportsCell.likeButton.setImage(UIImage(named: "likeIcon"), for: .normal)
        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon"), for: .normal)
        
        switch indexPath.row {
        case 0:
            reportsCell.image.image = UIImage(named: "foodTaste_Icon")
            reportsCell.lable.text = "Food Taste"
            
            for i in self.currentItem ?? [] {
                if ((i["Name"] as? String) == "Food Taste") {
                    if (i["IsLiked"] as! Bool) {
                        reportsCell.likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
                    } else {
                        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
                    }
                }
            }
        case 1:
            reportsCell.image.image = UIImage(named: "foodHygiene_Icon")
            reportsCell.lable.text = "Food Hygiene"
            
            for i in self.currentItem ?? [] {
                if ((i["Name"] as? String) == "Food Hygiene") {
                    if (i["IsLiked"] as! Bool) {
                        reportsCell.likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
                    } else {
                        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
                    }
                }
            }
        case 2:
            reportsCell.image.image = UIImage(named: "awesomePresentation_Icon")
            reportsCell.lable.text = "Awesome Presentation"
            
            for i in self.currentItem ?? [] {
                if ((i["Name"] as? String) == "Awesome Presentation") {
                    if (i["IsLiked"] as! Bool) {
                        reportsCell.likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
                    } else {
                        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
                    }
                }
            }
        case 3:
            reportsCell.image.image = UIImage(named: "foodService_Icon")
            reportsCell.lable.text = "Food Service"
            
            for i in self.currentItem ?? [] {
                if ((i["Name"] as? String) == "Food Service") {
                    if (i["IsLiked"] as! Bool) {
                        reportsCell.likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
                    } else {
                        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
                    }
                }
            }
        case 4:
            reportsCell.image.image = UIImage(named: "expertDiet_Icon")
            reportsCell.lable.text = "Expert Diet"
            
            for i in self.currentItem ?? [] {
                if ((i["Name"] as? String) == "Expert Diet") {
                    if (i["IsLiked"] as! Bool) {
                        reportsCell.likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
                    } else {
                        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
                    }
                }
            }
        case 5:
            reportsCell.image.image = UIImage(named: "lateNightSaver_Icon")
            reportsCell.lable.text = "Late Night Saver"
            
            for i in self.currentItem ?? [] {
                if ((i["Name"] as? String) == "Late Night Saver") {
                    if (i["IsLiked"] as! Bool) {
                        reportsCell.likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
                    } else {
                        reportsCell.dislikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
                    }
                }
            }
        default:
            reportsCell.image.image = UIImage(named: "")
            reportsCell.lable.text = ""
        }
        return reportsCell
    }
}

extension ReviewOrderViewController: FloatRatingViewDelegate,UITextViewDelegate,ReviewOrderCollectionViewCellCommunication {
    func clickOnLikeDislikeOnAttribute(isLike: Bool, atribute: String, atIndex: Int) {
        print(isLike)
        print(atribute)
        
        for var item in self.reviewArray ?? [] {
            if item["ProductId"] as? Int == self.orderDetails?.responseObj?[0].products?[self.productIndex].productID ?? 0 {
                
                let newAtribute = ["Name":atribute, "IsLiked":isLike] as [String : Any]
                
                var arra:[[String:Any]] = item["ReviewItemAttributes"] as! [[String : Any]]
                arra[atIndex] = newAtribute
                
                item["ReviewItemAttributes"] = arra
                
                self.reviewArray?[self.productIndex] = item
            }
        }
        
        //print(self.reviewArray)
        var ijskd = self.reviewArray?[self.productIndex]
        self.currentItem = ijskd?["ReviewItemAttributes"] as? [[String : Any]]
        self.collectionView.reloadItems(at: [IndexPath(row: atIndex, section: 0)])
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        //print(rating)
        
        //get the product id
        for var item in self.reviewArray ?? [] {
            if item["ProductId"] as? Int == self.orderDetails?.responseObj?[0].products?[self.productIndex].productID ?? 0 {
                item["Rating"] = rating
                
                self.reviewArray?[self.productIndex] = item
            }
        }
        
        //print(self.reviewArray)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        print(textView.text)
        
        for var item in self.reviewArray ?? [] {
            if item["ProductId"] as? Int == self.orderDetails?.responseObj?[0].products?[self.productIndex].productID ?? 0 {
                item["Comments"] = textView.text ?? ""
                
                self.reviewArray?[self.productIndex] = item
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.commentWordCount.text = "\(numberOfChars)/300"
        return numberOfChars < 300;
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

