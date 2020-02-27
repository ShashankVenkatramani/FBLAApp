//
//  StudentRequestViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/23/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class StudentRequestViewController: UIDGuardedViewController {
    @IBOutlet var statusLabel: UILabel!
    
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
                    db.collection("chapters").document(documentData["requestUID"] as! String).getDocument {(centerDocument, error) in
                        if let centerData = centerDocument?.data() {
                            self.statusLabel.text = "Requesting to join " + (centerData["chapterName"] as! String)
                        }
                    }
                } else {
                    let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
                    let viewController = storyboard.instantiateViewController(identifier: "StudentHomeViewController") as! StudentHomeViewController
                    viewController.uid = self.uid
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
}
