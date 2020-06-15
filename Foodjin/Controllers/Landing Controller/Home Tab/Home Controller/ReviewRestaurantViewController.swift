//
//  ReviewRestaurantViewController.swift
//  Foodjin
//
//  Created by Archit Dhupar on 29/10/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class ReviewRestaurantViewController: UIViewController {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var additionalComments: UITextView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var commentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentViewRest: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    var dismissRestaurantReview:(([String: Any]) -> ())? = nil
    var dismissCloseButton:(() -> Void)? = nil
    var reviewModel: MerchantReviewDetails?
    var arraySelectedOption = [Bool]()
    var isLiked = ""
    
    let unselectedOptionColor = UIColor.init(red: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
    let selectedOptionColor = primaryColor//UIColor.init(red: 255/255.0, green: 36/255.0, blue: 0/255.0, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        restaurantName.text = reviewModel?.title
        subtitleLabel.text = reviewModel?.subtitle
        
        if let imageUrl = reviewModel?.picture {
            let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ImageCacheLoader.shared.obtainImageWithPath(imagePath: urlString!) { [weak self] (image) in
                self?.restaurantImage.image = image
            }
        }
        
        commentViewRest.isHidden = true
        commentViewHeightConstraint.constant = 0
        
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        isLiked = "true"
        commentViewRest.isHidden = true
        commentViewHeightConstraint.constant = 0
        likeButton.setImage(#imageLiteral(resourceName: "likeIcon_active"), for: .normal)
        disLikeButton.setImage(#imageLiteral(resourceName: "dislikeIcon"), for: .normal)
    }
    
    @IBAction func disLikeButtonTapped(_ sender: Any) {
        if commentViewHeightConstraint.constant == 0 {
            isLiked = "false"
            likeButton.setImage(#imageLiteral(resourceName: "likeIcon"), for: .normal)
            disLikeButton.setImage(#imageLiteral(resourceName: "dislikeIcon_active"), for: .normal)
            commentViewRest.isHidden = false
            setupReviewButtons()
        }
    }
    
    private func makeAgentParameters(isSkip: Bool) {
        let liked = isLiked == "true" ? true : false
        var arrayReview = [String]()
        for (index,review) in arraySelectedOption.enumerated() where review == true {
            let reviewString = reviewModel?.reviewOptions?[index]
            if let reviewString = reviewString {
                arrayReview.append(reviewString)
            }
        }
        
        let reviewComplete = arrayReview.joined(separator:",")
        
        let params = ["Rating": 0,
                      "Reviews": reviewComplete,
                      "MerchantId": reviewModel?.merchantId,
                      "AdditionalComments": additionalComments.text,
                      "IsLiked": liked,
                      "IsSkip": isSkip,
                      "IsNotIntersted": isSkip] as [String: Any]
        
        if let dismissReview = dismissRestaurantReview {
            dismissReview(params)
        }
    }
 
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if isLiked == "" {
            showAlert(for: "Please review the restaurant before proceed.")
            return
        }
        makeAgentParameters(isSkip: false)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        makeAgentParameters(isSkip: true)
    }
    
    private func setupReviewButtons() {
        let stackSpacing: CGFloat = 10
        arraySelectedOption = [Bool]()
        let stck = UIStackView(frame: .zero)
        stck.distribution = .fillProportionally
        stck.spacing = stackSpacing
        stck.translatesAutoresizingMaskIntoConstraints = false
        commentViewRest.addSubview(stck)
        stck.leftAnchor.constraint(equalTo: commentViewRest.leftAnchor).isActive = true
        stck.topAnchor.constraint(equalTo: commentViewRest.topAnchor).isActive = true
        var stackCount = 1
        var actvStck = stck
        let buttonPadding:CGFloat = 0
        var avlSpace = commentViewRest.frame.width
        let font = UIFont.systemFont(ofSize: 18)
        if let options = reviewModel?.reviewOptions {
            for (index,text) in options.enumerated() {
                let textWidth = text.width(usingFont: font)
                if textWidth < avlSpace {
                    avlSpace = avlSpace - textWidth - stackSpacing - 2*buttonPadding
                    let newBtn = UIButton(type: .custom)
                    newBtn.setTitle(text, for: .normal)
                    newBtn.layer.cornerRadius = 8
                    newBtn.tag = index
                    newBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonPadding, bottom: 0, right: buttonPadding)
                    newBtn.addTarget(self, action: #selector(optionsSelected), for: .touchUpInside)
                    newBtn.backgroundColor = unselectedOptionColor
                    actvStck.addArrangedSubview(newBtn)
                } else {
                    stackCount = stackCount+1
                    avlSpace = commentViewRest.frame.width
                    let stck = UIStackView(frame: .zero)
                    stck.distribution = .fillProportionally
                    stck.spacing = 5
                    stck.translatesAutoresizingMaskIntoConstraints = false
                    commentViewRest.addSubview(stck)
                    stck.leftAnchor.constraint(equalTo: commentViewRest.leftAnchor).isActive = true
                    stck.topAnchor.constraint(equalTo: actvStck.bottomAnchor, constant: 2).isActive = true
                    actvStck = stck
                    avlSpace = avlSpace - textWidth
                    let newBtn = UIButton(type: .custom)
                    newBtn.setTitle(text, for: .normal)
                    newBtn.layer.cornerRadius = 8
                    newBtn.tag = index
                    newBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonPadding, bottom: 0, right: buttonPadding)
                    newBtn.addTarget(self, action: #selector(optionsSelected), for: .touchUpInside)
                    newBtn.backgroundColor = unselectedOptionColor
                    actvStck.addArrangedSubview(newBtn)
                }
                arraySelectedOption.append(false)
            }
        }
        commentViewHeightConstraint.constant = CGFloat((stackCount*40)+60)
    }
    
    @objc func optionsSelected(_ sender: UIButton) {
        if arraySelectedOption[sender.tag] {
            sender.backgroundColor = unselectedOptionColor
            arraySelectedOption[sender.tag] = false
        } else {
            sender.backgroundColor = selectedOptionColor
            arraySelectedOption[sender.tag] = true
        }
    }
 
}


//"Reviews": "string",
//"Rating": 0,
//"MerchantId": 0,
//"AdditionalComments": "string",
//"IsLiked": true,
//"IsSkip": true,
//"IsNotIntersted": true
