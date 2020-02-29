//
//  LoginViewController.swift
//  FBLAApp
//
//  Created by Vishal Shenoy on 2/20/20.
//  Copyright © 2020 Vishal Shenoy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
//Checked by Shashank V
class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logoImageView: UIImageView!
    @IBAction func googleButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://accounts.google.com/Login")!)
    }
    @IBAction func facebookButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/login.php")!)
    }
    
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
                                let viewController = storyboard.instantiateViewController(identifier: "StudentRequestViewController") as! StudentRequestViewController
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
                                    let viewController = storyboard.instantiateViewController(identifier: "OnloadOneViewController") as! OnloadOneViewController
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
        logoImageView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        var user = Auth.auth().currentUser
        var db = Firestore.firestore()
        if user != nil {
            //Check if user is a student
            let uid = user!.uid
            let studentPathTest = db.collection("students").document(uid)
            studentPathTest.getDocument { (document, error) in
                if let document = document {
                    if document.exists {
                        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
                        let viewController = storyboard.instantiateViewController(identifier: "StudentRequestViewController") as! StudentRequestViewController
                        viewController.uid = uid
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
            //Check if user is a chapter
            let chapterPathTest = db.collection("chapters").document(uid)
            chapterPathTest.getDocument { (document, error) in
                if let document = document {
                    if document.exists {
                        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
                        let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
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
