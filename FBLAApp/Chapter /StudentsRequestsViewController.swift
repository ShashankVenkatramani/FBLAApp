//
//  StudentsRequestsViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/25/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
class StudentsRequestsViewController: UIDGuardedViewController {
    @IBOutlet var studentsTableView: UITableView!
    @IBOutlet var requestsTableView: UITableView!
    var students:[[String:Any]] = []
    var requests:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableViews()
    }
    @IBAction func homeButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func setUpTableViews() {
        studentsTableView.dataSource = self
        studentsTableView.delegate = self
        requestsTableView.dataSource = self
        requestsTableView.delegate = self
        
        downloadRequests()
        downloadStudents()
    }
    
    func downloadStudents() {
        students = []
        let db = Firestore.firestore()
        db.collection("chapters").document(uid!).collection("students").document("student").getDocument {(document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                if let studentsData = documentData as? [String: Any] {
                    for (key, value) in studentsData {
                        let studentData = value as! NSMutableDictionary
                        for (uid, nameData) in studentData {
                            let studentDataEntry = ["uid" : key, "name" : nameData]
                            self.students.append(studentDataEntry)
                        }
                    }
                    self.studentsTableView.reloadData()
                }
            } else {
                print("Request document does not exist")
            }
        }
    }
    
    func downloadRequests() {
        requests = []
        let db = Firestore.firestore()
        db.collection("chapters").document(uid!).collection("requests").document("request").getDocument {(document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                if let requestsData = documentData as? [String: Any] {
                    for (key, value) in requestsData {
                        let requestData = value as! NSMutableDictionary
                        for (uid, nameData) in requestData {
                            let requestDataEntry = ["uid" : key, "name" : nameData]
                            self.requests.append(requestDataEntry)
                        }
                    }
                    self.requestsTableView.reloadData()
                }
            } else {
                print("Request document does not exist")
            }
        }
    }
}

extension StudentsRequestsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == requestsTableView {
            return requests.count
        }
        if tableView == studentsTableView {
            return students.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == requestsTableView {
            let cell = requestsTableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell") as! RequestTableViewCell
            cell.studentLabel.text = requests[indexPath.row]["name"] as! String
            return cell
        } else {
            let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
            cell.studentLabel.text = students[indexPath.row]["name"] as! String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let db = Firestore.firestore()
        if tableView == requestsTableView {
            let alert = UIAlertController(title: "Accept Student?", message: "Allow student to join the chapter", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: {_ in
                db.collection("chapters").document(self.uid!).collection("requests").document("request").updateData([self.requests[index]["uid"] as! String : FieldValue.delete()]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }

                db.collection("chapters").document(self.uid!).collection("students").document("student").setData([self.requests[index]["uid"] as! String : ["name" : self.requests[index]["name"] as! String]], merge: true){err in
                    if let err = err {
                        print("Error writing request document: \(err)")
                    } else {
                        print("Document succesfully written")
                    }
                }
                
                db.collection("students").document(self.requests[index]["uid"] as! String).updateData(["chapterUID" : self.uid]){err in
                    if let err = err {
                        print("Error updating chapterUID field: \(err)")
                    } else {
                        print("centerUID succesfully updated")
                    }
                }
                self.downloadRequests()
                self.downloadStudents()
                self.requestsTableView.reloadData()
                self.studentsTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Reject", style: .default, handler: {_ in
                db.collection("chapters").document(self.uid!).collection("requests").document("request").updateData([self.requests[index]["uid"] as! String : FieldValue.delete()]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                db.collection("students").document(self.requests[index]["uid"] as! String).updateData(["requestUID" : "rejected"]){err in
                    if let err = err {
                        print("Error updating centerUID field: \(err)")
                    } else {
                        print("reject code succesfully updated")
                    }
                }
                self.downloadRequests()
                self.downloadStudents()
                self.requestsTableView.reloadData()
                self.studentsTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
                self.downloadRequests()
                self.downloadStudents()
                self.requestsTableView.reloadData()
                self.studentsTableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        if tableView == studentsTableView {
            
        }
    }
}
