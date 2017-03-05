//
//  KapuCheckboxTableViewController.swift
//  KAPU
//
//  Created by Oleksii Pelekh on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class KapuCheckboxTableViewController: UITableViewController {

    var voteIsPressed = false
    var selectedVoteResult = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KapuCheckboxCell = tableView.dequeueReusableCell(withIdentifier: "KapuCheckboxCell", for: indexPath) as! KapuCheckboxCell
        
        switch indexPath.row {
        case 0:
            cell.optionLabel.text = "Pub"
        case 1:
            cell.optionLabel.text = "Park"
        case 2:
            cell.optionLabel.text = "Parking"
        case 3:
            cell.optionLabel.text = "Coffe shop"
        default:
            cell.optionLabel.text = "Grossery store"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return voteIsPressed ? 0 : 54
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 54))
        
        let voteButton: UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 5, width: footerView.frame.width, height: 44))
        voteButton.titleLabel?.textAlignment = .center
        voteButton.titleLabel?.textColor = .white
        voteButton.setTitle("Vote", for: .normal)
        voteButton.backgroundColor = UIColor.blue
        voteButton.addTarget(self, action: #selector(votePressed), for: .touchUpInside)
        
        footerView.addSubview(voteButton)
        
        return footerView
    }
    
    func votePressed() -> NSString {
        voteIsPressed = true
        self.tableView.frame = CGRect.init(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.x, width: self.tableView.frame.width, height: self.tableView.frame.height - 70.0)
        
        let selectedIndexPath = tableView.indexPathForSelectedRow
        let selectedCell: KapuCheckboxCell = tableView.cellForRow(at: selectedIndexPath!) as! KapuCheckboxCell
        
        self.tableView.reloadData()
        
        return selectedCell.optionLabel.text! as NSString
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
