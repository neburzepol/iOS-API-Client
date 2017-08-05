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
    
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    var loginVC : LogInVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        dataService.delegate = self
        dataService.getAllFoodtrucks()
    }
    
    func showLogInVC() {
        loginVC = LogInVC()
        loginVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(sender:UIButton){
        if AuthService.instance.isAuthenticated == true{
            performSegue(withIdentifier: "showAddTruckVC", sender: self)
        }else{
            showLogInVC()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailsVC" {
            
            if let indexPath = tableview.indexPathForSelectedRow{
                let destinationViewController = segue.destination as! DetailsVC
                destinationViewController.selectedTruck = DataService.instance.foodtrucks[indexPath.row]
            }
            
        }
        
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
