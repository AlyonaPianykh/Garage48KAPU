//
//  KapuViewController.swift
//  KAPU
//
//  Created by Oleksii Pelekh on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class KapuViewController: UIViewController {

    var kapu: Kapu?
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var kapuCheckboxContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chartToCheckboxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chartContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUILabels()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUILabels() {
        guard let kapu = self.kapu else {
            return
        }
        self.categoryNameLabel.text = kapu.categoryName
        self.titleLabel.text = kapu.title
        self.authorLabel.text = kapu.creatorName
        self.dateLabel.text = kapu.creationDate
    }

    func changeCheckboxTableViewHeight() {
        chartContainerView.frame = CGRect.init(x: chartContainerView.frame.origin.x, y: chartContainerView.frame.origin.y, width: chartContainerView.frame.width, height: chartContainerView.frame.height - 70)

        kapuCheckboxContainerHeightConstraint.constant -= 70
        chartToCheckboxTopConstraint.constant = 5
                self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, let kapu = self.kapu {
            switch identifier {
            case "kapuChart":
                let childViewController = segue.destination as! KapuChartViewController
                childViewController.kapu = kapu
                break
            case "kapuSelectChoice":
                let childViewController = segue.destination as! KapuCheckboxTableViewController
                childViewController.kapu = kapu
                childViewController.kapuViewController = self
                break
            case "kapuDescription":
                let childViewController = segue.destination as! KapuDescriptionTableViewController
                childViewController.kapu = kapu
                break
            default: break
            }
        }
        
    }
}
