//
//  LogInVC.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 02/08/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func loginButtonTapped(sender:UIButton){
        guard let email = emailTextField.text, emailTextField.text != "",
            let password = passwordTextField.text, passwordTextField.text != "" else{
            self.showAlert(title: "Error", message: "Please enter an email and a password to continue")
            return
        }
        
        AuthService.instance.registerUser(email: email, password: password) { (success:Bool) in
            if success {
                AuthService.instance.logIn(email: email, password: password, completion: { (success:Bool) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        OperationQueue.main.addOperation {
                            self.showAlert(title: "Error", message: "Incorrect password")
                        }
                    }
                })
            }else{
                OperationQueue.main.addOperation {
                    self.showAlert(title: "Error", message: "Unknown error ocurred saving the account")
                }
            }
        }
        
    }
    
    func showAlert(title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
