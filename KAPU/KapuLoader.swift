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
import FirebaseStorage
import FirebaseDatabase

let KAPUS: String = "requests"
let USERS: String = "users"

class Kapu {
    let uid: String
    let body: String
    let categoryName: String
    let creatorName: String
    let creationDate: String
    let title: String
    let location: NSDictionary
    let options: NSDictionary
    var image: UIImage?
    
    init(uid: String,
         title: String,
         body: String,
         categoryName: String,
         creationDate: String,
         creatorName: String,
         location: NSDictionary,
         options: NSDictionary,
         image: UIImage?) {
        self.uid = uid
        self.title = title
        self.body = body
        self.creatorName = creatorName
        self.creationDate = creationDate
        self.categoryName = categoryName
        self.location = location
        self.options = options
        self.image = image
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
        var i: Int = 0
        let allKeys = kapus.allKeys
        for key in allKeys {
            if let kapu = kapus[key] as! NSDictionary? {
                let newItem = Kapu(uid: key as! String,
                                   title: kapu.value(forKey: "title") as! String,
                                   body: kapu.value(forKey: "body") as! String,
                                   categoryName: kapu.value(forKey: "categoryName") as! String,
                                   creationDate: kapu.value(forKey: "creationDate") as! String,
                                   creatorName: kapu.value(forKey: "creatorName") as! String,
                                   location: kapu.value(forKey: "location") as! NSDictionary,
                                   options: kapu.value(forKey: "options") as! NSDictionary,
                                   image: nil)
               
                if let imageName = kapu.value(forKey: "image") {
                    let currentIndex = i
                    getImageFromFB(name: imageName as! String, index: currentIndex) {(imagePath, index) in
                        self.allKapus[index].image = imagePath
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KapusWereUpdated"), object: nil)
                        print("notfication update")
                    }
                }
                self.allKapus.append(newItem)
                i+=1
            }
           
        }
        
        print("\(allKapus)")
    }
    
    func addAnswer(to kapu: Kapu, authorName: String, selectedOptionName: String){
        
        let key = self.databaseRef.child(KAPUS).child(kapu.uid).child("answers").childByAutoId().key
        let answer = ["author": authorName,
                      "selectedOptionName": selectedOptionName]

        let childUpdates = ["/\(KAPUS)/\(kapu.uid)/answers/\(key)": answer]
        self.databaseRef.updateChildValues(childUpdates) { (error, ref) in
        }
    }
    
    func getImageFromFB(name: String, index: Int, completion:@escaping (_ imagePath: UIImage, _ index: Int)->()) {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let islandRef = storageRef.child("\(name)")
        
        islandRef.data(withMaxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                completion(image!, index)
            }
        }
        
    }
    
    func uploadImageToFB(imageData: Data, imageName: String, completion:@escaping (_ imageName: String)->()) {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images/\(imageName)")
        let uploadMetaData = FIRStorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        imagesRef.put(imageData, metadata: uploadMetaData) { (metadata, error) in
            if (error != nil) {
                print("Receiving unsuccessful \(error?.localizedDescription)")
            } else {
                guard let name = metadata?.path else {
                    return
                }
                completion(name)
                print("Upload complete! \(metadata)")
            }
        }
        
    }
    
    func addNew(kapu: Kapu, options: [String]) {
        let key = self.databaseRef.child(KAPUS).childByAutoId().key
        let post = ["title": kapu.title,
                    "body": kapu.body,
                    "categoryName": kapu.categoryName,
                    "creatorName": kapu.creatorName,
                    "creationDate": kapu.creationDate,
                    "location": kapu.location] as [String : Any]

        
        if let originalImage = kapu.image,
            let imageData = UIImageJPEGRepresentation(originalImage, 0.8) {
            uploadImageToFB(imageData: imageData, imageName: self.randomString(length: 14)){ (imageName) in
                let childUpdates = ["/\(KAPUS)/\(key)/image/": imageName]
                self.databaseRef.updateChildValues(childUpdates)
            }
        }
        
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
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
    
        var randomString = ""
    
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
    
        return randomString
    }
}
