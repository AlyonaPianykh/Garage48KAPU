//
//  KapuDescriptionTableViewController.swift
//  
//
//  Created by Oleksii Pelekh on 3/4/17.
//
//

import UIKit

class KapuDescriptionTableViewController: UITableViewController {

    var kapu: Kapu?
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 150 : 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        var city = ""
        var street = ""
        var description = ""
        if let kapu = self.kapu {
            city = kapu.location.value(forKey: "city") as! String
            street = kapu.location.value(forKey: "street") as! String
            description = kapu.body
        }
        
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "kapuAddressCell", for: indexPath) as! KapuAddressCell
            cell.streetLabel.text = street
            cell.cityLabel.text = city
            
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "kapuDescriptionCell", for: indexPath) as! KapuDescriptionCell
            
            cell.descriptionTextView.text = description
        
            return cell
            
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "kapuDiscussingCell", for: indexPath) as! KapuDiscussingCell
            
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            return cell
            
        default: return defaultCell
    }
        
        return defaultCell
    }
    
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

}*/
