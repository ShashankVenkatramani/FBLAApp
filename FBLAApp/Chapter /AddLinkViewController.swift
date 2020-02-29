//
//  AddLinkViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/28/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddLinkViewController: UIDGuardedViewController {
    @IBOutlet var siteNameTextField: UITextField!
    @IBOutlet var linkTextField: UITextField!
    @IBAction func addLinkButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("chapters").document(self.uid!).collection("links").document("links").setData([siteNameTextField.text! : linkTextField.text!], merge: true){err in
            if let err = err {
                print("Error writing request document: \(err)")
            } else {
                print("Document succesfully written")
                let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "ChapterLinkViewController") as! ChapterLinkViewController
                viewController.uid = self.uid
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterLinkViewController") as! ChapterLinkViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
