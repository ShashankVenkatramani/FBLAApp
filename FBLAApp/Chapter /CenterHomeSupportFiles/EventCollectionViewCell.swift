//
//  EventCollectionViewCell.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/23/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var customizeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
