//
//  WebViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 20/07/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var titleLableText: String?
    var toOpenUrl:String?
    var toOpenHTML:String?
    
//    override func loadView() {
//        self.webView.navigationDelegate = self
//        view = self.webView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loader.show(animated: true)

        // Do any additional setup after loading the view.
        self.heading.text = self.titleLableText ?? ""
        
        self.webView.navigationDelegate = self
        
        
        guard let urlString = self.toOpenUrl else {
            guard let html = toOpenHTML else {
                let url = URL(string: "https://nestorbird.com/contact-us/")!
                self.webView.load(URLRequest(url: url))
                self.webView.allowsBackForwardNavigationGestures = true
                return
            }
            self.webView.loadHTMLString(html, baseURL: nil)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        self.webView.load(URLRequest(url: url))
        self.webView.allowsBackForwardNavigationGestures = true

    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()
    }
}
