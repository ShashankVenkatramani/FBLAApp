//
//  RegisterUserViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/21/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth
//Checked by Rishabh Mudradi
class RegisterUserViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var scanQRButton: UIButton!
    var nameData:String?
    var emailData:String?
    var centerID:String?
    @IBAction func scanQRCodeButtonPressed(_ sender: Any) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "ScanClassViewController") as! ScanClassViewController
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //Fixed error, ran from main dispatch
                        DispatchQueue.main.async {
                            let viewController = storyboard.instantiateViewController(identifier: "ScanClassViewController") as! ScanClassViewController
                            viewController.modalPresentationStyle = .fullScreen
                            viewController.nameData = self.nameTextField.text
                            viewController.emailData = self.emailTextField.text
                            self.present(viewController, animated: true, completion: nil)
                        }
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        }
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
        var db = Firestore.firestore()
        if let name = nameTextField.text {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    if let confirmPassword = confirmPasswordTextField.text {
                        if password == confirmPassword {
                            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                                if let user = user {
                                    //update fields for students and chapters in database
                                    db.collection("students").document(user.user.uid).setData(["name" : name, "email" : email, "chapterUID" : "", "requestUID" : self.centerID!]){err in
                                        if let err = err {
                                            print("Error writing user document: \(err)")
                                        } else {
                                            print("Document succesfully written")
                                        }
                                    }
                                    db.collection("chapters").document(self.centerID!).collection("requests").document("request").setData([user.user.uid : ["name" : name]], merge: true){err in
                                        if let err = err {
                                            print("Error writing request document: \(err)")
                                        } else {
                                            print("Document succesfully written")
                                        }
                                    }
                                    let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(identifier: "StudentRequestViewController") as! StudentRequestViewController
                                    viewController.uid = user.user.uid
                                    viewController.modalPresentationStyle = .fullScreen
                                    self.present(viewController, animated: true, completion: nil)
                                } else {
                                    print("Register user student error \(error)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func goToLoginButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func goToChapterButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RegisterChapterViewController") as! RegisterChapterViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if centerID == nil {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.clear
            registerButton.setTitleColor(UIColor.clear, for: .normal)
        } else {
            scanQRButton.isEnabled = false
            scanQRButton.backgroundColor = UIColor.clear
            scanQRButton.setTitleColor(UIColor.clear, for: .normal)
        }
        
        if nameData == nil {
            nameTextField.text = nameData
        }
        if emailData == nil {
            emailTextField.text = emailData
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
