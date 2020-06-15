//
//  CodableModels.swift
//  Foodjin
//
//  Created by Navpreet Singh on 24/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import Foundation
import Default

// MARK: - Response Status
struct ResponseStatus: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
    }
}

// MARK: - Version
struct Version: Codable {
    var StatusCode: Int?
    var ErrorMessageTitle, ErrorMessage: String?
    var Status: Bool?
    var ApiVersion, ApiKey: String?
    var TokenDispStatus, IsBaseSplashNeeded, IsMultiVendorSupported: Bool?
    var SplashURL: String?
    var IsTutorialNeeded: Bool?
    var TutorialVersion: String?
    var TutorialCount: Int?
    var IsMultiLanguage: Bool?
    var LanguageCount: Int?
    var DataBaseVersion: String?
    var IsDispGoogMap: Bool?
    var DispGoogMapURL: String?
    var IsSocketAvailable: Bool?
    var SocketURL, SocketPort: String?
    var IsDelTakeAwayOnDashboard: Bool?
    var ApiVerLangs: [APIVerLang]?
    var TutorialURLs: [JSONAny]?
    var StoreID: Int?
    var StoreCurrency: String?
    var GetHelp: String?
    var Privacy: String?
    var TermsCondition: String?
    var SupportChatUrl: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case StatusCode = "StatusCode"
        case GetHelp = "GetHelp"
        case Privacy = "Privacy"
        case TermsCondition = "TermsCondition"
        case SupportChatUrl = "SupportChatUrl"
        case ErrorMessageTitle = "ErrorMessageTitle"
        case ErrorMessage = "ErrorMessage"
        case Status = "Status"
        case ApiVersion = "ApiVersion"
        case ApiKey = "ApiKey"
        case TokenDispStatus = "TokenDispStatus"
        case IsBaseSplashNeeded = "IsBaseSplashNeeded"
        case IsMultiVendorSupported = "IsMultiVendorSupported"
        case SplashURL = "SplashURL"
        case IsTutorialNeeded = "IsTutorialNeeded"
        case TutorialVersion = "TutorialVersion"
        case TutorialCount = "TutorialCount"
        case IsMultiLanguage = "IsMultiLanguage"
        case LanguageCount = "LanguageCount"
        case DataBaseVersion = "DataBaseVersion"
        case IsDispGoogMap = "IsDispGoogMap"
        case DispGoogMapURL = "DispGoogMapURL"
        case IsSocketAvailable = "IsSocketAvailable"
        case SocketURL = "SocketURL"
        case SocketPort = "SocketPort"
        case IsDelTakeAwayOnDashboard = "IsDelTakeAwayOnDashboard"
        case ApiVerLangs = "APIVerLangs"
        case TutorialURLs = "TutorialURLs"
        case StoreID = "StoreId"
        case StoreCurrency = "StoreCurrency"
    }
}

// MARK: - APIVerLang
struct APIVerLang: Codable {
    var apiVerLangID: Int?
    var apiVerLang: String?
    
    enum CodingKeys: String, CodingKey {
        case apiVerLangID = "APIVerLangId"
        case apiVerLang = "APIVerLang"
    }
}

// MARK: - Register
struct Register: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: ResponseObj?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct ResponseObj: Codable {
    var userID: Int?
    var firstName, lastName: String?
    var gender: String?
    var userStatus: String?
    var isFCMToken: Bool?
    var deviceToken: String?
    var otp: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case gender = "Gender"
        case userStatus = "UserStatus"
        case isFCMToken = "IsFCMToken"
        case deviceToken = "DeviceToken"
        case otp = "OTP"
    }
}

// MARK: - VerifyRegistration
struct VerifyRegistration: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResetPassword
struct ResetPassword: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResendOtpResponse
struct ResendOtpResponse: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - Profile
struct Profile: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: ResponseObject?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct ResponseObject: Codable {
    var id: Int?
    var firstName, lastName, email: String?
    var mobileStd: Int?
    var mobileNo: String?
    var profilePic: String?
    var storeID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case firstName = "FirstName"
        case lastName = "LastName"
        case email = "Email"
        case mobileStd = "MobileStd"
        case mobileNo = "MobileNo"
        case profilePic = "ProfilePic"
        case storeID = "StoreId"
    }
}

