//
//  ReviewDishViewController.swift
//  Foodjin
//
//  Created by Archit Dhupar on 08/11/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class ReviewDishViewController: UIViewController, FloatRatingViewDelegate {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var commentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var additionalCommentTextView: UITextView!
    
    var allProductsReview = [[String: Any]]()
    var currentRatingIndex = 0
    
    var products: [Product]?
    
    var dismissReview:(([[String: Any]]) -> ())? = nil
    var dismissCloseButton:(() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingView.delegate = self
        setUpView(index: currentRatingIndex)
    }
    
    func  setUpView(index: Int) {
        let product = self.products?[index]
    
        dishName.text = product?.productName
        
        if let imageUrl = product?.productImage {
            let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ImageCacheLoader.shared.obtainImageWithPath(imagePath: urlString!) { [weak self] (image) in
                self?.dishImage.image = image
            }
        }
        ratingView.maxRating = 5
        ratingView.minRating = 0
        ratingView.rating = 0
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
  
    }

    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if ratingView.rating == 0 {
            showAlert(for: "Please rate the dish before proceed.")
            return
        }
        makeAgentParameters(isSkip: false)
    }
    
    @IBAction func skipButtontapped(_ sender: Any) {
        makeAgentParameters(isSkip: true)
    }
    
    private func makeAgentParameters(isSkip: Bool) {
        let product = self.products?[currentRatingIndex]
        let params = ["Rating": ratingView.rating,
                      "ProductId": product?.productID,
                      "AdditionalComments": additionalCommentTextView.text,
                      "IsLiked": true,
                      "IsSkip": isSkip,
                      "IsNotIntersted": isSkip] as [String: Any]
        
        allProductsReview.append(params)
        
        if allProductsReview.count == products?.count {
            if let dismissReview = dismissReview {
                dismissReview(allProductsReview)
            }
        } else {
            currentRatingIndex = currentRatingIndex + 1
            setUpView(index: currentRatingIndex)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
        //UserDefaults.standard.set(product!.productID, forKey: "not-toshow")
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
