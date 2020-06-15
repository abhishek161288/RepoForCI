//
//The MIT License (MIT)
//
//Copyright (c) 2015 Kirill Kunst
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit

public class Loader: UIView {
    private var coverView: UIView = UIView()
    private var loadingView: SwiftLoadingView?

    private var titleLabel: UILabel?

    @objc func rotated(notification: NSNotification) {
        
        let loader = Loader.sharedInstance
        
        let height : CGFloat = UIScreen.main.bounds.size.height
        let width : CGFloat = UIScreen.main.bounds.size.width
        let center : CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        loader.center = center
        loader.coverView.frame = UIScreen.main.bounds
    }
    
    class var sharedInstance: Loader {
        struct Singleton {
            static let instance = Loader(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: 50,height: 50)))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }

    public class func show(title: String?, animated : Bool) {
        DispatchQueue.main.async {
            let currentWindow : UIWindow = UIApplication.shared.keyWindow!
            
            let loader = Loader.sharedInstance
//            NotificationCenter.default.addObserver(loader, selector: #selector(loader.rotated(notification: )),
//                                                   name: NSNotification.Name.UIDeviceOrientationDidChange,
//                                                   object: nil)
            
            let height : CGFloat = UIScreen.main.bounds.size.height
            let width : CGFloat = UIScreen.main.bounds.size.width
            let center : CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
            loader.center = center

            // MARK: adding loader label
            loader.titleLabel?.backgroundColor = UIColor.lightGray
            loader.titleLabel?.textColor = UIColor.white
            loader.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
            loader.titleLabel?.textAlignment = .center
            if let tempTitle = title {
                if tempTitle.count > 3 {
                    loader.titleLabel?.isHidden = false
                    loader.titleLabel?.text = tempTitle
                } else {
                    loader.titleLabel?.isHidden = true
                }
            } else {
                loader.titleLabel?.isHidden = true
            }
            if (loader.superview == nil) {
                loader.coverView = UIView(frame: currentWindow.bounds)
                loader.coverView.backgroundColor = UIColor.black
                loader.coverView.alpha = 0.4
                currentWindow.addSubview(loader.coverView)
                currentWindow.addSubview(loader)
                loader.start()
            }
        }
    }

    public class func hide() {
        let loader = Loader.sharedInstance
        NotificationCenter.default.removeObserver(loader)
        DispatchQueue.main.async {
            loader.stop()
        }
    }

    private func setup() {
        self.alpha = 0
        let imageVW = UIImageView(frame: CGRect(x: (self.frame.size.width - 150)/2, y: (self.frame.size.height-100)/2, width: 150, height: 100))
        
        titleLabel = UILabel(frame: CGRect(x: (self.frame.size.width - 95)/2, y: (imageVW.frame.origin.y/2) + 60, width: 95, height: 25))
        imageVW.image = UIImage.gifImageWithName("loading")
        self.addSubview(imageVW)
        self.addSubview(titleLabel!)
    }

    private func start() {
        
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
                }, completion: { (finished) -> Void in
            });
    }

    private func stop() {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (finished) -> Void in
                    self.removeFromSuperview()
                    self.coverView.removeFromSuperview()
            });
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class SwiftLoadingView : UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}