// MARK: - AddressResponse
struct AddressResponse: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [AddressArray]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - AddressArray
struct AddressArray: Codable {
    var id: Int?
    var label, addressLine1, addressLine2, zipCode: String?
    var city: String?
    let latPos, longPos: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case label = "Label"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case zipCode = "ZipCode"
        case city = "City"
        case latPos = "LatPos"
        case longPos = "LongPos"
    }
}

// MARK: - BlogPosts
struct BlogPosts: Codable {
    var statusCode: Int?
    var errorMessageTitle: JSONNull?
    var errorMessage: String?
    var status: Bool?
    var responseObj: [BlogPost]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct BlogPost: Codable {
    var blogID: Int?
    var blogTitle, blogDescription: String?
    var allowComments: Bool?
    var blogTags, blogStartDate, blogEndDate, blogCreatedOn: String?
    var blogCommentsCount: Int?
    let customerImages: [CustomerImage]?
    var blogImage: String?
    var chefImage, blogTime: String?
    
    enum CodingKeys: String, CodingKey {
        case blogID = "BlogId"
        case blogTitle = "BlogTitle"
        case blogDescription = "BlogDescription"
        case allowComments = "AllowComments"
        case blogTags = "BlogTags"
        case blogStartDate = "BlogStartDate"
        case blogEndDate = "BlogEndDate"
        case blogCreatedOn = "BlogCreatedOn"
        case blogCommentsCount = "BlogCommentsCount"
        case customerImages = "CustomerImages"
        case blogImage = "BlogImage"
        case chefImage = "ChefImage"
        case blogTime = "BlogTime"
    }
}



// MARK: - BlogPostsDetail
struct BlogPostsDetail: Codable {
    let statusCode: Int?
    let errorMessageTitle: String?
    let errorMessage: String?
    let status: Bool?
    let responseObj: BlogPostsDetailResponse?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct BlogPostsDetailResponse: Codable {
    let blogID: Int?
    let blogTitle, blogDescription: String?
    let allowComments: Bool?
    let blogTags, blogStartDate, blogEndDate: String?
    let blogCreatedOn: String?
    let blogCommentsCount: Int?
    let blogImage: String?
    let chefImage: String?
    let blogTime: String?
    let shareInstaLink, shareFbLink, sharePinterstLink: String?
    let blogComments: [BlogComment]?
    
    enum CodingKeys: String, CodingKey {
        case blogID = "BlogId"
        case blogTitle = "BlogTitle"
        case blogDescription = "BlogDescription"
        case allowComments = "AllowComments"
        case blogTags = "BlogTags"
        case blogStartDate = "BlogStartDate"
        case blogEndDate = "BlogEndDate"
        case blogCreatedOn = "BlogCreatedOn"
        case blogCommentsCount = "BlogCommentsCount"
        case blogImage = "BlogImage"
        case chefImage = "ChefImage"
        case blogTime = "BlogTime"
        case shareInstaLink = "ShareInstaLink"
        case shareFbLink = "ShareFbLink"
        case sharePinterstLink = "SharePinterstLink"
        case blogComments = "BlogComments"
    }
}

// MARK: - BlogComment
struct BlogComment: Codable {
    let userImage: String?
    let userName, comment: String?
    
    enum CodingKeys: String, CodingKey {
        case userImage = "UserImage"
        case userName = "UserName"
        case comment = "Comment"
    }
}


// MARK: - OrderHistory
struct OrderHistory: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: JSONNull?
    var status: Bool?
    var responseObj: [Order]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct Order: Codable {
    var orderID: Int?
    var orderNumber: String?
    var orderStatus: Int?
    var status, orderTime, deliveredTime: String?
    var isOpenForReview: Bool?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case orderNumber = "OrderNumber"
        case orderStatus = "OrderStatus"
        case status = "Status"
        case orderTime = "OrderTime"
        case deliveredTime = "DeliveredTime"
        case isOpenForReview = "IsOpenForReview"
    }
}

// MARK: - OrderReviewData
struct OrderReviewData: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: JSONNull?
    var status: Bool?
    var responseObj: [OrderReviewDetails]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

struct OrderStatusData: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: JSONNull?
    var status: Bool?
    var responseObj: [StatusData]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

struct StatusData :Codable {
    var status: String?
    var statusId: Int?
    
    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusId = "StatusId"
       
    }
}




