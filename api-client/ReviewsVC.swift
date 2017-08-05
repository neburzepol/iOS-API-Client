//
//  ReviewsVC.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 04/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class ReviewsVC: UIViewController {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var tableView:UITableView!

    var selectedFoodTruck:FoodTruck!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.instance.delegate = self
        
        if let truck = selectedFoodTruck {
            nameLabel.text = truck.name
            DataService.instance.getAllReviews(for: truck)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    @IBAction func backButtonTapped(sender:UIButton){
        print("asdada")
        _ = navigationController?.popViewController(animated: true)
    }
}

extension ReviewsVC : DataServiceDelegate{
    func trucksLoaded() {
        
    }
    
    func reviewsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
}

extension ReviewsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ReviewsVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell{
            cell.configureCell(review: DataService.instance.reviews[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}
