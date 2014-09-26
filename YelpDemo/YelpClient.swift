//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

let yelpConsumerKey = "kJpw8S6LTK2wrVRxdb70NQ"
let yelpConsumerSecret = "Di5O_j3uiaqBqwNd_n6hN-tEN1Q"
let yelpToken = "T7P36RE-OFFw3enHKIKXVo8dg7wV40m2"
let yelpTokenSecret = "vcaRuIfMeiWC7VTKCJgd7fT5foM"

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class var sharedInstance : YelpClient {
        struct Static {
            static var token: dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }

    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);

        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

    func searchWithTerm(term: String, sort: Int, category_filter: [String], radius_filter: Int, deals_filter: Bool, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var parameters = ["term": term, "location": "San Francisco"]
        if !category_filter.isEmpty {
            parameters["category_filter"] = expandCategories(category_filter)
        }

        if sort != 0 {
            parameters["sort"] = "\(sort)"
        }
        if deals_filter != 0 {
            parameters["deals_filter"] = "\(deals_filter)"
        }
        if radius_filter != 0 {
            parameters["radius_filter"] = "\(radius_filter)"
        }

        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }

    func expandCategories(category_filter: [String]) -> String{
        var categories: String = ""
        for category in category_filter {
            categories = "\(category),\(categories)"
        }

        //remove comma
        categories = dropLast(categories)
        return categories
    }
}