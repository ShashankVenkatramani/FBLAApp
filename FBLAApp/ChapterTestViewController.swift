//
//  ChapterTestViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/21/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChapterTestViewController: UIDGuardedViewController {
    @IBOutlet var testLabel: UILabel!
    @IBOutlet var QRCodeImageView: UIImageView!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        let ref = db.collection("chapters").document(uid!)
        ref.getDocument { (document, error) in
            if let documentData = document!.data() {
                self.testLabel.text = "Owner of " + (documentData["chapterName"] as! String)
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
