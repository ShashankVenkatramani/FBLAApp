//
//  ViewMeetingViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/27/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewMeetingViewController: UIDGuardedViewController {
    var meeting:Event?
    @IBOutlet var QRCodeImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var startTextField: UITextField!
    @IBOutlet var endTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mandatorySwitch: UISwitch!
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
        viewController.uid = self.uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func saveEventButtonPressed(_ sender: Any) {
    }
    @IBAction func deleteEventButtonPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        if meeting == nil || meeting?.uid == "none"{
        } else {
            let db = Firestore.firestore()
            db.collection("chapters").document(self.uid!).collection("meetings").document("meetings").getDocument { (document, error) in
                if let meetingsData = document?.data() {
                    let meetingsDataDictionary = meetingsData[self.meeting!.uid] as! NSMutableDictionary
                    self.nameTextField.text = meetingsDataDictionary.value(forKey: "name") as! String
                    self.startTextField.text = meetingsDataDictionary.value(forKey: "start") as! String
                    self.endTextField.text = meetingsDataDictionary.value(forKey: "end") as! String
                    self.descriptionTextView.text = meetingsDataDictionary.value(forKey: "description") as! String
                    self.locationTextField.text = meetingsDataDictionary.value(forKey: "location") as! String
                    self.mandatorySwitch.isOn = meetingsDataDictionary.value(forKey: "mandatory") as! Bool
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if meeting == nil || meeting?.uid == "none"{
            let alert = UIAlertController(title: "Meeting Error", message: "The meeting failed to download, or there was an internal error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
                viewController.uid = self.uid
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let QRData = self.meeting!.uid.data(using: String.Encoding.ascii)
            
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(QRData, forKey: "inputMessage")
                if let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 6, y: 6)) {
                    self.QRCodeImageView.image = UIImage(ciImage: output)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
