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
import CoreData
import Firebase
class LoginController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var idTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        //Hide name textview when user select signin
        nameTxt.isHidden = !nameTxt.isHidden
    }
    //Sign button action
    @IBAction func action(_ sender: Any) {
        //If the input text is not empty signIn or sign up
        if (!emailTxt.text!.isEmpty && !passwordTxt.text!.isEmpty){
            //Selected signIn
            if segmentControl.selectedSegmentIndex==0{
                //Authentication with the input text values
                Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!,completion:  { (user, error) in
                    if user != nil
                    {
                        //Add email value to core data
                        self.addCoreData()
                        //Segue to map screen
                        self.performSegue(withIdentifier: "segueMap", sender: self)
                        print("Login correcto")
                    }
                    else{
                        //Print the error login
                        if let myError=error?.localizedDescription{
                            // create the alert
                            let alert = UIAlertController(title: "Error", message: myError, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            print("Error")
                        }
                    }
                })
            }
                //Selected SignUp
            else{
                //Signup an user with input text values
                Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!, completion:  { (user, error) in
                    //If user sign up correctly store his data in Firestore
                    if user != nil
                    {
                        let uid=Auth.auth().currentUser?.uid
                        let db=Firestore.firestore()
                        //Insert into collection users the current user id with input data
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
                    }
                    else{
                        if let myError=error?.localizedDescription{
                            // create the alert
                            let alert = UIAlertController(title: "Error", message: myError, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            print("Error")
                        }
                    }
                })
            }
        }
    }
    func addCoreData(){
        
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        //finally, we need to add some data to our created record for each key using set value
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(self.emailTxt.text!, forKey: "mail")
       print( user.setValue(self.emailTxt.text!, forKey: "mail"))
        //Now we have set all the values. The next step is to save it inside the Core Data
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    static func deleteData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            for data in test{
                //Delete selected data
                managedContext.delete(data)
            }
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    func retrieveData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let mail=data.value(forKey: "mail") as! String?{
                    print(mail)
                    self.performSegue(withIdentifier: "segueMap", sender: self)
                }
                else{
                    print("The data is nil or not set")
                }
            }
        } catch {
            
            print("Failed")
        }
        
    }
}

