//
//  FoodTruckCell.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 01/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class FoodTruckCell: UITableViewCell {

    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var foodTypeLabel:UILabel!
    @IBOutlet weak var avgCostLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(truck: FoodTruck) {
        nameLabel.text = truck.name
        foodTypeLabel.text = truck.foodtype
        avgCostLabel.text = "$ \(truck.avgCost)"
    }

}
