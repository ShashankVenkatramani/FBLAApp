//
//  AddAnnouncementViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/24/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class AddAnnouncementViewController: UIDGuardedViewController {
    @IBOutlet var announcerNameTextField: UITextField!
    @IBOutlet var announcementTextView: UITextView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        
        announcementTextView.backgroundColor = UIColor.white
        announcementTextView.layer.cornerRadius = 10
        
        announcementTextView.layer.shadowColor = Colors.orange.cgColor
        announcementTextView.layer.shadowOffset = CGSize(width: 2, height: 2)
        announcementTextView.layer.shadowRadius = 6
        announcementTextView.layer.shadowOpacity = 1
        
        announcementTextView.clipsToBounds = false
    }
    @IBAction func addAnnouncementButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("chapters").document(uid!).collection("announcements").document("announcements").setData([UUID.init().uuidString : ["name" : self.announcerNameTextField.text, "message" : self.announcementTextView.text]], merge: true){err in
            if let err = err {
                print("Error writing request document: \(err)")
            } else {
                print("Document succesfully written")
                let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
                viewController.uid = self.uid
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
