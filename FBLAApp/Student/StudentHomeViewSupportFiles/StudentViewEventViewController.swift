//
//  StudentViewEventViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/27/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class StudentViewEventViewController: UIDGuardedViewController {
    var event:Event?
    
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
        if event == nil || event?.uid == "none"{
        } else {
            let db = Firestore.firestore()
            db.collection("students").document(self.uid!).getDocument { (document, error) in
                if let studentData = document?.data() {
                    let chapterUID = studentData["chapterUID"]
                    db.collection("chapters").document(chapterUID as! String).collection("events").document("events").getDocument { (document, error) in
                        if let eventsData = document?.data() {
                            let eventsDataDictionary = eventsData[self.event!.uid] as! NSMutableDictionary
                            self.nameTextField.text = eventsDataDictionary.value(forKey: "name") as! String
                            self.startTextField.text = eventsDataDictionary.value(forKey: "start") as! String
                            self.endTextField.text = eventsDataDictionary.value(forKey: "end") as! String
                            self.descriptionTextField.text = eventsDataDictionary.value(forKey: "description") as! String
                            self.locationTextField.text = eventsDataDictionary.value(forKey: "location") as! String
                            if(eventsDataDictionary.value(forKey: "mandatory") as! Bool) {
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
        if event == nil || event?.uid == "none"{
            let alert = UIAlertController(title: "Event Error", message: "The event failed to download, or there was an internal error", preferredStyle: .alert)
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
