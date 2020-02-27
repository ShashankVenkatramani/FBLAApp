//
//  ChapterHomeViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/23/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
struct Event {
    var name: String
    var date: String
    var month: String
    var uid: String
}
struct Announcement {
    var name: String
    var message: String
    var uid: String
}
class ChapterHomeViewController: UIDGuardedViewController {
    @IBOutlet var eventsCollectionView: UICollectionView!
    @IBOutlet var meetingsCollectionView: UICollectionView!
    @IBOutlet var announcementsTableView: UITableView!
    
    let cellIdentifier = "EventCollectionViewCell"
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var events: [Event] = []
    var meetings: [Event] = []
    var announcements: [Announcement] = []
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
        //homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        homeButton.setImage(UIImage(named: "homeButton"), for: .normal)
        
        let studentButton = UIButton()
        studentButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(studentButton)
        studentButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        studentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        studentButton.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: 20).isActive = true
        studentButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        studentButton.addTarget(self, action: #selector(studentButtonPressed), for: .touchUpInside)
        studentButton.setImage(UIImage(named: "students"), for: .normal)
        
        let logoutButton = UIButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(logoutButton)
        logoutButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: sideView.bottomAnchor, constant: -60).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: sideView.leftAnchor, constant: 20).isActive = true
        logoutButton.addTarget(self, action: #selector(menuLogout), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        
        
        return sideView
    }()
    @objc func menuLogout() {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @objc func studentButtonPressed() {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentsRequestsViewController") as! StudentsRequestsViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    @objc func homeButtonPressed() {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ChapterHomeViewController") as! ChapterHomeViewController
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
    @IBAction func addAnnouncementButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "AddAnnouncementViewController") as! AddAnnouncementViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func addEventButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "AddEventViewController") as! AddEventViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func addMeetingButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "AddMeetingViewController") as! AddMeetingViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionViewTableView()
