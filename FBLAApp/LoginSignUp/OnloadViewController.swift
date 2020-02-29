//
//  OnloadViewController.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/28/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit

class OnloadViewController: UIViewController {

    @IBAction func continuePressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
