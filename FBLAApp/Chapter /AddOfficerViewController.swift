//
//  AddOfficerViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/28/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
class AddOfficerViewController: UIDGuardedViewController {
    @IBOutlet var officerNameTextField: UITextField!
    @IBOutlet var officerPositionTextField: UITextField!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterOfficerViewController") as! ChapterOfficerViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func addOfficerPressed(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("chapters").document(self.uid!).collection("officers").document("officers").setData([officerNameTextField.text! : officerPositionTextField.text!], merge: true){err in
            if let err = err {
                print("Error writing request document: \(err)")
            } else {
                print("Document succesfully written")
                let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "ChapterOfficerViewController") as! ChapterOfficerViewController
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
