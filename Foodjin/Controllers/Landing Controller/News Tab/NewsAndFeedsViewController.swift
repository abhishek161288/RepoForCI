//
//  NewsAndFeedsViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 31/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class NewsAndFeedsViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    var posts: [BlogPost]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getBlogPosts()
    }

    func getBlogPosts() {
        guard let id = UserDefaults.standard.object(forKey: userId) else { return }
        
        let params = [
            "CustomerId":id,
            "ApiKey":API_KEY,
            "StoreId":STORE_ID ]
        
        Loader.show(animated: true)
        
        WebServiceManager.instance.post(url: Urls.blogPosts, params: params, successCompletionHandler: { [unowned self] (jsonData) in
            Loader.hide()
            let responseDict = try? JSONDecoder().decode(BlogPosts.self, from: jsonData)
            print(responseDict)
            
            self.posts = responseDict?.responseObj
            self.newsTable.reloadData()
            
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
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

extension NewsAndFeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {return}
        newVC.blogId = "\(self.posts?[indexPath.row].blogID ?? 0)"
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/2.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        guard let mainCell = Bundle.main.loadNibNamed(NewsTableViewCell.identifier, owner: self, options: nil)?.first as? NewsTableViewCell else {
            return cell
        }
        mainCell.selectionStyle = .none
        mainCell.post = self.posts?[indexPath.row]
        mainCell.setCell()
        return mainCell
    }
}
