//
//  LoginController.swift
//  FinalApp
//
//  Created by Daniel Dominguez on 30/11/2019.
//  Copyright © 2019 Daniel Domínguez Parrón. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
class LoginController: UIViewController {
 
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var idTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        nameTxt.isHidden = !nameTxt.isHidden
    }
    @IBAction func action(_ sender: Any) {
        
        if (!emailTxt.text!.isEmpty && !passwordTxt.text!.isEmpty){
            if segmentControl.selectedSegmentIndex==0{
              
                Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!,completion:  { (user, error) in
                    if user != nil
                    {
                        self.performSegue(withIdentifier: "segueMap", sender: self)
                        //alert
                        print("Login correcto")
                    }
                    else{
                        if let myError=error?.localizedDescription{
                            print(myError)
                        }
                        else{
                            print("Error")
                        }
                    }
                })
            }
            else{
                Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion:  { (user, error) in
                    if user != nil
                    {
                        let uid=Auth.auth().currentUser?.uid
                        let db=Firestore.firestore()
                        db.collection("users").document(uid!).setData([
                            "name": self.nameTxt.text!,
                            "mail": self.emailTxt.text!,
                            "password":self.passwordTxt.text!
                            ])
                        { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        
                        //alert
                    }
                    else{
                        if let myError=error?.localizedDescription{
                            print(myError)
                        }
                        else{
                            print("Error")
                        }
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

}
