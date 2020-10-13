//
//  SettingsViewController.swift
//  InstagramCloneFirebase37
//
//  Created by Luke Martin-Resnick on 9/25/20.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
        
    }
    
    

}
