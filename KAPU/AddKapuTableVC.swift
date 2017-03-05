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
import FirebaseStorage
import FirebaseDatabase
import MobileCoreServices


enum State {
    case table
    case filter
}

let filterCellNames = ["Infrastructure", "Transportation", "Decision Making"]

class AddKapuVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet var table: UITableView!
    var numberOfOptions = 3
    let kapusLoader = KapuLoader()
    var state:State = .table
    @IBOutlet weak var filterTable: UITableView!
    @IBOutlet weak var filterBackgroundView: UIView!
    var selectedFilter = 0
    
    var imageToSave: UIImage?
    
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
    @IBAction func saveKapu(_ sender: Any) {
        let titleTextFieldCell = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell
        let textAreaCell = self.table.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextAreaTableViewCell
        
        let title = titleTextFieldCell?.textField.text ?? "defaultTitle"
        let description = textAreaCell?.textField.text ?? "defaultDescription"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy, hh:mm"
        let currentDate = Date()
        
        let convertedDateString = dateFormatter.string(from: currentDate)
        let options = self.getOptions()
        
        let userName = FIRAuth.auth()?.currentUser?.displayName
        let kapu = Kapu(title: title,
                        body: description,
                        categoryName: self.getCategoryName(),
                        creationDate: convertedDateString,
                        creatorName: userName ?? "defaultUsername",
                        location: [
                            "city": "Lviv, Lvivska oblast",
                            "street": "Storojenka, 32"],
                        options: [:],
                        image: imageToSave)
        kapusLoader.addNew(kapu: kapu, options: options)
    }
 
    func getCategoryName() -> String {
        switch selectedFilter {
        case 0:
            return "Infrastructure"
        case 1:
            return "Transportation"
        case 2:
            return "Decision Making"
        default: return "Infrastructure"
        }
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
    
    func uploadButtonWasPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType: String = info[UIImagePickerControllerMediaType] as? String else {
            dismiss(animated: true, completion: nil)
            return
        }
        if mediaType == (kUTTypeImage as String) {
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imageToSave = originalImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddKapuVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 2, 3:
            return 44
        default: return 170
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == filterTable){
            selectedFilter = indexPath.row
            titleButton.setTitle(filterCellNames[selectedFilter], for: .normal)
            filterTable.reloadData()
            closeFilter()
        } else {
            if (indexPath.section == 2 && indexPath.row == numberOfOptions - 1) {
                numberOfOptions += 1
                self.table.reloadData()
            }
            if (indexPath.section == 3 && indexPath.row == 0) {
                self.uploadButtonWasPressed()
            }
        }
    }
    
}

extension AddKapuVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView == self.filterTable) {
            return 3
        }
        switch section {
        case 0, 1, 3:
            return 1
        default: return numberOfOptions
        }
    
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == self.filterTable) {
            return 1
        }
        return 4
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
        case 3:
            return "Photo Upload"
         default:  return ""
        }
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
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
    var cell: UITableViewCell?
        switch(indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            cell?.textLabel?.placeholderText = "Ask a question"
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "textAreaCell", for: indexPath) as! TextAreaTableViewCell
            cell?.textLabel?.placeholderText = "Describe the purpose youe Kapu"
            break
        case 2:
            switch indexPath.row {
            case 0..<numberOfOptions - 1:
                    cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
                    cell?.textLabel?.placeholderText = "Option \(indexPath.row)"
                break
            case numberOfOptions - 1:
                let buttoncell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as! ButtonTableViewCell
                buttoncell.buttonLabel.text = "Add Option"
                return buttoncell
            default: break
            }
        case 3:
            let photocell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as! ButtonTableViewCell
            photocell.buttonLabel?.text = "Attach Photo"
            return photocell
        default: break
        }
        
        return cell!
    }

    
}
