//
//  IssueTableViewCell.swift
//  KAPU
//
//  Created by Andrii Verbovetskyi on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var issueDescriptionLabel: UILabel!
    @IBOutlet weak var issuePicture: UIImageView!
    @IBOutlet weak var authorAndDateLabel: UILabel!
    
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
