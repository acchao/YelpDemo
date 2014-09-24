//
//  YelpCell.swift
//  YelpDemo
//
//  Created by Andrew Chao on 9/23/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class YelpCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!

    var restaurant: Restaurant! {
        didSet {
            restaurantName.text = "\(index+1). " + restaurant.name
            reviews.text = restaurant.reviews
            address.text = restaurant.display_address
            categories.text = restaurant.categories
            distance.text = restaurant.distance

            restaurantImage.setImageWithURL(NSURL(string: restaurant.thumbUrl))
            // Round the image corners
            restaurantImage.layer.cornerRadius = 5
            restaurantImage.clipsToBounds = true

            ratingImage.setImageWithURL(NSURL(string: restaurant.ratingUrl))
        }
    }

    var index:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
