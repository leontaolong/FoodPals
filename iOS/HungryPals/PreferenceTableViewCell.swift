//
//  PreferenceTableViewCell.swift
//  HungryPals
//
//  Created by Christy Lu on 3/8/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class PreferenceTableViewCell: UITableViewCell {

    @IBOutlet weak var accountIcon: UIImageView!
    @IBOutlet weak var accountList: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