struct MerchantReviewDetails: Codable {
    var merchantId: Int?
    var picture: String?
    var pictureId: Int?
    var reviewOptionsS: String?
    var subtitle: String?
    var title: String?
    var reviewOptions: [String]?
    
    enum CodingKeys: String, CodingKey {
        case merchantId = "MerchantId"
        case picture = "Picture"
        case pictureId = "PictureId"
        case reviewOptionsS = "ReviewOptionsS"
        case subtitle = "Subtitle"
        case title = "Title"
        case reviewOptions = "ReviewOptions"
    }
    
}

// MARK: - ResponseObj
struct OrderReviewDetails: Codable {
    var orderID: Int?
    var orderNumber: String?
    var products: [Product]?
    var merchantReview: MerchantReviewDetails?
    var agentReview: AgentReviewDetails?
    var isAgentReview: Bool?
    var isItemReview: Bool?
    var isMerchantReview: Bool?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case orderNumber = "OrderNumber"
        case products = "Products"
        case merchantReview = "MerchantReview"
        case agentReview = "AgentReview"
        case isAgentReview = "IsAgentReview"
        case isItemReview = "IsItemReview"
        case isMerchantReview = "IsMerchantReview"
    }
}

struct AgentReviewDetails: Codable {
    var agentId: Int?
    var picture: String?
    var pictureId: Int?
    var reviewOptionsS: String?
    var subtitle: String?
    var title: String?
    var reviewOptions: [String]?
    
    enum CodingKeys: String, CodingKey {
        case agentId = "AgentId"
        case picture = "Picture"
        case pictureId = "PictureId"
        case reviewOptionsS = "ReviewOptionsS"
        case subtitle = "Subtitle"
        case title = "Title"
        case reviewOptions = "ReviewOptions"
    }
    
}

// MARK: - Product
struct Product: Codable {
    var productID: Int?
    var productName: String?
    var productImage: String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case productName = "ProductName"
        case productImage = "ProductImage"
    }
}

// MARK: - NotificationResponse
struct NotificationResponse: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [Notification]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct Notification: Codable {
    var orderID: Int?
    var title, orderNumber: String?
    var orderStatus: Int?
    var responseObjDescription, orderDate, orderNotificationDateTime, orderNotificationDate: String?
    var orderNotificationTime: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case title = "Title"
        case orderNumber = "OrderNumber"
        case orderStatus = "OrderStatus"
        case responseObjDescription = "Description"
        case orderDate = "OrderDate"
        case orderNotificationDateTime = "OrderNotificationDateTime"
        case orderNotificationDate = "OrderNotificationDate"
        case orderNotificationTime = "OrderNotificationTime"
    }
}

// MARK: - SearchResult
struct SearchResult: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [Cook]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct SearchResultElement: Codable {
    var restnCookID: Int?
    var cooknRESTName, cooknRESTDescription: String?
    var cooknRESTImageURL: String?
    var pictureID, rating, ratingCount: Int?
    var isLike: Bool?
    var restnCookAddress: String?
    var isStatusAvailable: Bool?
    var cousinItems: [CousinItem]?
    var distance, openTime, closeTime: String?
    
    enum CodingKeys: String, CodingKey {
        case restnCookID = "RestnCookId"
        case cooknRESTName = "CooknRestName"
        case cooknRESTDescription = "CooknRestDescription"
        case cooknRESTImageURL = "CooknRestImageURL"
        case pictureID = "PictureId"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case isLike = "IsLike"
        case restnCookAddress = "RestnCookAddress"
        case isStatusAvailable = "IsStatusAvailable"
        case cousinItems = "CousinItems"
        case distance = "Distance"
        case openTime = "OpenTime"
        case closeTime = "CloseTime"
    }
}

// MARK: - CousinItem
struct CousinItem: Codable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

