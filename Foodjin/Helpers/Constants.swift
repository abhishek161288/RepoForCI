//
//  Constants.swift
//  Foodjin
//
//  Created by Navpreet Singh on 24/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import Foundation

// User Defaults

#if ECUADOR
var storyboardName = "Main-ecuador"
var API_KEY = "EB61B718-4973-4790-A761-72AC579C0E6A" //4164A2F4-54C8-4B9C-B956-8F995B82379C"
var STORE_ID = "24"
let userId = "LoggedInUserId"
var STORE_CURRENCY = "$"
var primaryColor = UIColor(displayP3Red: 104.0/255.0, green: 1.0/255.0, blue: 0.0/255.0, alpha: 1.0)
#else
var storyboardName = "Main"
var API_KEY = "EB61B718-4973-4790-A761-72AC579C0E6A" //4164A2F4-54C8-4B9C-B956-8F995B82379C"
var STORE_ID = "24"
let userId = "LoggedInUserId"
var STORE_CURRENCY = "$"
var primaryColor = UIColor(displayP3Red: 106.0/255.0, green: 5.0/255.0, blue: 0.0/255.0, alpha: 1.0)
var secondaryColor = UIColor(displayP3Red: 252.0/255.0, green: 194.0/255.0, blue: 105.0/255.0, alpha: 1.0)
var GetHelp = ""
var Privacy = ""
var TermsCondition = ""
var SupportChatUrl = ""
#endif

//Date Format
let foodjinDateFormat = "dd MMM yyyy, HH:mm a"

//Colors
let foodJinGreenColor = UIColor(red:0.20, green:0.70, blue:0.36, alpha:1.0)
let foodJinRedColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
let foodJinOrangeColor = UIColor(red:1.00, green:0.49, blue:0.00, alpha:1.0)
