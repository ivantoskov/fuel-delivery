//
//  ProfileViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 01/12/2020.
//

import UIKit
import Firebase
import MapKit
import SCLAlertView
import Cosmos

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    private var usersCollectionRef: CollectionReference!
    private var usersListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        usersCollectionRef = Firestore.firestore().collection(USERS_REF)
        setListener()
    }
    
    func setListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        usersListener = usersCollectionRef.document(userId).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                let user = User.parseData(snapshot: snapshot)
                self.nameLabel.text = user.displayName
                self.emailLabel.text = user.email
                self.cosmosView.rating = user.overallRating
                
            }
        })
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
        
        let storyboard = UIStoryboard(name: MAIN, bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: SIGN_IN_VC)
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let alertView = SCLAlertView()
        alertView.addButton("Confirm") {
            self.signOut()
        }
        alertView.showWarning("Sign out?", subTitle: "", closeButtonTitle: "Cancel" , timeout: nil, colorStyle: SCLAlertViewStyle.warning.defaultColorInt, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
        
    }
}
