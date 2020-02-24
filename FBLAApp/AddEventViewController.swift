//
//  AddEventViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/23/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddEventViewController: UIDGuardedViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var startPicker: UIDatePicker!
    @IBOutlet var endPicker: UIDatePicker!
    @IBOutlet var eventDescription: UITextView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mandatorySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addEventButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("chapters").document(uid!).collection("events").document("events").setData([UUID.init().uuidString : ["name" : self.nameTextField.text, "start" : self.startPicker.date, "end" : self.endPicker.date, "description" : self.eventDescription.text, "location" : self.locationTextField.text, "mandatory" : self.mandatorySwitch.isOn]], merge: true){err in
            if let err = err {
                print("Error writing request document: \(err)")
            } else {
                print("Document succesfully written")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
