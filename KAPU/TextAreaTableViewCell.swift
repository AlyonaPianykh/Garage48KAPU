//
//  TextAreaTableViewCell.swift
//  KAPU
//
//  Created by Alyonka on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class TextAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
