//
//  LoginViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit
import Firebase
import SCLAlertView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(error: String) {
        let alert = SCLAlertView()
        alert.showError("Error", subTitle: "\(error)")
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.showAlert(error: error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
