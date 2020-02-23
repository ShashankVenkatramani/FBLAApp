//
//  StudentTestViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/21/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StudentTestViewController: UIDGuardedViewController {
    @IBOutlet var testLabel: UILabel!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        db.collection("students").document(uid!).getDocument { (document, error) in
            if let documentData = document?.data() {
                if documentData["chapterUID"] as! String == "" {
                    db.collection("chapters").document(documentData["requestUID"] as! String).getDocument { (centerDocument, error) in
                        if let centerData = centerDocument?.data() {
                            self.testLabel.text = "Requesting to join " + (centerData["chapterName"] as! String)
                        }
                    }
                } else {
                    //go to home
                }
            }
        }
    }
}
