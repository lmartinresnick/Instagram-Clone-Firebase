//
//  ViewController.swift
//  InstagramCloneFirebase37
//
//  Created by Luke Martin-Resnick on 9/24/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
        
        
        
        
    }
    @IBAction func signUpTapped(_ sender: Any) {
        
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        
        
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

