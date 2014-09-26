//
//  Filters.swift
//  YelpDemo
//
//  Created by Andrew Chao on 9/26/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import Foundation

class Filters {
    class var sharedInstance: Filters {
        struct Static {
            static var instance: Filters?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = Filters()
        }

        return Static.instance!
    }

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
}