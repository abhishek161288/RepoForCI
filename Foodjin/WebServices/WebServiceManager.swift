//
//  WebServiceManager.swift
//  Foodjin
//
//  Created by Navpreet Singh on 18/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class WebServiceManager: NSObject {

    // instance for Singleton class
    static let instance = WebServiceManager()
    let header: HTTPHeaders = ["Content-type": "application/json; charset=UTF-8"]
    
    //Get Method
//    func get(url: String, successCompletionHandler: @escaping (Data) -> Void, failureCompletionHandler: @escaping (ResponseStatus) -> Void) {
//        AF.request(url).response { (jsonData) in
//            guard let data = jsonData.data else { return }
//            let status = try? JSONDecoder().decode(ResponseStatus.self, from: data)
//            //    print(status?.statusCode)
//            //    print(status?.errorMessage)
//            //    print(status?.errorMessageTitle)
//
//            if (status?.statusCode == 200) {
//                successCompletionHandler(data)
//            } else {
//                guard let sst = status else { return }
//                failureCompletionHandler(sst)
//            }
//
//            #if DEBUG
//            self.printJson(data: data)
//            #endif
//        }
//    }

    //Post Method
    func post(url: String, params: Parameters, successCompletionHandler: @escaping (Data) -> Void, failureCompletionHandler: @escaping (ResponseStatus) -> Void) {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        } else {
            print("No! internet is available.")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate


            let alert = UIAlertController(title: "Network Failure", message: "You are not connected to the internet", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default) { (_) in
            }
            alert.addAction(action1)
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)

            Loader.hide()
            return
        }
        
        #if DEBUG
        print(params)
        #endif
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.header, interceptor: nil).response { (jsonData) in
                guard let data = jsonData.data else { return }
                let status = try? JSONDecoder().decode(ResponseStatus.self, from: data)
                print(status?.statusCode)
//                print(status?.errorMessage)
//                print(status?.errorMessageTitle)

            if (status?.statusCode == 200) {
                successCompletionHandler(data)
            } else {
                guard let sst = status else { return }
                failureCompletionHandler(sst)
            }
                        
            #if DEBUG
            self.printJson(data: data)
            #endif
            
        }
    }
    
    //Post with image Method
//    func postWithImage(url: String,params: Parameters,image: UIImage? ,successCompletionHandler: @escaping (Data) -> Void, failureCompletionHandler: @escaping (ResponseStatus) -> Void) {
//
////        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.header, interceptor: nil).response { (jsonData) in
////            guard let data = jsonData.data else { return }
////            let status = try? JSONDecoder().decode(ResponseStatus.self, from: data)
////            print(status)
////        }
//
////        let formData = MultipartFormData(fileManager: .default, boundary: "====xxx=====custom-test-boundary======xxx=====")
////        formData.append(image?.pngData() ?? Data(), withName: "ProfilePic")
////        for (key, val) in params {
////            formData.append(Data(base64Encoded: val as? String ?? "") ?? Data(), withName: key)
////        }
//
//        AF.upload(multipartFormData: { (multiPart) in
//            for (key, value) in params {
//                if let temp = value as? String {
//                    multiPart.append(temp.data(using: .utf8)!, withName: key)
//                }
//            }
//            multiPart.append(image?.pngData() ?? Data(), withName: "ProfilePic")
//
//        }, usingThreshold: UInt64.init(),
//           fileManager: .default,
//           to: url, method: .post,
//           headers: self.header,
//           interceptor: nil).response { (jsonData) in
//            guard let data = jsonData.data else { return }
//            let status = try? JSONDecoder().decode(ResponseStatus.self, from: data)
//
//            if (status?.statusCode == 200) {
//                successCompletionHandler(data)
//            } else {
//                guard let sst = status else { return }
//                failureCompletionHandler(sst)
//            }
//        }
//
//    }


}

extension WebServiceManager {
    func printJson(data: Data) {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:AnyObject]
            {
                debugPrint(jsonArray)
            } else {
                debugPrint("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
