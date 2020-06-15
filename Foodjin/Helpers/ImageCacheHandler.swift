//
//  ImageCacheHandler.swift
//  Fruitfal
//
//  Created by Archit Dhupar on 25/02/18.
//  Copyright © 2018 om kumar. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())

class ImageCacheLoader: NSObject {

    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!

    private override init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    
    static let shared = ImageCacheLoader()
//
//    private init() {
//        session = URLSession.shared
//        task = URLSessionDownloadTask()
//        self.cache = NSCache()
//    }

    func obtainImageWithPath(imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
               // debugPrint("DownLoaded Cache")
                completionHandler(image)
            }
        } else {
            /* You need placeholder image in your assets,
             if you want to display a placeholder to user */
            let placeholder = #imageLiteral(resourceName: "ProductDump")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            let url: URL! = URL(string: imagePath)
            if (url != nil) {
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                    if let data = try? Data(contentsOf: url) {
                        let img = UIImage(data: data)
                       // debugPrint("DownLoaded Once")
                        self.cache.setObject(img!, forKey: imagePath as NSString)
                        DispatchQueue.main.async {
                            completionHandler(img!)
                        }
                    }
                })
                task.resume()
            }
        }
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String, defaultImage : String?) {
        if let di = defaultImage {
            self.image = UIImage(named: di)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
