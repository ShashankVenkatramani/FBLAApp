//
//  RequestTableViewCell.swift
//  FBLAApp
//
//  Created by Shanky(Prgm) on 2/25/20.
//  Copyright © 2020 Shashank Venkatramani. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet var studentLabel: UILabel!
    @IBOutlet var customizeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
