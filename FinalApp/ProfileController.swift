//
//  ProfileController.swift
//  FinalApp
//
//  Created by Daniel Dominguez on 04/12/2019.
//  Copyright © 2019 Daniel Domínguez Parrón. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class ProfileController: UIViewController,UINavigationBarDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate=self
        UINavigationBar.appearance().backgroundColor=UIColor.blue
        fetchdata()
        
    }
    func fetchdata(){
       let db=Firestore.firestore()
                let userID = Auth.auth().currentUser?.uid
       // db.collection("users").document(userID!).getDocument(completion: )
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
//            let user = User(username: username)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    //Logout button action that sign out current user
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        print("Logout tapped")
        let auth = Auth.auth()
        
        do {
            //Sign out current user
            try auth.signOut()
            //Delete user from CoreData
            LoginController.deleteData()
            //Segue back for login screen
            self.performSegue(withIdentifier: "logout", sender: self)
            print("Successfully signed out of Firebase Auth")
        } catch (let err) {
            print(err.localizedDescription)
        }
        }
}
