//
//  textFieldTableViewCell.swift
//  KAPU
//
//  Created by Alyonka on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import Foundation


import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
