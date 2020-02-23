//
//  UIDGuardedViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/21/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import Firebase
class UIDGuardedViewController: UIViewController {
    var uid:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if uid == nil {
            let alert = UIAlertController(title: "Sign In Error", message: "It appears your account has signed out due to an internal  app error. Please try reloggging in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                try! Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
