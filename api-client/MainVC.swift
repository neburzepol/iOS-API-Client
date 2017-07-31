//
//  MainVC.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 29/07/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.delegate = self
        DataService.instance.getAllFoodtrucks()
    }
}

extension MainVC:DataServiceDelegate{
    func trucksLoaded() {
        //print(DataService.instance.foodtrucks)
    }
    func reviewsLoaded() {
        print(DataService.instance.reviews)
    }
}
