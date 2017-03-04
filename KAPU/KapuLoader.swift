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

class Kapu {
    let body: String
    let categoryName: String
    let creatorName: String
    let creationDate: String
    let title: String
    
    init(title: String, body: String, categoryName: String, creationDate: String, creatorName: String) {
        self.title = title
        self.body = body
        self.creatorName = creatorName
        self.creationDate = creationDate
        self.categoryName = categoryName
    }
}

class KapuLoader {
    var databaseRef: FIRDatabaseReference!
    var allKapus: [Kapu] = []
    
    init() {
        self.databaseRef = FIRDatabase.database().reference()
        self.getKapusFromFB()
    }
    
    private func getKapusFromFB() {
        self.databaseRef.child(KAPUS).observeSingleEvent(of: .value, with: { (snapshot) in
            if let kapus = snapshot.value as? NSDictionary {
                self.parseAllKapus(kapus: kapus)
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
                                   creatorName: kapu.value(forKey: "creatorName") as! String)
                self.allKapus.append(newItem)
            }
        }
        
        print("\(allKapus)")
    }
}
