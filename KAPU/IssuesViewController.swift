//
//  IssuesViewController.swift
//  KAPU
//
//  Created by Andrii Verbovetskyi on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class IssuesViewController: UIViewController {

    @IBOutlet var table: UITableView!
    let kapus = KapuLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotificationCenter()
        kapus.getKapusFromFB{
            self.table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kapus.getKapusFromFB {
            self.table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(IssuesViewController.updateKapus),
                                               name: NSNotification.Name(rawValue: "KapusWereUpdated"),
                                               object:nil)
    }
    
    func updateKapus() {
        self.table.reloadData()
    }

}

extension IssuesViewController :UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 187
    }
    
}

extension IssuesViewController :UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return kapus.allKapus.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell", for: indexPath) as! IssueTableViewCell
        let kapu = kapus.allKapus[indexPath.row]
        cell.categoryLabel.text = kapu.categoryName
        cell.issueDescriptionLabel.text = kapu.title
        cell.authorLabel.text = kapu.creatorName
        cell.dateLabel.text = kapu.creationDate
        cell.issuePicture.image = kapu.image
        return cell
    }
    
}
