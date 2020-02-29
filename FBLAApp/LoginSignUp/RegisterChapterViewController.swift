//
//  RegisterChapterViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/21/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreData
//Checked by Rishabh
class RegisterChapterViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var chapterNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBAction func registerButtonPressed(_ sender: Any) {
        var db = Firestore.firestore()
        if let name = nameTextField.text {
            if let centerName = chapterNameTextField.text {
                if let email = emailTextField.text {
                    if let password = passwordTextField.text {
                        if let confirmPassword = confirmPasswordTextField.text {
                            if password == confirmPassword {
                                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                                    if let user = user {
                                        //Might remove latitude longitude
                                        db.collection("chapters").document(user.user.uid).setData(["chapterName" : centerName, "name" : name, "email" : email, "address" : "", "chapterImageLink" : "", "chapterLink" : "", "latitude" : -1000, "longitude" : -1000, "profileImageLink" : ""]){ err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                                let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
                                                let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
                                                viewController.uid = user.user.uid
                                                viewController.modalPresentationStyle = .fullScreen
                                                self.present(viewController, animated: true, completion: nil)
                                            }
                                        }
                                    } else {
                                        print("Unable to register user \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func startOverButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
