//
//  ReviewCell.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 04/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var reviewTextLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(review:FoodTruckReview) {
        titleLabel.text = review.title
        reviewTextLabel.text = review.text
    }
    
}
