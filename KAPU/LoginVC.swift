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

    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var firstNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    

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
}

