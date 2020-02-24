//
//  ChapterHomeViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/23/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
struct Event {
    var name: String
    var date: String
    var month: String
}
class ChapterHomeViewController: UIDGuardedViewController {
    @IBOutlet var eventsCollectionView: UICollectionView!
    @IBOutlet var meetingsCollectionView: UICollectionView!
    @IBOutlet var announcementsTableView: UITableView!
    
    let cellIdentifier = "EventCollectionViewCell"
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var events: [Event] = []
    var meetings: [Event] = []
    
    @IBAction func addEventButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "AddEventViewController") as! AddEventViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        setupCollectionViewItemSize()
    }
    
    private func setupCollectionView() {
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
