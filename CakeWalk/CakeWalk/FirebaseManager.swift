//
//  FirebaseManager.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 27/11/21.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    static let shared = FirebaseManager()
    let firestore: Firestore
    
   override init() {
        //FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
