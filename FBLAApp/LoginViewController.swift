//
//  LoginViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/20/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        var db = Firestore.firestore()
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let user = user {
                        let uid = user.user.uid
                        let studentPathTest = db.collection("students").document(uid)
                        studentPathTest.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
                                let viewController = storyboard.instantiateViewController(identifier: "StudentTestViewController") as! StudentTestViewController
                                viewController.uid = uid
                                viewController.modalPresentationStyle = .fullScreen
                                self.present(viewController, animated: true, completion: nil)
                            }
                        }
                        print("here")
                        let ownerPathTest = db.collection("chapters").document(uid)
                        ownerPathTest.getDocument {(document, error) in
                            if let document = document {
                                if document.exists {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(identifier: "ChapterTestViewController") as! ChapterTestViewController
                                    viewController.uid = uid
                                    viewController.modalPresentationStyle = .fullScreen
                                    self.present(viewController, animated: true, completion: nil)
                                }
                            }
                        }
                    } else if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RegisterUserViewController") as! RegisterUserViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        var user = Auth.auth().currentUser
        var db = Firestore.firestore()
        if user != nil {
            let uid = user!.uid
            let studentPathTest = db.collection("students").document(uid)
            studentPathTest.getDocument { (document, error) in
                if let document = document {
                    if document.exists {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(identifier: "StudentTestViewController") as! StudentTestViewController
                        viewController.uid = uid
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
            let chapterPathTest = db.collection("chapters").document(uid)
            chapterPathTest.getDocument { (document, error) in
                if let document = document {
                    if document.exists {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(identifier: "ChapterTestViewController") as! ChapterTestViewController
                        viewController.uid = uid
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
