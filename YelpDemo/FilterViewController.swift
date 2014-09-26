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

    var filterMenu = Filters.sharedInstance.filterMenu

    // Search Queries
    var searchTerm: String!
    var sort: Int = 0
    var categories = [String]()
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
        Filters.sharedInstance.filterMenu = filterMenu
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
        var section = Filters.sharedInstance.filterMenu[section]
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
        var section = filterMenu[indexPath.section] as Filters.Section
        var filter = section.filters[indexPath.row] as Filters.Filter

        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.delegate = self
        cell.label.text = section.filters[indexPath.row].title

        switch section.filterType {
        case Filters.FilterType.Select:
            if (!section.isExpanded) {
                cell.label.text = section.selected
            }
            cell.filterSwitch.hidden = true
            break
        case Filters.FilterType.Switch:
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
            if filter.value == 0 {
                categories.append(filter.title)

            } else {
                for (index, value) in enumerate(categories) {
                    if filter.title == value {
                        categories.removeAtIndex(index)
                    }
                }
            }
        }

        switch section.filterType {
        case Filters.FilterType.Select:
            filterMenu[indexPath.section].isExpanded = !section.isExpanded
            filterMenu[indexPath.section].setSelected(filter)
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case Filters.FilterType.Switch:
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
