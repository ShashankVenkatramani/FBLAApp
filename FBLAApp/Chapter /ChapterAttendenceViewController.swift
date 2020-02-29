//
//  ChapterAttendenceViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/28/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChapterAttendenceViewController: UIDGuardedViewController {
    var studentUID:String?
    var name:String?
    var attendenceRecords:[StudentAttendence] = []
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentsRequestsViewController") as StudentsRequestsViewController
        viewController.uid = self.uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBOutlet var attendenceTableView: UITableView!
    @IBOutlet var topLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        attendenceTableView.dataSource = self
        attendenceTableView.delegate = self
        topLabel.text = name! + "'s Attendance"
        downloadData()
    }
    func downloadData() {
        attendenceRecords = []
        let db = Firestore.firestore()
        db.collection("students").document(studentUID!).getDocument { (studentDocument, error) in
            let studentDocumentData = studentDocument?.data()
            var eventUIDs:[EventID] = []
            if let eventDict = studentDocumentData!["events"] as! NSMutableDictionary? {
                for (eventUID, status) in eventDict {
                    eventUIDs.append(EventID(id: eventUID as! String, event: true))
                }
            }
            db.collection("chapters").document(self.uid!).collection("events").document("events").getDocument { (document, error) in
                if let eventDict = document?.data() {
                    for eventUID in eventUIDs {
                        if eventUID.event {
                            let eventData = eventDict[eventUID.id] as! NSMutableDictionary
                            self.attendenceRecords.append(StudentAttendence(name: eventData.value(forKey: "name") as! String, desc: eventData.value(forKey: "description") as! String))
                        }
                    }
                    self.attendenceTableView.reloadData()
                }
            }
        }
    }
}

extension ChapterAttendenceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendenceRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = attendenceTableView.dequeueReusableCell(withIdentifier: "StudentAttendenceTableViewCell") as! StudentAttendenceTableViewCell
        print(attendenceRecords[indexPath.row])
        print(attendenceRecords[indexPath.row].name)
        cell.nameLabel.text = attendenceRecords[indexPath.row].name
        cell.descLabel.text = attendenceRecords[indexPath.row].desc
        return cell
    }
    
    
}
