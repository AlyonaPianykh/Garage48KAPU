//
//  ButtonTableViewCell.swift
//  KAPU
//
//  Created by Alyonka on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
   @IBOutlet weak var buttonLabel: UILabel!

   override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    @IBAction func addPressed(_ sender: Any) {
        self.setSelected(true, animated: false)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