// MARK: - AllCardResponse
struct AllCardResponse: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [Card]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - Card
struct Card: Codable {
    var id, object: String?
    var account, addressCity, addressCountry, addressLine1: String?
    var addressLine1Check, addressLine2, addressState, addressZip: String?
    var addressZipCheck, availablePayoutMethods: String?
    var brand, country: String?
    var currency: String?
    var customer, cvcCheck: String?
    var defaultForCurrency: Bool?
    var dynamicLast4: String?
    var expMonth, expYear: Int?
    var fingerprint, funding, last4: String?
    var metadata: Metadata?
    var name, recipient, threeDSecure, tokenizationMethod: String?
    var responseObjDescription, iin, issuer: String?
    
    var isSelected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, object, account
        case addressCity = "address_city"
        case addressCountry = "address_country"
        case addressLine1 = "address_line1"
        case addressLine1Check = "address_line1_check"
        case addressLine2 = "address_line2"
        case addressState = "address_state"
        case addressZip = "address_zip"
        case addressZipCheck = "address_zip_check"
        case availablePayoutMethods = "available_payout_methods"
        case brand, country, currency, customer
        case cvcCheck = "cvc_check"
        case defaultForCurrency = "default_for_currency"
        case dynamicLast4 = "dynamic_last4"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case fingerprint, funding, last4, metadata, name, recipient
        case threeDSecure = "three_d_secure"
        case tokenizationMethod = "tokenization_method"
        case responseObjDescription = "description"
        case iin, issuer
    }
}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - TopRatedCook
struct TopRatedCook: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [Cook]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMejssageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
    
    //Updation
    mutating func updateCook(newV : [Cook]) {
        responseObj = newV
    }
}

// MARK: - ResponseObj
struct Cook: Codable {
    var restnCookID: Int?
    var cooknRESTName, cooknRESTDescription: String?
    var cooknRESTImageURL: String?
    var pictureID, ratingCount: Int?
    var rating: Double?
    var isLike: Bool?
    var restnCookAddress: String?
    var isStatusAvailable: Bool?
    var cousinItems: [CousinItemCook]?
    var distance, openTime, closeTime: String?
    
    enum CodingKeys: String, CodingKey {
        case restnCookID = "RestnCookId"
        case cooknRESTName = "CooknRestName"
        case cooknRESTDescription = "CooknRestDescription"
        case cooknRESTImageURL = "CooknRestImageURL"
        case pictureID = "PictureId"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case isLike = "IsLike"
        case restnCookAddress = "RestnCookAddress"
        case isStatusAvailable = "IsStatusAvailable"
        case cousinItems = "CousinItems"
        case distance = "Distance"
        case openTime = "OpenTime"
        case closeTime = "CloseTime"
    }
}

// MARK: - CousinItem
struct CousinItemCook: Codable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

// MARK: - TopRatedDishes
struct TopRatedDishes: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [Dish]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct Dish: Codable {
    var restnCookID: Int?
    var restnCook: String?
    var restnCookPictureID: Int?
    var restnCookPictureURL: String?
    var itemID, quantity: Int?
    var itemName, responseObjDescription: String?
    var available: Bool?
    var cuisine: String?
    var preferences: [Preference]?
    var imageURL: [ImageURL]?
    var price: String?
    var ratingCount, reviewCount: Int?
    var rating: Double?
    var customerImages: [CustomerImage]?
    
    enum CodingKeys: String, CodingKey {
        case restnCookID = "RestnCookId"
        case restnCook = "RestnCook"
        case restnCookPictureID = "RestnCookPictureId"
        case restnCookPictureURL = "RestnCookPictureURL"
        case itemID = "ItemId"
        case quantity = "Quantity"
        case itemName = "ItemName"
        case responseObjDescription = "Description"
        case available = "Available"
        case cuisine = "Cuisine"
        case preferences = "Preferences"
        case imageURL = "ImageUrl"
        case price = "Price"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case reviewCount = "ReviewCount"
        case customerImages = "CustomerImages"
    }
}

// MARK: - CustomerImage
struct CustomerImage: Codable {
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "Image"
    }
}

// MARK: - ImageURL
struct ImageURL: Codable {
    var productImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case productImageURL = "ProductImageURL"
    }
}

