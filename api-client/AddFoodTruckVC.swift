//
//  AddFoodTruckVC.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 02/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class AddFoodTruckVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var foodtypeField: UITextField!
    @IBOutlet weak var avgcostField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonTapped(sender:UIButton){
        guard let name = nameField.text, nameField.text != "" else{
            showAlert(title: "Error", message: "Please enter name")
            return
        }
        guard let foodtype = foodtypeField.text, foodtypeField.text != "" else{
            showAlert(title: "Error", message: "Please enter foodtype")
            return
        }
        guard let avgcost = Double(avgcostField.text!), avgcostField.text != "" else {
            showAlert(title: "Error", message: "Please enter avgcost")
            return
        }
        
        guard let latitude = Double(latitudeField.text!), latitudeField.text != "" else {
            showAlert(title: "Error", message: "Please enter latitude")
            return
        }
        
        guard let longitude = Double(longitudeField.text!), longitudeField.text != "" else {
            showAlert(title: "Error", message: "Please enter latitude")
            return
        }
        
        DataService.instance.addNewFoodTruck(name, foodtype: foodtype, avgcost: avgcost, latitude: latitude, longitude: longitude) { (success) in
            if success {
                print("We saved successfully")
                self.dismissViewController()
            }else{
                self.showAlert(title: "Error", message: "Error ocurred saving the new food truck")
                print("We did'nt save successfully")
            }
        }
        
    }
    
    @IBAction func backButtonTapped(sender:UIButton){
        dismissViewController()
    }
    
    @IBAction func cancelButtonTapped(sender:UIButton){
        dismissViewController()
    }
    
    func dismissViewController(){
        OperationQueue.main.addOperation {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
