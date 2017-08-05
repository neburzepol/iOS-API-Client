//
//  DetailsVC.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 03/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    var selectedTruck:FoodTruck?
    var logInVC:LogInVC?
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var foodTypeLabel:UILabel!
    @IBOutlet weak var avgCostLabel:UILabel!
    @IBOutlet weak var mapView:MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = selectedTruck?.name
        foodTypeLabel.text = selectedTruck?.foodtype
        avgCostLabel.text = "\(selectedTruck!.avgCost)"
        
        mapView.addAnnotation(selectedTruck!)
        centerMapOnLocation(_location: CLLocation(latitude: selectedTruck!.lat, longitude: selectedTruck!.long))
    }
    
    func centerMapOnLocation(_location:CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(selectedTruck!.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func backButtonTapped(sender:UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewsButtonTapped(sender:UIButton){
        performSegue(withIdentifier: "showReviewsSegue", sender: self)
    }
    
    @IBAction func addReviewButtonTapped(sender:UIButton){
        if AuthService.instance.isAuthenticated == true{
            performSegue(withIdentifier: "showAddReviewSegue", sender: self)
        }else{
            showLogInVC()
        }
    }
    
    func showLogInVC(){
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = .formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReviewsSegue" {
            let destinationViewController = segue.destination as! ReviewsVC
            destinationViewController.selectedFoodTruck = selectedTruck
        }else if segue.identifier == "showAddReviewVC" {
            let destinationViewController = segue.destination as! AddReviewVC
            destinationViewController.selectedFoodTruck = selectedTruck
        }
            
    }
    
}
