//
//  KapuDescriptionCell.swift
//  KAPU
//
//  Created by Oleksii Pelekh on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class KapuDescriptionCell: UITableViewCell {

    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 150.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
