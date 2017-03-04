//
//  IssuesViewController.swift
//  KAPU
//
//  Created by Andrii Verbovetskyi on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

enum State {
    case table
    case filter
}

let filterCellNames = ["Infrastructure", "Transportation", "Decision Making"]

class AddKapuVC: UIViewController {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet var table: UITableView!
    var numberOfOptions = 3
    var state:State = .table
    @IBOutlet weak var filterTable: UITableView!
    @IBOutlet weak var filterBackgroundView: UIView!
    var selectedFilter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openFilter(){
        state = .filter
        filterBackgroundView.isHidden = false
        view.bringSubview(toFront: filterBackgroundView)
    }
    
    func closeFilter(){
        state = .table
        filterBackgroundView.isHidden = true
    }
    
    @IBAction func close(_ sender: Any) {
        state = .table
        filterBackgroundView.isHidden = true
    }
    @IBAction func openMenu(_ sender: Any) {
        switch state {
        case .table:
            openFilter()
            break
        case .filter:
            closeFilter()
            break
        default: break
        }
    }

}

extension AddKapuVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 2:
            return 44
        default: return 170
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == filterTable){
            selectedFilter = indexPath.row
            titleButton.setTitle(filterCellNames[selectedFilter], for: .normal)
            filterTable.reloadData()
        } else {
            numberOfOptions += 1
            self.table.reloadData()
        }
    }
    
}

extension AddKapuVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView == self.filterTable) {
            return 3
        }
        switch section {
        case 0, 1:
            return 1
        default: return numberOfOptions
        }
    
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == self.filterTable) {
            return 1
        }
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == self.filterTable) {
            return ""
        }
        switch section {
        case 0:
            return "Title"
        case 1:
            return "Description (optional)"
        case 2:
            return "Answer options"
         default:  return ""
        }
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell: UITableViewCell?
        if (tableView == self.filterTable) {
            let filterCell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            filterCell.categoryName.text = filterCellNames[indexPath.row]
            if (indexPath.row == selectedFilter){
                filterCell.changeColorIfSelecedView.isHidden = false
                filterCell.categoryName.textColor = UIColor.white
            } else {
                filterCell.changeColorIfSelecedView.isHidden = true
                filterCell.categoryName.textColor = UIColor.black
            }
            return filterCell
        }
        switch(indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            
            cell?.placeholderText = "Ask a question"
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "textAreaCell", for: indexPath) as! TextAreaTableViewCell
            cell?.placeholderText = "Describe the purpose youe Kapu"
            break
        case 2:
            switch indexPath.row {
            case 0..<numberOfOptions - 1:
                    cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
                    
                    cell?.placeholderText = "Option \(indexPath.row)"
                break
            case numberOfOptions - 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as! ButtonTableViewCell
                break
                
            default: break
            }
        default: break
        }
        return cell!
    }
    
}
