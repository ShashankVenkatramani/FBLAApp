//
//  QRCodeChapterViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/26/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore

class QRCodeChapterViewController: UIDGuardedViewController {
    @IBOutlet var QRCodeImageView: UIImageView!
    @IBOutlet var ownerLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChapterViews", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StudentsRequestsViewController") as! StudentsRequestsViewController
        viewController.uid = uid
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getQRCode()
    }
    func getQRCode() {
        let db = Firestore.firestore()
        db.collection("chapters").document(uid!).getDocument { (document, error) in
            if let documentData = document!.data(){
                self.ownerLabel.text = "Join Code for: " + (documentData["chapterName"] as! String)
            }
        }
        
        let QRData = uid?.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(QRData, forKey: "inputMessage")
            if let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 6, y: 6)) {
                QRCodeImageView.image = UIImage(ciImage: output)
            }
        }
    }
}
