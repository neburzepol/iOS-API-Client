//
//  MainVC.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 29/07/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var addButton:UIImageView!
    
    var dataService = DataService.instance
    var authService = AuthService.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        dataService.delegate = self
        dataService.getAllFoodtrucks()
    }
}

extension MainVC:DataServiceDelegate{
    func trucksLoaded() {
        //Main queue
        OperationQueue.main.addOperation {
            self.tableview.reloadData()
        }
    }
    func reviewsLoaded() {
        //Do nothing
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.foodtrucks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "FoodTruckCell", for: indexPath) as?FoodTruckCell{
            cell.configureCell(truck: dataService.foodtrucks[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
