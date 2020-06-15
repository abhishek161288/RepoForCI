//
//  NewsDetailViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var cookLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogDesc: UITextView!
    @IBOutlet weak var commentTable: UITableView!

    //Post id
    var blogId:String?
    var detail: BlogPostsDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.cookImage.isHidden = true
        self.cookLable.isHidden = true
        self.timeLable.isHidden = true
        self.blogImage.isHidden = true
        self.blogDesc.isHidden = true
        self.commentTable.isHidden = true
        
        self.getBlogPostById()
    }
    

    func getBlogPostById() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID,
            "PostId":self.blogId ?? "31" ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.blogPostDetail, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(BlogPostsDetail.self, from: jsonData)
            //print(responseDict)
            
            self.detail = responseDict
            self.settingView()

            self.commentTable.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func settingView() {
        self.cookImage.isHidden = false
        self.cookLable.isHidden = false
        self.timeLable.isHidden = false
        self.blogImage.isHidden = false
        self.blogDesc.isHidden = false
        self.commentTable.isHidden = false
        
        self.cookImage.setImage(with: URL(string: self.detail?.responseObj?.chefImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.cookLable.text = self.detail?.responseObj?.blogTitle ?? ""
        self.timeLable.text = self.detail?.responseObj?.blogTime ?? ""
        self.blogImage.setImage(with: URL(string: self.detail?.responseObj?.blogImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        self.blogDesc.text = self.detail?.responseObj?.blogDescription ?? ""
        
        self.commentTable.reloadData()
    }
    
    
    //add comment
    func postBlogComment(comment: String) {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID,
            "PostId": Int(self.blogId ?? "0") ?? 0,
            "Comments": comment
        ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.blogPostComment, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(VerifyRegistration.self, from: jsonData)
            print(responseDict)
            self.showAlertWithTitle(title: responseDict?.errorMessageTitle ?? "", msg: responseDict?.errorMessage ?? "")
            
            //again APi hit
            self.getBlogPostById()
            
        }) { (ResponseStatus) in
            Loader.hide()
           // self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
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

extension NewsDetailViewController {
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCommentButtonAction(_ sender: Any) {
        let alertController: UIAlertController = UIAlertController(title: "Please enter your Comment", message: nil, preferredStyle: .alert)
        
        //cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //cancel code
        }
        alertController.addAction(cancelAction)
        
        //Create an optional action
        let nextAction: UIAlertAction = UIAlertAction(title: "Post", style: .default) { action -> Void in
            let text = (alertController.textFields?.first as! UITextField).text
            
            if text?.count ?? 0 > 0 {
                self.postBlogComment(comment: text ?? "")
            }

        }
        alertController.addAction(nextAction)
        
        //Add text field
        alertController.addTextField { (textField) -> Void in
        }
        //Present the AlertController
        self.present(alertController, animated: true, completion: nil)
    }
    
    //instagram
    @IBAction func instagramButtonAction(_ sender: Any) {
        print("Share Intagram")
        self.shareFunc(shareText: self.detail?.responseObj?.shareInstaLink ?? "")
    }
    
    //facebook
    @IBAction func facebookButtonAction(_ sender: Any) {
        print("Share FB")
        self.shareFunc(shareText: self.detail?.responseObj?.shareFbLink ?? "")
    }
    
    //pinterest
    @IBAction func pinterestButtonAction(_ sender: Any) {
        print("Share Pinterest")
        self.shareFunc(shareText: self.detail?.responseObj?.sharePinterstLink ?? "")
    }
    
    func shareFunc(shareText: String) {
        let someText:String = self.blogDesc.text
        let objectsToShare:UIImage = self.blogImage.image ?? UIImage()
        let sharedObjects:[Any] = [someText,objectsToShare]
        
        //let textShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
//        guard let pVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {return}
//        pVC.titleLableText = ""
//        pVC.toOpenUrl = shareText
//        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
}

extension NewsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detail?.responseObj?.blogComments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "\(self.detail?.responseObj?.blogComments?.count ?? 0) Reviews"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var height:CGFloat = 25.0
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height))
        headerView.backgroundColor = UIColor.clear
        
        //Header label
        let headerLabel = UILabel(frame: CGRect(x: 7, y: 0, width: headerView.frame.size.width - 14, height: height))
        headerLabel.textColor = UIColor.black
        headerLabel.font = UIFont.italicSystemFont(ofSize: 13.0)
        
        if self.detail?.responseObj?.blogComments?.count ?? 0 > 1 {
            headerLabel.text = "\(self.detail?.responseObj?.blogComments?.count ?? 0) Reviews"
        } else {
            headerLabel.text = "\(self.detail?.responseObj?.blogComments?.count ?? 0) Review"
        }
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(NewsDetailTableViewCell.identifier, owner: self, options: nil)?.first as? NewsDetailTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.blogComment = self.detail?.responseObj?.blogComments?[indexPath.row]
        mainCell.setCell()
        return mainCell
    }
}