// MARK: - Preference
struct Preference: Codable {
    var name: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case image = "Image"
    }
}

// MARK: - CookDetails
struct CookDetails: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [CookDetail]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct CookDetail: Codable {
    var restnCookID: Int?
    var cooknRESTName, cooknRESTDescription: String?
    var cooknRESTImageURL: String?
    var pictureID, ratingCount: Int?
    var rating: Float?
    var isLike: Bool?
    var restnCookAddress: String?
    var isStatusAvailable: Bool?
    var cousinItems: [CousinItem]?
    var distance, openTime, closeTime: String?
    
    enum CodingKeys: String, CodingKey {
        case restnCookID = "RestnCookId"
        case cooknRESTName = "CooknRestName"
        case cooknRESTDescription = "CooknRestDescription"
        case cooknRESTImageURL = "CooknRestImageURL"
        case pictureID = "PictureId"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case isLike = "IsLike"
        case restnCookAddress = "RestnCookAddress"
        case isStatusAvailable = "IsOpen"
        case cousinItems = "CousinItems"
        case distance = "Distance"
        case openTime = "OpenTime"
        case closeTime = "CloseTime"
    }
}

//// MARK: - CousinItem
//struct CousinItem: Codable {
//    var name: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case name = "Name"
//    }
//}

// MARK: - DishDetails
struct DishDetails: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [DishDetail]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - CookGallery
struct CookGallery: Codable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: String?
    let status: Bool?
    let responseObj: [CookGalleryResponseObj]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct CookGalleryResponseObj: Codable {
    let address: String?
    let imageID: Int?
    let imageCaption: String?
    let imageURL: String?
    let galleryType: Int?
    
    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case imageID = "ImageId"
        case imageCaption = "ImageCaption"
        case imageURL = "ImageURL"
        case galleryType = "GalleryType"
    }
}


// MARK: - ResponseObj
struct DishDetail: Codable {
    var id: Int?
    var name, responseObjDescription: String?
    var quantity: Int?
    var price: String?
    var ratingCount, reviewCount: Int?
    var rating: Double?
    var customerImages: [CustomerImage]?
    var comments: [Comment]?
    var preferences: [Preference]?
    var imageURL: [ImageURL]?
    var specifications: [Specification]?
    var cuisine, dishPrepareTime: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case responseObjDescription = "Description"
        case quantity = "Quantity"
        case price = "Price"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case reviewCount = "ReviewCount"
        case customerImages = "CustomerImages"
        case comments = "Comments"
        case preferences = "Preferences"
        case imageURL = "ImageUrl"
        case specifications = "Specifications"
        case cuisine = "Cuisine"
        case dishPrepareTime = "DishPrepareTime"
    }
}

// MARK: - Comment
struct Comment: Codable {
    var customerName, comment: String?
    var customerImage: String?
    
    enum CodingKeys: String, CodingKey {
        case customerName = "CustomerName"
        case comment = "Comment"
        case customerImage = "CustomerImage"
    }
}

//// MARK: - CustomerImage
//struct CustomerImage: Codable {
//    var image: String?
//
//    enum CodingKeys: String, CodingKey {
//        case image = "Image"
//    }
//}

//// MARK: - ImageURL
//struct ImageURL: Codable {
//    var productImageURL: String?
//
//    enum CodingKeys: String, CodingKey {
//        case productImageURL = "ProductImageURL"
//    }
//}

//// MARK: - Preference
//struct Preference: Codable {
//    var name: String?
//    var image: String?
//
//    enum CodingKeys: String, CodingKey {
//        case name = "Name"
//        case image = "Image"
//    }
//}

// MARK: - Specification
struct Specification: Codable {
    var name, value: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case value = "Value"
    }
}

// MARK: - CookFilterValues
struct CookFilterValues: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: JSONNull?
    var status: Bool?
    var responseObj: [Values]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct Values: Codable {
    var titleID: Int?
    var titleName, titleType: String?
    var categoryValueFilter: [CategoryValueFilter]?
    
    enum CodingKeys: String, CodingKey {
        case titleID = "TitleId"
        case titleName = "TitleName"
        case titleType = "TitleType"
        case categoryValueFilter = "CategoryValueFilter"
    }
}

