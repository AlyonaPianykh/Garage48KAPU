//
//  ViewController.swift
//  KAPU
//
//  Created by Vasyl Khmil on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


class LoginVC: UIViewController {
    var databaseRef: FIRDatabaseReference!
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        self.databaseRef = FIRDatabase.database().reference()
    }
    
    @IBAction private func signUpPressed() {
        self.signUp()
    }
    
    private func signUp() {
        guard
            let email = self.emailField.text,
            let password = self.passwordField.text,
            let firstname = self.firstNameField.text else {
                
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) {
            (user, error) in
            
            guard let userId = user?.uid else {
                
                print("\(error)")
                return
            }
            
            let usersTable = FIRDatabase.database().reference().child("users")
            
            usersTable.child(userId).setValue(["email" : email, "first_name" : firstname])
        }
    }
    
    @IBAction private func logInPressed() {
            self.login()
    }
    
    private func login() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
                print("user is signed in")
            }
        FIRAuth.auth()?.signIn(withEmail: "test@test.com", password: "qwerty") { (user, error) in
            
            if error == nil {
                print("You have successfully logged in")
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
      /*  let kapu = new Kapu(title: "What to do with lot in 49th street?",
                            body: <#T##String#>, categoryName: <#T##String#>, creationDate: <#T##String#>, creatorName: <#T##String#>)
 
 */
    }
}