//        self.automaticallyAdjustsScrollViewInsets = false;
        
        downloadMeetingAndEventData()
        setUpMenu()
    }
    
    func downloadMeetingAndEventData() {
        let db = Firestore.firestore()
        db.collection("chapters").document(self.uid!).collection("announcements").document("announcements").getDocument { (document, error) in
            if let announcementData = document!.data() {
                for (uid, announcement) in announcementData {
                    let announcementDictionary = announcement as! NSMutableDictionary
                    self.announcements.append(Announcement(name: announcementDictionary.value(forKey: "name") as! String, message: announcementDictionary.value(forKey: "message") as! String, uid: uid))
                }
                self.announcementsTableView.reloadData()
            }
        }
        var eventLoaded = false
        var meetingLoaded = false
        db.collection("chapters").document(self.uid!).collection("meetings").document("meetings").getDocument { (centerMeetingDocument, error) in
            if let centerMeetingDocumentData = centerMeetingDocument?.data() {
                for (meetingUID, meetingData) in centerMeetingDocumentData {
                    let meetingDataDictionary = meetingData as! NSMutableDictionary
                    let startDateFormatter = DateFormatter()
                    startDateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd"
                    
                    let monthFormatter = DateFormatter()
                    monthFormatter.dateFormat = "MMM"
                    
                    let date = startDateFormatter.date(from: meetingDataDictionary.value(forKey: "start") as! String)
                    
                    let dateNumber = dateFormatter.string(from: date!)
                    let month = monthFormatter.string(from: date!)
                    self.meetings.append(Event(name: meetingDataDictionary.value(forKey: "name") as! String, date: dateNumber, month: month, uid: meetingUID as! String))
                    print("appending")
                }
                meetingLoaded = true
                print("event " + String(eventLoaded) + " meeting " + String(meetingLoaded))
                if(eventLoaded && meetingLoaded) {
                    if(self.events.count == 0) {
                        self.events.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    if(self.meetings.count == 0) {
                        self.meetings.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    self.eventsCollectionView.reloadData()
                    self.meetingsCollectionView.reloadData()
                }
            } else {
                meetingLoaded = true
                print("event " + String(eventLoaded) + " meeting " + String(meetingLoaded))
                if(eventLoaded && meetingLoaded) {
                    if(self.events.count == 0) {
                        self.events.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    if(self.meetings.count == 0) {
                        self.meetings.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    self.eventsCollectionView.reloadData()
                    self.meetingsCollectionView.reloadData()
                }
            }
        }
        db.collection("chapters").document(self.uid!).collection("events").document("events").getDocument { (centerEventDocument, error) in
            if let centerEventDocumentData = centerEventDocument?.data() {
                for (eventUID, eventData) in centerEventDocumentData {
                    let eventDataDictionary = eventData as! NSMutableDictionary
                    let startDateFormatter = DateFormatter()
                    startDateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd"
                    
                    let monthFormatter = DateFormatter()
                    monthFormatter.dateFormat = "MMM"
                    
                    let date = startDateFormatter.date(from: eventDataDictionary.value(forKey: "start") as! String)
                    
                    let dateNumber = dateFormatter.string(from: date!)
                    let month = monthFormatter.string(from: date!)
                    self.events.append(Event(name: eventDataDictionary.value(forKey: "name") as! String, date: dateNumber, month: month, uid: eventUID as! String))
                    print("appending")
                }
                eventLoaded = true
                print("event " + String(eventLoaded) + " meeting " + String(meetingLoaded))
                if(eventLoaded && meetingLoaded) {
                    if(self.events.count == 0) {
                        self.events.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    if(self.meetings.count == 0) {
                        self.meetings.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    self.eventsCollectionView.reloadData()
                    self.meetingsCollectionView.reloadData()
                }
            } else {
                eventLoaded = true
                print("event " + String(eventLoaded) + " meeting " + String(meetingLoaded))
                if(eventLoaded && meetingLoaded) {
                    if(self.events.count == 0) {
                        self.events.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    if(self.meetings.count == 0) {
                        self.meetings.append(Event(name: "none", date: "", month: "", uid: "none"))
                    }
                    self.eventsCollectionView.reloadData()
                    self.meetingsCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        setupCollectionViewItemSize()
    }
    
    private func setupCollectionViewTableView() {
        announcementsTableView.delegate = self
        announcementsTableView.dataSource = self
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        meetingsCollectionView.delegate = self
        meetingsCollectionView.dataSource = self
        
        let nib = UINib(nibName: "EventCollectionViewCell", bundle: nil)
        eventsCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        meetingsCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemForRow: CGFloat = 3
            let lineSpacing: CGFloat = 10
            let interItemSpacing: CGFloat = 10
            
            //let width = (eventsCollectionView.frame.width - (numberOfItemForRow - 1) * interItemSpacing)/numberOfItemForRow
            //let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            //collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.itemSize = CGSize(width: 150, height: 150)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .horizontal
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            
            eventsCollectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
            meetingsCollectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
}

extension ChapterHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == eventsCollectionView {
            return events.count
        } else {
            return meetings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        print(events.count)
        if collectionView == eventsCollectionView {
            cell.nameLabel.text = events[indexPath.item].name
            cell.dateLabel.text = events[indexPath.item].date
            cell.monthLabel.text = events[indexPath.item].month
            cell.customizeView.layer.cornerRadius = 10
            
            cell.layer.shadowColor = Colors.blue.cgColor
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowRadius = 6
            cell.layer.shadowOpacity = 1
        } else {
            cell.nameLabel.text = meetings[indexPath.item].name
            cell.dateLabel.text = meetings[indexPath.item].date
            cell.monthLabel.text = meetings[indexPath.item].month
            cell.customizeView.layer.cornerRadius = 10
            
            cell.layer.shadowColor = Colors.orange.cgColor
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowRadius = 6
            cell.layer.shadowOpacity = 1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pressed something")
    }
}

extension ChapterHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = announcementsTableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell") as! AnnouncementTableViewCell
        cell.nameTextField.text = announcements[indexPath.row].name
        cell.messageTextField.text = announcements[indexPath.row].message
        cell.customizeView.layer.cornerRadius = 10
        
        cell.layer.shadowColor = Colors.purple.cgColor
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 1
        
        return cell
    }
    
    
}
