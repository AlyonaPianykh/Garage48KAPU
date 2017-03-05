//
//  KapuLoader.swift
//  KAPU
//
//  Created by Alyonka on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

let KAPUS: String = "requests"
let USERS: String = "users"

class Kapu {
    let body: String
    let categoryName: String
    let creatorName: String
    let creationDate: String
    let title: String
    let location: NSDictionary
    let options: NSDictionary
    
    init(title: String,
         body: String,
         categoryName: String,
         creationDate: String,
         creatorName: String,
         location: NSDictionary,
         options: NSDictionary) {
        self.title = title
        self.body = body
        self.creatorName = creatorName
        self.creationDate = creationDate
        self.categoryName = categoryName
        self.location = location
        self.options = options
    }
}

class KapuLoader {
    var databaseRef: FIRDatabaseReference!
    var allKapus: [Kapu] = []
    
    init() {
        self.databaseRef = FIRDatabase.database().reference()
        //self.getKapusFromFB()
    }
    
    func getKapusFromFB(compleation:@escaping ()->()) {
        self.databaseRef.child(KAPUS).observeSingleEvent(of: .value, with: { (snapshot) in
            if let kapus = snapshot.value as? NSDictionary {
                self.parseAllKapus(kapus: kapus)
                compleation()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func parseAllKapus(kapus: NSDictionary) {
        self.allKapus = []
        
        let allKeys = kapus.allKeys
        for key in allKeys {
            if let kapu = kapus[key] as! NSDictionary? {
                let newItem = Kapu(title: kapu.value(forKey: "title") as! String,
                                   body: kapu.value(forKey: "body") as! String,
                                   categoryName: kapu.value(forKey: "categoryName") as! String,
                                   creationDate: kapu.value(forKey: "creationDate") as! String,
                                   creatorName: kapu.value(forKey: "creatorName") as! String,
                                   location: kapu.value(forKey: "location") as! NSDictionary,
                                   options: kapu.value(forKey: "options") as! NSDictionary)
                self.allKapus.append(newItem)
            }
        }
        
        print("\(allKapus)")
    }
    
    func addNew(kapu: Kapu, options: [String]) {
        let key = self.databaseRef.child(KAPUS).childByAutoId().key
        let post = ["title": kapu.title,
                    "body": kapu.body,
                    "categoryName": kapu.categoryName,
                    "creatorName": kapu.creatorName,
                    "creationDate": kapu.creationDate,
                    "location": kapu.location] as [String : Any]
        
        let childUpdates = ["/\(KAPUS)/\(key)": post]
        
        PushManager.shared.sendNewFeed(with: kapu.title, description: kapu.body, id: key)
        
        self.databaseRef.updateChildValues(childUpdates) { (error, ref) in
            
        }
        
        for option in options {
            let keyOption = self.databaseRef.child(KAPUS).child(key).child("options").childByAutoId().key
            let childUpdates = ["/\(KAPUS)/\(key)/options/\(keyOption)/": option]
            self.databaseRef.updateChildValues(childUpdates)
        }
        
    }
}
