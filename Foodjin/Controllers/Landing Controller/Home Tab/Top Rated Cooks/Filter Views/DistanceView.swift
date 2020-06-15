//
//  DistanceView.swift
//  Foodjin
//
//  Created by Navpreet Singh on 22/06/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

enum DistanceViewType {
    case Miles
    case Price
}

class DistanceView: UIView {

    static let identifier:String = "DistanceView"
    var value: Values?
    var sliderType: DistanceViewType?
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var lowValue: UILabel!
    @IBOutlet weak var highValue: UILabel!


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func clear() {
        if self.sliderType == DistanceViewType.Miles {
            guard let minValue = Int(self.value?.categoryValueFilter?[0].titleValueName ?? "0") else { return }
            self.lowValue.text = "\(minValue) Miles"
            self.brightnessSlider.value = Float(CGFloat(minValue))
        }
        
        if self.sliderType == DistanceViewType.Price {
            guard let minValue = Int(self.value?.categoryValueFilter?[0].titleValueName?.dropFirst() ?? "0") else { return }
            self.lowValue.text = "$\(minValue)"
            self.brightnessSlider.value = Float(CGFloat(minValue))
        }
    }
    
    func refreshView() {
        //print(self.value)
        
        if self.sliderType == DistanceViewType.Miles {
            print(self.value)
            guard let minValue = Int(self.value?.categoryValueFilter?[0].titleValueName ?? "0") else { return }
            guard let maxValue = Int(self.value?.categoryValueFilter?[1].titleValueName ?? "0") else { return }
            
            self.lowValue.text = "\(minValue) Miles"
            self.highValue.text = "\(maxValue) Miles"
            
            self.brightnessSlider.minimumValue = Float(CGFloat(minValue))
            self.brightnessSlider.maximumValue = Float(CGFloat(maxValue))
        }
        
        
        if self.sliderType == DistanceViewType.Price {
            guard let minValue = Int(self.value?.categoryValueFilter?[0].titleValueName?.dropFirst() ?? "0") else { return }
            guard let maxValue = Int(self.value?.categoryValueFilter?[1].titleValueName?.dropFirst() ?? "0") else { return }
            
            self.lowValue.text = "$\(minValue)"
            self.highValue.text = "$\(maxValue)"
            
            self.brightnessSlider.minimumValue = Float(CGFloat(minValue))
            self.brightnessSlider.maximumValue = Float(CGFloat(maxValue))
        }
    }

    @IBAction func sliderMoved(_ sender: UISlider) {
        if self.sliderType == DistanceViewType.Miles {
            self.lowValue.text = "\(Int(sender.value)) Miles"
        }
        
        if self.sliderType == DistanceViewType.Price {
            self.lowValue.text = "$\(Int(sender.value))"
        }
    }
}
