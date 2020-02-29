//
//  StudentAttendenceViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/27/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
struct StudentAttendence {
    var name: String
    var desc: String
}
struct EventID {
    var id: String
    var event: Bool
}
class StudentAttendenceViewController: UIDGuardedViewController {
    @IBOutlet var attendenceTableView: UITableView!
    //: Start menu bar
    @IBAction func menuButtonPressed(_ sender: Any) {
        switchMenuState()
    }
    
    
    
    @objc func switchMenuState() {
        if menuShowing {
            UIView.animate(withDuration: 0.2) {
                self.sideMenuLeft?.isActive = false
                self.sideMenuLeft = self.sideMenu.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -80)
                self.sideMenuLeft?.isActive = true
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.sideMenuLeft?.isActive = false
                self.sideMenuLeft = self.sideMenu.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
                self.sideMenuLeft?.isActive = true
                self.view.layoutIfNeeded()
            }
        }
        menuShowing = !menuShowing
    }
    
    var menuShowing = false
    var sideMenuLeft:NSLayoutConstraint?
    
    
    lazy var sideMenu:UIView = {
        let sideView = UIView()
        sideView.translatesAutoresizingMaskIntoConstraints = false
        sideView.backgroundColor = Colors.sideMenuBlue
        
        let exitButton = UIButton()
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(exitButton)
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.topAnchor.constraint(equalTo: sideView.topAnchor, constant: 60).isActive = true
        exitButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        exitButton.addTarget(self, action: #selector(switchMenuState), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "closeButton"), for: .normal)
        
        let homeButton = UIButton()
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(homeButton)
        homeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        homeButton.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 40).isActive = true
        homeButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        homeButton.setImage(UIImage(named: "homeButton"), for: .normal)
        
        let attendenceButton = UIButton()
        attendenceButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(attendenceButton)
        attendenceButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attendenceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        attendenceButton.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 20).isActive = true
        attendenceButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        //attendenceButton.addTarget(self, action: #selector(attendenceButtonPressed), for: .touchUpInside)
        attendenceButton.setImage(UIImage(named: "attendance"), for: .normal)
        
        let qaButton = UIButton()
        qaButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(qaButton)
        qaButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        qaButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        qaButton.topAnchor.constraint(equalTo: attendenceButton.bottomAnchor, constant: 20).isActive = true
        qaButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        qaButton.addTarget(self, action: #selector(qaButtonPressed), for: .touchUpInside)
        qaButton.setImage(UIImage(named: "qa"), for: .normal)
        
        let linkButton = UIButton()
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(linkButton)
        linkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        linkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        linkButton.topAnchor.constraint(equalTo: qaButton.bottomAnchor, constant: 20).isActive = true
        linkButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        linkButton.setImage(UIImage(named: "link"), for: .normal)
        
        let officerButton = UIButton()
        officerButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(officerButton)
        officerButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        officerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        officerButton.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 20).isActive = true
        officerButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        officerButton.addTarget(self, action: #selector(officerButtonPressed), for: .touchUpInside)
        officerButton.setImage(UIImage(named: "tie"), for: .normal)
        
        let logoutButton = UIButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(logoutButton)
        logoutButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: sideView.bottomAnchor, constant: -60).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        logoutButton.addTarget(self, action: #selector(menuLogout), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        
        let profileButton = UIButton()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(profileButton)
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20).isActive = true
        profileButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        profileButton.setImage(UIImage(named: "info"), for: .normal)
        
        return sideView
    }()
    @objc func menuLogout() {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @objc func homeButtonPressed() {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentHomeViewController") as! StudentHomeViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @objc func attendenceButtonPressed() {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentAttendenceViewController") as! StudentAttendenceViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @objc func qaButtonPressed() {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentQAViewController") as! StudentQAViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @objc func linkButtonPressed() {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentLinkViewController") as! StudentLinkViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @objc func officerButtonPressed() {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentOfficerViewController") as! StudentOfficerViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @objc func profileButtonPressed() {
        let storyboard = UIStoryboard(name: "StudentViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentProfileViewController") as! StudentProfileViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    //run in view did load
    func setUpMenu() {
        view.addSubview(sideMenu)

        sideMenuLeft = sideMenu.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -80)
        sideMenuLeft?.isActive = true
        NSLayoutConstraint.activate([
            sideMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sideMenu.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenu.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    //: End menu bar
    var attendenceRecords:[StudentAttendence] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMenu()
        attendenceTableView.delegate = self
        attendenceTableView.dataSource = self
        downloadData()
    }
    func downloadData() {
        attendenceRecords = []
        let db = Firestore.firestore()
        db.collection("students").document(self.uid!).getDocument { (studentDocument, error) in
            let studentDocumentData = studentDocument?.data()
            var eventUIDs:[EventID] = []
            if let eventDict = studentDocumentData!["events"] as! NSMutableDictionary? {
                for (eventUID, status) in eventDict {
                    eventUIDs.append(EventID(id: eventUID as! String, event: true))
                }
            }
            db.collection("chapters").document(studentDocumentData!["chapterUID"] as! String).collection("events").document("events").getDocument { (document, error) in
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StudentAttendenceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendenceRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = attendenceTableView.dequeueReusableCell(withIdentifier: "StudentAttendenceTableViewCell") as! StudentAttendenceTableViewCell
        cell.nameLabel.text = attendenceRecords[indexPath.row].name
        cell.descLabel.text = attendenceRecords[indexPath.row].desc
        return cell
    }
    
    
}