// MARK: - CategoryValueFilter
struct CategoryValueFilter: Codable, Equatable {
    var titleValueID: Int?
    var titleValueName: String?
    
    enum CodingKeys: String, CodingKey {
        case titleValueID = "TitleValueId"
        case titleValueName = "TitleValueName"
    }
}

// MARK: - CookProducts
struct CookProducts: Codable {
    var statusCode: Int?
    var errorMessageTitle, errorMessage: String?
    var status: Bool?
    var responseObj: [CookProduct]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct CookProduct: Codable {
    var categoryID: Int?
    var categoryName: String?
    var categoryItems: [CategoryItem]?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "CategoryId"
        case categoryName = "CategoryName"
        case categoryItems = "CategoryItems"
    }
}

// MARK: - CategoryItem
struct CategoryItem: Codable {
    var itemID: Int?
    var itemName: String?
    var quantity: Int?
    var categoryItemDescription: String?
    var available: Bool?
    var cuisine: String?
    var preferences: [Preference]?
    var imageURL: [ImageURL]?
    var price: String?
    var ratingCount, reviewCount: Int?
    var rating: Float?
    var customerImages: [CustomerImage]?
    var productProductAttributes: [ProductProductAttribute]?
    var isProductAttributesExist: Bool?
    
    enum CodingKeys: String, CodingKey {
        case itemID = "ItemId"
        case itemName = "ItemName"
        case quantity = "Quantity"
        case categoryItemDescription = "Description"
        case available = "Available"
        case cuisine = "Cuisine"
        case preferences = "Preferences"
        case imageURL = "ImageUrl"
        case price = "Price"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case reviewCount = "ReviewCount"
        case customerImages = "CustomerImages"
        case productProductAttributes = "ProductProductAttributes"
        case isProductAttributesExist = "IsProductAttributesExist"
    }
}

// MARK: - ProductProductAttribute
struct ProductProductAttribute: Codable {
    var productAttributeMappingID, productAttributeID, productID: Int?
    var attributeName: String?
    var attributeTypeID: Int?
    var attributeType: JSONNull?
    var isRequired: Bool?
    var productAttribute: [ProductAttribute]?
    
    enum CodingKeys: String, CodingKey {
        case productAttributeMappingID = "ProductAttributeMappingId"
        case productAttributeID = "ProductAttributeId"
        case productID = "ProductId"
        case attributeName = "AttributeName"
        case attributeTypeID = "AttributeTypeId"
        case attributeType = "AttributeType"
        case isRequired = "IsRequired"
        case productAttribute = "ProductAttribute"
    }
}

// MARK: - ProductAttribute
struct ProductAttribute: Codable {
    var productAttributeValueID: Int?
    var name: String?
    var price: Int?
    var isPreSelected: Bool?
    var currency: String?
    
    enum CodingKeys: String, CodingKey {
        case productAttributeValueID = "ProductAttributeValueId"
        case name = "Name"
        case price = "Price"
        case isPreSelected = "IsPreSelected"
        case currency = "Currency"
    }
}

// MARK: - getAllPaymentMethods
struct AllPaymentMethods: Codable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: String?
    let status: Bool?
    let responseObj: [AllPaymentMethodsResponseObj]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - AllPaymentMethodsResponseObj
struct AllPaymentMethodsResponseObj: Codable {
    let paymentMethodId: Int?
    let paymentMethodName: String?
    let isShow: Bool?

    enum CodingKeys: String, CodingKey {
        case paymentMethodId = "PaymentMethodId"
        case paymentMethodName = "PaymentMethodName"
        case isShow = "isShow"
    }
}

// MARK: - AddToCart
struct AddToCart: Codable,DefaultStorable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: String?
    let status: Bool?
    let responseObj: AddToCartResponseObj?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}


// MARK: - ResponseObj
struct AddToCartResponseObj: Codable {
    let subtotal: String?
    let currencySymbol: String?
    let deliveryCharges: String?
    let tip: String?
    let discountAmount: String?
    let tax: String?
    let discountCode: String?
    let discountID: Double?
    let total: String?
    let coupon: String?
    let cartProducts: [CartProduct]?
    
