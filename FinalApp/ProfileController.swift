//
//  ProfileController.swift
//  FinalApp
//
//  Created by Daniel Dominguez on 04/12/2019.
//  Copyright © 2019 Daniel Domínguez Parrón. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileController: UIViewController,UINavigationBarDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate=self
        UINavigationBar.appearance().backgroundColor=UIColor.blue
       
        
    }
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        print("Logout tapped")
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            let loginController=LoginController()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: profileVC) as! ProfileController
            self.present(vc, animated: true, completion: nil)
            print("Successfully signed out of Firebase Auth")
        } catch (let err) {
            print(err.localizedDescription)
        }
        }
}
