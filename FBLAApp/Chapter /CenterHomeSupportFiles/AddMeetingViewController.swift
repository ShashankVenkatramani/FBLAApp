//
//  AddMeetingViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/23/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddMeetingViewController: UIDGuardedViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var eventDescription: UITextView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mandatorySwitch: UISwitch!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!
    
    var startDatePicker: UIDatePicker?
    var endDatePicker: UIDatePicker?
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        startDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        
        startDatePicker?.addTarget(self, action: #selector(AddEventViewController.startDateChanged(datePicker:)), for: .valueChanged)
        endDatePicker?.addTarget(self, action: #selector(AddEventViewController.endDateChanged(datePicker:)), for: .valueChanged)
        
        startTimeTextField.inputView = startDatePicker
        endTimeTextField.inputView = endDatePicker
    }
    @objc func startDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        startTimeTextField.text = dateFormatter.string(from: startDatePicker!.date)
    }
    @objc func endDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        endTimeTextField.text = dateFormatter.string(from: endDatePicker!.date)
    }

    @IBAction func addMeetingButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("chapters").document(uid!).collection("meetings").document("meetings").setData([UUID.init().uuidString : ["name" : self.nameTextField.text, "start" : self.startTimeTextField.text, "end" : self.endTimeTextField.text, "description" : self.eventDescription.text, "location" : self.locationTextField.text, "mandatory" : self.mandatorySwitch.isOn]], merge: true){err in
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
