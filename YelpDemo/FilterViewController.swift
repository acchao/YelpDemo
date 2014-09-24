//
//  FilterViewController.swift
//  YelpDemo
//
//  Created by Andrew Chao on 9/23/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filterViewControllerSearchButtonClicked(filterViewController: FilterViewController)
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var delegate: FilterViewControllerDelegate!

    @IBOutlet weak var tableView: UITableView!

    enum FilterType {
        case Select
        case Switch
    }

    class Filter {
        var title: String!
        var filterType: FilterType
        var isExpanded: Bool
        var filters: [String!]
        var selected: String!
        init (title: String, filterType: FilterType, isExpanded: Bool, filters: [String!]) {
            self.title = title
            self.filterType = filterType
            self.isExpanded = isExpanded
            self.filters = filters
            self.selected = filters[0]
        }

        convenience init() {
            self.init(title: "blank", filterType: FilterType.Select, isExpanded: true, filters: ["blank"])
        }

        func setSelected(selected: String!) {
            self.selected = selected
        }
    }

    var filters = [
        Filter(title: "Sort By", filterType: FilterType.Select, isExpanded: false, filters: ["Best Match", "Distance", "Highest Rated"]),
        Filter(title: "Radius", filterType: FilterType.Select, isExpanded: false, filters: [".5 miles", "1 mile", "5 miles"]),
        Filter(title: "General Features", filterType: FilterType.Switch, isExpanded: true, filters: ["Open Now", "Hot & New", "Offering a Deal", "Delivery"]),
        Filter(title: "Categories", filterType: FilterType.Select, isExpanded: false, filters: ["Show All"])
    ]


    // Search Queries
    var searchTerm: String!
    var sort: Int = 0
    var categories: String! = "Greek"
    var radius: Int = 800 //.5 miles
    var deals: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        delegate.filterViewControllerSearchButtonClicked(self)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filters.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filters[section].title
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var section = filters[section]
        switch section.filterType {
        case FilterType.Select:
            if (section.isExpanded){
                return section.filters.count
            } else {
                return 1
            }
        case FilterType.Switch:
            return section.filters.count
        default:
            break
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension

        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
        var section = filters[indexPath.section] as Filter

        if (!section.isExpanded) {
            cell.label.text = section.selected
        } else {
            cell.label.text = section.filters[indexPath.row]
        }

        switch section.filterType {
        case FilterType.Select:
            cell.filterSwitch.hidden = true
        case FilterType.Switch:
            cell.filterSwitch.hidden = false
        default:
            break
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        var section = filters[indexPath.section]
        if section.title == "Sort By" {
            if section.filters[indexPath.row] == "Best Match" {
                self.sort = 0
            } else if section.filters[indexPath.row] == "Distance" {
                self.sort = 1
            } else if section.filters[indexPath.row] == "Highest Rated" {
                self.sort = 2
            }
        } else if section.title == "Radius" {
            if section.filters[indexPath.row] == ".5 miles" {
                self.radius = 800
            } else if section.filters[indexPath.row] == "1 mile" {
                self.radius = 1600
            } else if section.filters[indexPath.row] == "5 miles" {
                self.radius = 5000
            }
        } else if section.title == "General Features" {
            if section.filters[indexPath.row] == "Offering a Deal" {
                self.deals = !self.deals
            }
        }

        switch section.filterType {
        case FilterType.Select:
            filters[indexPath.section].isExpanded = !filters[indexPath.section].isExpanded
            filters[indexPath.section].setSelected(section.filters[indexPath.row])
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
