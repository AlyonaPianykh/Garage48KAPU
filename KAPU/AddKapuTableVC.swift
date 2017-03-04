//
//  IssuesViewController.swift
//  KAPU
//
//  Created by Andrii Verbovetskyi on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase



class AddKapuVC: UIViewController {
    
    @IBOutlet var table: UITableView!
    var numberOfOptions = 3
    let kapusLoader = KapuLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func postKapu(_ sender: Any) {
        let titleTextFieldCell = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell
        let textAreaCell = self.table.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextFieldTableViewCell
       
        let title = titleTextFieldCell?.textField.text ?? "defaultTitle"
        let description = textAreaCell?.textField.text ?? "defaultDescription"
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy, hh:mm"
        let currentDate = Date()

        let convertedDateString = dateFormatter.string(from: currentDate)
        let options = self.getOptions()
        
        let user = FIRAuth.auth()?.currentUser
        let userName = FIRAuth.auth()?.currentUser?.displayName
        let kapu = Kapu(title: title,
                        body: description,
                        categoryName: "Transportation",
                        creationDate: convertedDateString,
                        creatorName: userName ?? "defaultUsername",
                        location: [
            "city": "Lviv, Lvivska oblast",
            "street": "Storojenka, 32"],
                        options: [:])
        kapusLoader.addNew(kapu: kapu, options: options)
        
    }

    func getOptions() -> [String] {
        let rowsCount = self.table.numberOfRows(inSection: 2)
        var options: [String] = []
        
        for i in 0..<rowsCount-1  {
            let cell = self.table.cellForRow(at: IndexPath(row: i, section: 2)) as! TextFieldTableViewCell
            
            if cell.textField.text != nil && cell.textField.text != "" {
                let optionName = cell.textField.text!
                   options.append(optionName)
            }
        
        }
        
        return options
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
    
}

extension AddKapuVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0, 1:
            return 1
        default: return numberOfOptions
        }
    
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numberOfOptions += 1
        self.table.reloadData()
    }
    
}