    enum CodingKeys: String, CodingKey {
        case subtotal = "Subtotal"
        case currencySymbol = "CurrencySymbol"
        case tax = "Tax"
        case deliveryCharges = "DeliveryCharges"
        case tip = "Tip"
        case discountAmount = "DiscountAmount"
        case discountCode = "DiscountCode"
        case discountID = "DiscountId"
        case total = "Total"
        case coupon = "Coupon"
        case cartProducts = "CartProducts"
    }
}

// MARK: - CartProduct
struct CartProduct: Codable {
    let cartItemID: Int?
    let productAttribute: String?
    let productID, quantity: Int?
    let productName: String?
    let productPrice: String?
    let productImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case cartItemID = "CartItemId"
        case productAttribute = "ProductAttribute"
        case productID = "ProductId"
        case quantity = "Quantity"
        case productName = "ProductName"
        case productPrice = "ProductPrice"
        case productImageURL = "ProductImageURL"
    }
}


// MARK: - CartCount
struct CartCount: Codable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: String?
    let status: Bool?
    let responseObj: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}


// MARK: - CheckoutCart
struct CheckoutCart: Codable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: String?
    let status: Bool?
    let responseObj: CheckoutResponseObj?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct CheckoutResponseObj: Codable {
    let orderID: Int?
    let orderNumber: String?
    let orderTotal: String?
    let orderTax, deliveryCharges, quantity: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case orderNumber = "OrderNumber"
        case orderTotal = "OrderTotal"
        case orderTax = "OrderTax"
        case deliveryCharges = "DeliveryCharges"
        case quantity = "Quantity"
    }
}

// MARK: - TrackOrder
struct TrackOrder: Codable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: JSONNull?
    let status: Bool?
    let responseObj: [TrackOrderResponseObj]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct TrackOrderResponseObj: Codable {
    let orderID: Int?
    var orderDate, orderNumber, amount,subAmount, orderStatus, tax,discountAmount: String?
    let billingAddress, shippingAddress, cooknChefAddress,merchantAddressType, orderNotes: String?
    let orderedItems: [OrderedItem]?
    let orderedStatusArray: [OrderedStatusArray]?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case orderDate = "OrderDate"
        case orderNumber = "OrderNumber"
        case amount = "Amount"
        case subAmount = "SubAmount"
        case tax = "Tax"
        case discountAmount = "DiscountAmount"
        case orderStatus = "OrderStatus"
        case billingAddress = "BillingAddress"
        case shippingAddress = "ShippingAddress"
        case merchantAddressType = "MerchantAddressType"
        case cooknChefAddress = "CooknChefAddress"
        case orderedItems = "OrderedItems"
        case orderedStatusArray = "OrderedStatusArray"
        case orderNotes = "OrderNotes"
    }
}

// MARK: - OrderedItem
struct OrderedItem: Codable {
    let productName: String?
    let productQuantity: Int?
    var productTotalPrice, productPrice: String?
    let productImage: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "ProductName"
        case productQuantity = "ProductQuantity"
        case productTotalPrice = "ProductTotalPrice"
        case productPrice = "ProductPrice"
        case productImage = "ProductImage"
    }
}

// MARK: - OrderedStatusArray
struct OrderedStatusArray: Codable {
    let statusID: Int?
    let statusTitle, statusTime, statusDescription, statusDate: String?
    let isdone: Bool?
    
    enum CodingKeys: String, CodingKey {
        case statusID = "StatusId"
        case statusTitle = "StatusTitle"
        case statusTime = "StatusTime"
        case statusDescription = "StatusDescription"
        case statusDate = "StatusDate"
        case isdone = "Isdone"
    }
}

// MARK: - PaymentCheckout
struct PaymentCheckout: Codable {
    let statusCode: Int?
    let errorMessageTitle: String?
    let errorMessage: String?
    let status: Bool?
    let responseObj: PaymentCheckoutResponseObj?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct PaymentCheckoutResponseObj: Codable {
    let orderNumber, orderGUID, orderArrivalTime: String?
    
    enum CodingKeys: String, CodingKey {
        case orderNumber = "OrderNumber"
        case orderGUID = "OrderGuid"
        case orderArrivalTime = "OrderArrivalTime"
    }
}

struct GetRestaurantsByType: Codable {
   // let statusCode: Int?
    let errorMessage: String?
   //let errorMessageTitle: String?
    let status: Bool?
    let responseObj: [Restaurant]?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "ErrorMessage"
       // case errorMessageTitle = "ErrorMessageTitle"
        case status = "Status"
       // case statusCode = "StatusCode"
        case responseObj = "ResponseObj"
    }
}

