//
//  Urls.swift
//  Foodjin
//
//  Created by Navpreet Singh on 18/05/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import Foundation

struct Urls {
    //http://ecuadorfloresdevcustomerapi.nestorhawk.com/swagger/ui/index
    //Main
   // static let mainUrl = "http://customerapi.nestorhawk.com/api"
    #if ECUADOR
    static let mainUrl = "http://easyeatstestapi.nestorhawk.com/api"
    #elseif DEBUG
    static let mainUrl = "http://easyeatstestapi.nestorhawk.com/api"
    #else
    static let mainUrl = "http://easyeatstestapi.nestorhawk.com/api"
    #endif
    
   // static let mainUrl = "http://easyeatsdevapi.nestorhawk.com/api"
    //Endpoints
    static let version = Urls.mainUrl + "/version"
    static let register = Urls.mainUrl + "/v1/Signup"
    static let registerVerfication = Urls.mainUrl + "/v1/RegistrationVerification"
    static let login = Urls.mainUrl + "/v1/Login"
    static let resetPassword = Urls.mainUrl + "/v1/ResetPassword"
    static let createPassword = Urls.mainUrl + "/v1/CreatePassword"
    static let resendOtp = Urls.mainUrl + "/v1/ResendOTP"
    static let forgotPasswword = Urls.mainUrl + "/v1/ForgetPassword"
    
    //Profile Tab
    static let getCustomerDetails = Urls.mainUrl + "/v1/CustomerDetails"
    static let updateCustomerDetails = Urls.mainUrl + "/v1/UpdateCustomer"

    static let getAddress = Urls.mainUrl + "/v1/GetCustomerAddress"
    static let addAddress = Urls.mainUrl + "/v1/SaveCustomerAddress"
    static let updateAddress = Urls.mainUrl + "/v1/UpdateCustomerAddress"
    static let deleteAddress = Urls.mainUrl + "/v1/DeleteCustomerAddress"
    
    static let orderHistory = Urls.mainUrl + "/v1/GetOrderHistory"
    static let getOrderDetails = Urls.mainUrl + "/v1/GetOrderedProdutsforReviewByID"
    static let postOrderReview = Urls.mainUrl + "/v1/OrderReviewByOrderID"
    static let postOrderStatus = Urls.mainUrl + "/v1/GetOrderStatus"

    
    static let getCards = Urls.mainUrl + "/v1/GetAllPaymentCard"
    static let addNewCard = Urls.mainUrl + "/v1/SavePaymentCard"
    static let deleteCard = Urls.mainUrl + "/v1/DeletePaymentCard"

    
    //News Tab
    static let blogPosts = Urls.mainUrl + "/v1/GetBloggerPosts"
    static let blogPostDetail = Urls.mainUrl + "/v1/GetBloggerPostsByPostId"
    static let blogPostComment = Urls.mainUrl + "/v1/CommentBloggerPostsByPostId"
    
    
    //Notification Tab
     static let getNotifications = Urls.mainUrl + "/v1/GetNotifications"
    
    //Search Tab
    static let search = Urls.mainUrl + "/v1/SearchCookndDish"
    
    //Home Tab
    static let topRatedCook = Urls.mainUrl + "/v1/GetTopRatedCooknRest"
    static let cookScreenFilterValues = Urls.mainUrl + "/v1/GetCooknRestDishesFiltersCategoryValues"
    static let topRatedCooksFilterValue = Urls.mainUrl + "/v1/GetCooknRestFiltersTitlenValues"
    static let topRatedDishes = Urls.mainUrl + "/v1/GetCooknRestDishes"
    static let topRatedDrinks = Urls.mainUrl + "/v1/GetCooknRestDrinks"
    static let markCookLike = Urls.mainUrl + "/v1/Markaslike"
    
    static let cookDetails = Urls.mainUrl + "/v1/GetCooknRestDetailsByID"
    static let cookProductsDetail = Urls.mainUrl + "/v1/GetCooknRestProductsByRestnCookId"

    static let dishDetails = Urls.mainUrl + "/v1/GetCooknRestProductDetailsByProductId"
    
    //checkout cart products
    static let checkoutCart = Urls.mainUrl + "/v1/checkoutcartproducts"
    static let checkoutPayment = Urls.mainUrl + "/v1/CheckoutPayment"
    static let applyCoupon = Urls.mainUrl + "/v1/ApplyCoupon"
    
    //Track Orders
    static let trackOrder = Urls.mainUrl + "/v1/OrderTrackingDetailsByOrderID"
    
    //Cart Api's
    static let cartCount = Urls.mainUrl + "/v1/GetCartCount"
    static let addProductOnCart = Urls.mainUrl + "/v1/AddProductToCart"
    static let plusProductOnCart = Urls.mainUrl + "/v2/AddProductonCart"
    static let minusProductOnCart = Urls.mainUrl + "/v2/RemoveProductToCart"
    static let deleteProductOnCart = Urls.mainUrl + "/v2/RemoveAllProductToCart"
    
    //Gallery
    static let galleryApi = Urls.mainUrl + "/v1/GetCooknRestGallary"
    
    //On Going Orders
    static let OnGoingOrderApi = Urls.mainUrl + "/v1/GetFCSNotifications"
    static let OnGoingOrderReviewStatusApi = Urls.mainUrl + "/v1/GetOrderedProdutsforReviewByID"
    
    static let getAllPaymentMethods = Urls.mainUrl + "/v1/GetAllPaymentMethods"
    
    //Options POST
    static let getStoreOptionsApi = Urls.mainUrl + "/v1/GetStoreoptions"
    
    static let getRestaurantsByTypeApi = Urls.mainUrl + "/v2/GetTopRatedCooknRest"
}
