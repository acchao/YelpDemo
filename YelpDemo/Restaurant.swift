//
//  Restaurant.swift
//  YelpDemo
//
//  Created by Andrew Chao on 9/23/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    var name: String!
    var reviews: String!
    var display_address: String!
    var categories: String!
    var distance: String!
    var thumbUrl: String!
    var ratingUrl: String!

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String

        var reviewCount = (dictionary["review_count"] as NSNumber).integerValue
        reviews = "\(reviewCount) reviews"

        var location: NSDictionary = dictionary["location"] as NSDictionary
        var addressArray = location["address"] as NSArray

        var address: String! = ""
        if addressArray.count != 0 {
           var address = addressArray[0] as? String ?? ""
        }

        var city = location["city"] as? String ?? ""
        var state_code = location["state_code"] as? String ?? ""
        var postal_code = location["postal_code"] as? String ?? ""

        display_address = "\(address), \(city), \(state_code), \(postal_code)"

        distance = dictionary["distance"] as? String ?? "2 mi"
        thumbUrl = dictionary["image_url"] as? String ?? ""
        ratingUrl = dictionary["rating_img_url"] as? String ?? ""

    }


    //TODO(andrew) fix this later
//    class func searchWithQuery(query: String, completion: ([Restaurant!, NSError!],) -> Void) {
//        YelpClient.sharedInstance.searchWithTerm(query, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//
//            var restaurantDictionaries = (response as NSDictionary)["businesses"] as [NSDictionary]
//
//            completion = restaurantDictionaries.map({ (business: NSDictionary) -> Restaurant in
//                Restaurant(dictionary: business)
//            })
//
//
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                return error
//        }
//
//    }
}

