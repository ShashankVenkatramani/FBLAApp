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
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func studentButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentsRequestsViewController") as! StudentsRequestsViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
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
        } else {
            cell.nameLabel.text = meetings[indexPath.item].name
            cell.dateLabel.text = meetings[indexPath.item].date
            cell.monthLabel.text = meetings[indexPath.item].month
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
        return cell
    }
    
    
}
