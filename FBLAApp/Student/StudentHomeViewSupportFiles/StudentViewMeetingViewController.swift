//
//  StudentViewMeetingViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/27/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class StudentViewMeetingViewController: UIDGuardedViewController {
    var meeting:Event?
    @IBOutlet var nameTextField: UILabel!
    @IBOutlet var locationTextField: UILabel!
    @IBOutlet var descriptionTextField: UILabel!
    @IBOutlet var startTextField: UILabel!
    @IBOutlet var endTextField: UILabel!
    @IBOutlet var mandatoryTextField: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentHomeViewController") as! StudentHomeViewController
        viewController.uid = self.uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if meeting == nil || meeting?.uid == "none"{
        } else {
            let db = Firestore.firestore()
            db.collection("students").document(self.uid!).getDocument { (document, error) in
                if let studentData = document?.data() {
                    let chapterUID = studentData["chapterUID"]
                    db.collection("chapters").document(chapterUID as! String).collection("meetings").document("meetings").getDocument { (document, error) in
                        if let meetingData = document?.data() {
                            let meetingDataDictionary = meetingData[self.meeting!.uid] as! NSMutableDictionary
                            self.nameTextField.text = meetingDataDictionary.value(forKey: "name") as! String
                            self.startTextField.text = meetingDataDictionary.value(forKey: "start") as! String
                            self.endTextField.text = meetingDataDictionary.value(forKey: "end") as! String
                            self.descriptionTextField.text = meetingDataDictionary.value(forKey: "description") as! String
                            self.locationTextField.text = meetingDataDictionary.value(forKey: "location") as! String
                            if(meetingDataDictionary.value(forKey: "mandatory") as! Bool) {
                                self.mandatoryTextField.text = "Mandatory: Yes"
                            } else {
                                self.mandatoryTextField.text = "Mandatory: No"
                            }
                        }
                    }
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if meeting == nil || meeting?.uid == "none"{
            let alert = UIAlertController(title: "Meeting Error", message: "The meetting failed to download, or there was an internal error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "StudentHomeViewController") as! StudentHomeViewController
                viewController.uid = self.uid
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
        }
    }}
