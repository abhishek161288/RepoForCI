//
//  AppDelegate.swift
//  Foodjin
//
//  Created by Navpreet Singh on 18/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Default
import CoreLocation
import Stripe
import GoogleMaps
import GooglePlaces
import Reachability
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var latitudeTakeAwayLabel: String?
    var longitudeTakeAwayLabel: String?

    var latitudeDeliveryLabel: String?
    var longitudeDeliveryLabel: String?
    
    var latitudeLabel: String?
    var longitudeLabel: String?
    
    var tabbarController: LandingTabbarController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        self.checkReachabelity()
        
        // Landing page is visible once the Version Apis is downloaded from Server
        initWebservices()
        
        let newVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LoadVideoViewController") as? LoadVideoViewController
        self.window?.rootViewController = newVC
        
        //        self.getLocation { (value) in
        //            if value {
        //                self.window?.isHidden = false
        //                self.setRootViewController()
        //            }
        //        }
        
        IQKeyboardManager.shared.enable = true
        // Stripe Configuration
        //My Stripe
        //Stripe.setDefaultPublishableKey("pk_test_qSzbQXjvo561SjhgBnNg7LP8008FukpFru")
        
        //Client Stripe
        Stripe.setDefaultPublishableKey("pk_test_xDQClDU90r3JRShxWSD8N0Q9")
        
        //        GMSServices.provideAPIKey("AIzaSyAXmMR2KX0tOlv2-MohzMOfOfq8lx3KHAU")
        //        GMSPlacesClient.provideAPIKey("AIzaSyAXmMR2KX0tOlv2-MohzMOfOfq8lx3KHAU")
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDwhX90LbY7RdQ1yGT7WvI0IQ_J2na-5gg")
        GMSPlacesClient.provideAPIKey("AIzaSyDwhX90LbY7RdQ1yGT7WvI0IQ_J2na-5gg")
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    self.registerPush()
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        registerPush()
        return true
    }
    
    func registerPush()  {
        
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func setRootViewController() {
        
        guard let naviVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "MainRootNavigationController") as? MainRootNavigationController else { return }
        
        if UserDefaults.standard.object(forKey: userId) != nil {
            //if login
            guard let loginVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            
            guard let landingVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LandingTabbarController") as? LandingTabbarController else {return}
            landingVC.selectedIndex = 1
            self.tabbarController = landingVC
            
            naviVC.viewControllers = [loginVC, landingVC]

            self.window?.rootViewController = naviVC
        } else {
            //if Not login
            guard let loginVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            
            naviVC.viewControllers = [loginVC]
            self.window?.rootViewController = naviVC
        }
    }
    
    func getLocation(completionHandler: @escaping (Bool)->Void) {
        LocationManager.sharedInstance.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                let alertController = UIAlertController(title: "Error!", message: "Please enable location from the Settings.", preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    exit(0)
                })
                alertController.addAction(alertAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                return
            }
            guard let _ = location else {
                return
            }
            
            self.latitudeTakeAwayLabel = "\((location?.coordinate.latitude)!)"
            self.longitudeTakeAwayLabel = "\((location?.coordinate.longitude)!)"
            
            self.latitudeDeliveryLabel = "\((location?.coordinate.latitude)!)"
            self.longitudeDeliveryLabel = "\((location?.coordinate.longitude)!)"
            
            self.latitudeLabel = "\((location?.coordinate.latitude)!)"
            self.longitudeLabel = "\((location?.coordinate.longitude)!)"
            
            //Custom
            #if DEBUG
//            self.latitudeTakeAwayLabel = "-37.787003"
//            self.longitudeTakeAwayLabel = "175.279251"
//            
//            self.latitudeDeliveryLabel = "-37.787003"
//            self.longitudeDeliveryLabel = "175.279251"
//            
//            self.latitudeLabel = "-37.787003"
//            self.longitudeLabel = "175.279251"
            #endif
            
            completionHandler(true)
        }
    }
    
    func checkReachabelity() {
        do {
            let reachability = try Reachability()
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
        catch {
            
        }
        
        
    }
    
    func getTabbarController() -> LandingTabbarController? {
        if let tabbar = self.tabbarController {
            return tabbar
        } else {
            return nil
        }
    }

    func initWebservices() {
        Loader.show(animated: true)
        #if ECUADOOR
        let params = ["PublicKeyAuth":"4ED0BC8A-238F-4A90-BCEF-C76BEB9735D8",
                      "DeviceOStype":"I",
                      "APKVersion":"1.0.0",
                      "StoreId": "0",
                      "AppName":"ECUADOR_CUSTOMER"]
        #else
        let params = ["PublicKeyAuth":"4ED0BC8A-238F-4A90-BCEF-C76BEB9735D8",
                      "DeviceOStype":"I",
                      "APKVersion":"1.0.0",
                      "StoreId": "0",
                      "AppName":"easyeats_CUSTOMER"]
        #endif
        
        WebServiceManager.instance.post(url: Urls.version, params: params, successCompletionHandler: { (jsonData) in
            Loader.hide()
            
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            let version = try? JSONDecoder().decode(Version.self, from: jsonData)
            print(version)
            
            API_KEY = version?.ApiKey ?? ""
            STORE_ID = String(version?.StoreID ?? 0)
            STORE_CURRENCY = version?.StoreCurrency ?? ""
            GetHelp = version?.GetHelp ?? ""
            SupportChatUrl = version?.SupportChatUrl ?? ""
            Privacy = version?.Privacy ?? ""
            TermsCondition = version?.TermsCondition ?? ""
            
            
            // 2: Write
            //            UserDefaults.standard.set(version?.apiKey, forKey: API_KEY)
            //            UserDefaults.standard.set(version?.storeID, forKey: STORE_ID)
            //            UserDefaults.standard.set(version?.storeCurrency, forKey: Store_Currency)
        }) { (ResponseStatus) in
            Loader.hide()
            //self.showAlertWithTitle(title: ResponseStatus.errorMessageTitle ?? "", msg: ResponseStatus.errorMessage ?? "")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
       handlePush(userInfoIn: notification.request.content.userInfo)
        completionHandler([.sound])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.handlePush(userInfoIn: response.notification.request.content.userInfo,isActive: false)
        completionHandler()
    }
    
    func handlePush(userInfoIn: [AnyHashable : Any], isActive:Bool = true)  {
        self.tabbarController?.selectedIndex = 1
        if let viewControllers = self.tabbarController?.viewControllers, viewControllers.count > 1 {
            if let homeNav = viewControllers[1] as? UINavigationController, let home = homeNav.viewControllers.first as? HomeViewController {
                homeNav.popToRootViewController(animated: true)
                home.getRestaurantsAndOnGoingOrders()
            }
            let tabBarItem = self.tabbarController!.tabBar.items![3]
            UserDefaults.standard.set(true, forKey: "badgeval")
            tabBarItem.badgeValue = "●"
            tabBarItem.badgeColor = .clear
            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: primaryColor], for: .normal)
        }
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
