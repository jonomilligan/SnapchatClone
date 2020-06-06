//
//  ViewController.swift
//  Snapchat
//
//  Created by Peter Milligan on 2020/05/17.
//  Copyright © 2020 John Milligan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var loginMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func topTapped(_ sender: Any) {
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if loginMode {
                    //Login
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            print(error)
                        }   else {
                            self.performSegue(withIdentifier: "authToSnaps", sender: nil)
                        }
                    })
                }   else {
                    //Sign up
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            print(error)
                        }   else {
                            if let user = user {
                                FIRDatabase.database().reference().child("users").child(user.uid).child("email").setValue(email)
                                self.performSegue(withIdentifier: "authToSnaps", sender: nil)
                            }
                            
                        }
                    })
                }
            }
        }
        
        
    }
    @IBAction func bottomTapped(_ sender: Any) {
        if loginMode {
            //switch to Sign Up
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Login", for: .normal)
            loginMode = false
        } else {
            //switch to Login
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
            loginMode = true
        }
    }
    
    
}

