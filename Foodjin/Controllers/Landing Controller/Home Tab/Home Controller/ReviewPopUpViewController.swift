//
//  ReviewPopUpViewController.swift
//  Foodjin
//
//  Created by Archit Dhupar on 26/10/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Presentr

class ReviewPopUpViewController: UIViewController {

    var dismissReview:(([String: Any]) -> ())? = nil
    var dismissCloseButton:(() -> Void)? = nil
    var reviewModel: AgentReviewDetails?
    var isLiked = ""
    var arraySelectedOption = [Bool]()
    
    let unselectedOptionColor = UIColor.init(red: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
    let selectedOptionColor = primaryColor//UIColor.init(red: 255/255.0, green: 36/255.0, blue: 0/255.0, alpha: 1.0)
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var agentNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var additionalNotesTextView: UITextView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var disLikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentViewHeightConstraint: NSLayoutConstraint!
    
    let presenter: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .clear
        customPresenter.blurStyle = UIBlurEffect.Style.extraLight
        customPresenter.backgroundOpacity = 0.7
        customPresenter.dismissOnSwipe = true
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        agentNameLabel.text = reviewModel?.title
        subtitleLabel.text = reviewModel?.subtitle
        
        if let imageUrl = reviewModel?.picture {
            let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ImageCacheLoader.shared.obtainImageWithPath(imagePath: urlString!) { [weak self] (image) in
                self?.iconImageView.image = image
            }
        }
        commentView.isHidden = true
        commentViewHeightConstraint.constant = 0
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        isLiked = "true"
        commentView.isHidden = true
        commentViewHeightConstraint.constant = 0
        likeButton.setImage(UIImage(named: "likeIcon_active"), for: .normal)
        disLikeButton.setImage(UIImage(named: "dislikeIcon"), for: .normal)
        commentViewHeightConstraint.isActive = true
    }
    
    @IBAction func disLikeButtonTapped(_ sender: Any) {
        if commentViewHeightConstraint.constant == 0 {
            isLiked = "false"
            likeButton.setImage(UIImage(named: "likeIcon"), for: .normal)
            disLikeButton.setImage(UIImage(named: "dislikeIcon_active"), for: .normal)
            commentView.isHidden = false
            setupReviewButtons()
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        makeAgentParameters(isSkip: true)
    }
    
    private func makeAgentParameters(isSkip: Bool) {
        var arrayReview = [String]()
        for (index,review) in arraySelectedOption.enumerated() where review == true {
            let reviewString = reviewModel?.reviewOptions?[index]
            if let reviewString = reviewString {
                arrayReview.append(reviewString)
            }
        }
        
        let reviewComplete = arrayReview.joined(separator:",")
        let liked = isLiked == "true" ? true : false
        let params = ["Rating": 0,
            "Reviews": reviewComplete,
            "AgentId": reviewModel?.agentId,
            "AdditionalComments": additionalNotesTextView.text,
            "IsLiked": liked,
            "IsSkip": isSkip,
        "IsNotIntersted": isSkip] as [String: Any]
        
        if let dismissReview = dismissReview {
            dismissReview(params)
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if isLiked == "" {
            showAlert(for: "Please review the delivery before proceed.")
            return
        }
        makeAgentParameters(isSkip: false)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    private func setupReviewButtons() {
        arraySelectedOption = [Bool]()
        let stck = UIStackView(frame: .zero)
        stck.distribution = .fillProportionally
        let stackSpacing: CGFloat = 10
        stck.spacing = stackSpacing
        stck.translatesAutoresizingMaskIntoConstraints = false
        commentView.addSubview(stck)
        stck.leftAnchor.constraint(equalTo: commentView.leftAnchor).isActive = true
        stck.topAnchor.constraint(equalTo: commentView.topAnchor).isActive = true
        var stackCount = 1
        var actvStck = stck
        let buttonPadding:CGFloat = 0
        var avlSpace = commentView.frame.width
        let font = UIFont.systemFont(ofSize: 18)
        if let options = reviewModel?.reviewOptions {
            for (index,text) in options.enumerated() {
                let textWidth = text.width(usingFont: font)
                if textWidth < avlSpace {
                    avlSpace = avlSpace - textWidth - stackSpacing - (2*buttonPadding)
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
                    avlSpace = commentView.frame.width
                    let stck = UIStackView(frame: .zero)
                    stck.distribution = .fillProportionally
                    stck.spacing = 5
                    stck.translatesAutoresizingMaskIntoConstraints = false
                    commentView.addSubview(stck)
                    stck.leftAnchor.constraint(equalTo: commentView.leftAnchor).isActive = true
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


extension String {
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

//"agentReviews": {
//    "Rating": 0,
//    "Reviews": "string",
//    "AgentId": 0,
//    "AdditionalComments": "string",
//    "IsLiked": true,
//    "IsSkip": true,
//    "IsNotIntersted": true
//},