struct Restaurant: Codable {
    let restnCookId: Int?
    let cooknRestName: String?
    let cuisine: String?
    let cooknRestImageURL: String?
    let pictureId: Int?
    let rating: Double?
    let ratingCount: Int?
    let restnCookAddress: String?
    let isOpen: Bool?
    let distance: String?
    let openTime: String?
    let closeTime: String?
    let isRestAvailable: Bool?
    let openCloseTime: [String]?

    enum CodingKeys: String, CodingKey {
        case restnCookId = "RestnCookId"
        case cooknRestName = "CooknRestName"
        case cuisine = "Cuisine"
        case cooknRestImageURL = "CooknRestImageURL"
        case pictureId = "PictureId"
        case rating = "Rating"
        case ratingCount = "RatingCount"
        case restnCookAddress = "RestnCookAddress"
        case isOpen = "IsOpen"
        case distance = "Distance"
        case openTime = "OpenTime"
        case closeTime = "CloseTime"
        case isRestAvailable = "IsRestAvailable"
        case openCloseTime = "OpenCloseTime"
    }
}

// MARK: - getStoreOptions

struct GetStoreOptions: Codable {
    let errorMessage: String?
    let status: Bool?
    let responseObj: [GetStoreOptionsResponseObj]?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

struct GetStoreOptionsResponseObj: Codable {
    let id: Int?
    let name: String?
    let isAvailable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case isAvailable = "IsAvailable"
    }
}
// MARK: - OnGoIngOrder
struct OnGoIngOrder: Codable {
    let statusCode: Int?
    let errorMessageTitle, errorMessage: String?
    let status: Bool?
    let responseObj: OnGoIngOrderDetails?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case errorMessageTitle = "ErrorMessageTitle"
        case errorMessage = "ErrorMessage"
        case status = "Status"
        case responseObj = "ResponseObj"
    }
}

// MARK: - ResponseObj
struct OnGoIngOrderDetails : Codable {
    let delivery: [OnGoIngOrderResponseObj]?
    let takeaway: [OnGoIngOrderResponseObj]?
    
    enum CodingKeys: String, CodingKey {
        case delivery = "delivery"
        case takeaway = "takeaway"
    }
}

struct OnGoIngOrderResponseObj : Codable {
    let orderID: String?
    let status: String?
    let deliveredTime, orderNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "OrderId"
        case status = "Status"
        case deliveredTime = "DeliveredTime"
        case orderNumber = "OrderNumber"
    }
}



// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        var container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    var key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    
    var value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        var context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        var context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if var value = try? container.decode(Bool.self) {
            return value
        }
        if var value = try? container.decode(Int64.self) {
            return value
        }
        if var value = try? container.decode(Double.self) {
            return value
        }
        if var value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if var value = try? container.decode(Bool.self) {
            return value
        }
        if var value = try? container.decode(Int64.self) {
            return value
        }
        if var value = try? container.decode(Double.self) {
            return value
        }
        if var value = try? container.decode(String.self) {
            return value
        }
        if var value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if var value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if var value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if var value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if var value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if var value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            var value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            var value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if var value = value as? Bool {
                try container.encode(value)
            } else if var value = value as? Int64 {
                try container.encode(value)
            } else if var value = value as? Double {
                try container.encode(value)
            } else if var value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if var value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if var value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            var key = JSONCodingKey(stringValue: key)!
            if var value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if var value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if var value = value as? Double {
                try container.encode(value, forKey: key)
            } else if var value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if var value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if var value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if var value = value as? Bool {
            try container.encode(value)
        } else if var value = value as? Int64 {
            try container.encode(value)
        } else if var value = value as? Double {
            try container.encode(value)
        } else if var value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            var container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if var arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if var dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
