//
//  KapuCheckboxCell.swift
//  KAPU
//
//  Created by Oleksii Pelekh on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class KapuCheckboxCell: UITableViewCell {

    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        checkboxButton.imageView?.contentMode = UIViewContentMode.scaleToFill
        checkboxButton.setBackgroundImage(UIImage.init(named: "Checked"), for: UIControlState.selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkboxButton.isSelected = selected
    }
}
