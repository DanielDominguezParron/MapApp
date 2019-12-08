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
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate=self
        UINavigationBar.appearance().backgroundColor=UIColor.white
        fetchdata()
        
    }
    //Fetch data from firebase and adding to text fields in view.
    func fetchdata(){
        let db=Firestore.firestore()
        let docRef = db.collection("users").document((Auth.auth().currentUser?.uid)!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.name.text=document.data()!["name"] as! String
                self.mail.text=document.data()!["mail"] as! String
            } else {
                print("Document does not exist")
            }
        }
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
