//
//  RegisterViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit
import Firebase
import SCLAlertView

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(error: String) {
        let alert = SCLAlertView()
        alert.showError("Error", subTitle: "\(error)")
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.showAlert(error: error.localizedDescription)
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(firstName) \(lastName)"
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    self.showAlert(error: error.localizedDescription)
                }
            })
            guard let userId = Auth.auth().currentUser?.uid else { return }
            Firestore.firestore().collection(USERS_REF).document(userId).setData([
                DISPLAY_NAME: "\(firstName) \(lastName)",
                EMAIL: email,
                DATE_CREATED: FieldValue.serverTimestamp()
                ], completion: { (error) in
                    if let error = error {
                        self.showAlert(error: error.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
            })
        }
    }
}
