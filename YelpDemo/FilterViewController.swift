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

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterCellDelegate {

    var delegate: FilterViewControllerDelegate!

    @IBOutlet weak var tableView: UITableView!

    enum FilterType {
        case Select
        case Switch
    }

    class Section{
        var title: String!
        var filterType: FilterType
        var isExpanded: Bool
        var filters: [Filter]
        var selected: String!
        init (title: String, filterType: FilterType, isExpanded: Bool, filters: [Filter]) {
            self.title = title
            self.filterType = filterType
            self.isExpanded = isExpanded
            self.filters = filters
            self.selected = filters[0].title
        }

        convenience init() {
            self.init(title: "blank", filterType: FilterType.Select, isExpanded: true, filters: [Filter(title: "blank", value: 0)])
        }

        func setSelected(selected: Filter) {
            self.selected = selected.title
        }

        func setSwitchFilterValue(row: Int) {
            self.filters[row].value = self.filters[row].value == 1 ? 0 : 1
        }
    }

    struct Filter{
        var title: String!
        var value: Int
    }

    var filterMenu = [
        Section(title: "Sort By", filterType: FilterType.Select, isExpanded: false,
            filters: [
                Filter(title: "Best Match", value: 0),
                Filter(title: "Distance", value: 1),
                Filter(title: "Highest Rated", value: 2)
            ]
        ),
        Section(title: "Radius", filterType: FilterType.Select, isExpanded: false,
            filters: [
                Filter(title: ".5 miles", value: 800),
                Filter(title: "1 miles", value: 1600),
                Filter(title: "5 miles", value: 4000),
            ]
        ),
        Section(title: "General Features", filterType: FilterType.Switch, isExpanded: true,
            filters: [
                Filter(title: "Open Now", value: 0),
                Filter(title: "Hot & New", value: 0),
                Filter(title: "Offering a Deal", value: 0),
                Filter(title: "Delivery", value: 0),
            ]
        ),
        Section(title: "Categories", filterType: FilterType.Switch, isExpanded: false,
            filters: [
                Filter(title: "breakfast_brunch", value: 0),
                Filter(title: "british", value: 0),
                Filter(title: "buffets", value: 0),
                Filter(title: "bulgarian", value: 0),
                Filter(title: "burgers", value: 0),
                Filter(title: "burmese", value: 0),
                Filter(title: "cafes", value: 0),
                Filter(title: "cafeteria", value: 0),
                Filter(title: "cajun", value: 0),
                Filter(title: "cambodian", value: 0),
                Filter(title: "newcanadian", value: 0),
                Filter(title: "cambodian", value: 0),
                Filter(title: "canteen", value: 0),
                Filter(title: "caribbean", value: 0),
                Filter(title: "chinese", value: 0),
                Filter(title: "dominican", value: 0),
                Filter(title: "haitian", value: 0),
                Filter(title: "puertorican", value: 0),
                Filter(title: "trinidadian", value: 0),
                Filter(title: "catalan", value: 0),
                Filter(title: "Collapse", value: 0),
            ]
        )
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

    func filterCellSwitchClicked(filterCell: FilterCell) {
        filterMenu[filterCell.section].setSwitchFilterValue(filterCell.row)
    }

    // Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterMenu.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterMenu[section].title
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var section = filterMenu[section]
        if (section.isExpanded){
            return section.filters.count
        } else {
            return 1
        }
    }

    // Setup each Cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension

        var cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
        var section = filterMenu[indexPath.section] as Section
        var filter = section.filters[indexPath.row] as Filter

        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.delegate = self
        cell.label.text = section.filters[indexPath.row].title

        switch section.filterType {
        case FilterType.Select:
            if (!section.isExpanded) {
                cell.label.text = section.selected
            }
            cell.filterSwitch.hidden = true
            break
        case FilterType.Switch:
            if (!section.isExpanded) {
                cell.label.text = "Show All"
                cell.filterSwitch.hidden = true
            } else {
                if cell.label.text == "Collapse All" {
                    cell.filterSwitch.hidden = true
                } else {
                    cell.filterSwitch.hidden = false
                }
            }
            cell.filterSwitch.setOn(filter.value == 1, animated: true)
            break
        default:
            break
        }

        return cell
    }

    // Row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        var section = filterMenu[indexPath.section]
        var filter = section.filters[indexPath.row]
        if section.title == "Sort By" {
            self.sort = filter.value
        } else if section.title == "Radius" {
            self.radius = filter.value
        } else if section.title == "General Features" {
            if filter.title == "Offering a Deal" {
                self.deals = (filter.value == 1)
            }

        } else if section.title == "Categories" {

        }

        switch section.filterType {
        case FilterType.Select:
            filterMenu[indexPath.section].isExpanded = !section.isExpanded
            filterMenu[indexPath.section].setSelected(filter)
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case FilterType.Switch:
            if (!section.isExpanded || filter.title == "Collapse All") {
                filterMenu[indexPath.section].isExpanded = !section.isExpanded
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            } else {
                filterMenu[indexPath.section].setSwitchFilterValue(indexPath.row)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }

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
