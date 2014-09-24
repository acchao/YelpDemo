//
//  ViewController.swift
//  YelpDemo
//
//  Created by Andrew Chao on 9/23/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FilterViewControllerDelegate{

    var client: YelpClient!

    let yelpConsumerKey = "kJpw8S6LTK2wrVRxdb70NQ"
    let yelpConsumerSecret = "Di5O_j3uiaqBqwNd_n6hN-tEN1Q"
    let yelpToken = "T7P36RE-OFFw3enHKIKXVo8dg7wV40m2"
    let yelpTokenSecret = "vcaRuIfMeiWC7VTKCJgd7fT5foM"

    @IBOutlet weak var yelpTableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    var searchBar: UISearchBar!

    var restaurants:[Restaurant] = []

    // Search Queries
    var searchTerm: String!
    var sort: Int = 0
    var categories: String! = ""
    var radius: Int = 800
    var deals: Bool = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        yelpTableView.delegate = self
        yelpTableView.dataSource = self

        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = self.searchBar

        self.searchTerm = "Thai"
        reloadTableView()
    }

    // Reloads the Table View with Box Office Movies
    func reloadTableView()
    {
        client.searchWithTerm(self.searchTerm, sort: self.sort, categories: self.categories, radius: self.radius, deals: self.deals, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var restaurantDictionaries = (response as NSDictionary)["businesses"] as [NSDictionary]

            self.restaurants = []
            self.restaurants = restaurantDictionaries.map({ (business: NSDictionary) -> Restaurant in
                Restaurant(dictionary: business)
            })

            self.yelpTableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        tableView.rowHeight = UITableViewAutomaticDimension

        var cell = tableView.dequeueReusableCellWithIdentifier("YelpCell") as YelpCell

        cell.restaurant = self.restaurants[indexPath.row]
        return cell

    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        yelpTableView.reloadRowsAtIndexPaths(yelpTableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.None)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchTerm = searchBar.text
        self.reloadTableView()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var filtersNavigationViewController = segue.destinationViewController as UINavigationController

        var filterViewController = filtersNavigationViewController.viewControllers[0] as FilterViewController
        filterViewController.delegate = self
    }

    func filterViewControllerSearchButtonClicked(filterViewController: FilterViewController) {
        self.sort = filterViewController.sort
        self.categories = filterViewController.categories
        self.radius = filterViewController.radius
        self.deals = filterViewController.deals
        self.reloadTableView()
    }


}

