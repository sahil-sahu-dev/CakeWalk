//
//  UserStepperViewModel.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 01/01/22.
//

import Foundation


class UserStepperViewModel: ObservableObject {
    
    @Published var currentUser: StepUser?
    @Published var isUserCurrentlyLoggedOut: Bool
    @Published var errorMessage = ""
    
    init() {
        self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil ? true : false
    }
    
    public func fetchCurrentUser() {
        
        guard let user_uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find user uid"
            return
        }
        
        self.errorMessage = "\(user_uid)"
        
        FirebaseManager.shared.firestore.collection("users").document(user_uid).getDocument { snapshot, error in
            
            if let error = error {
                self.errorMessage = "Could not fetch user data \(error)"
                return
            }
            
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
            self.errorMessage = "Data: \(data.description)"
            
            let uid = data["uid"] as? String ?? ""
            let count = data["count"] as? Int ?? 0
            let name = data["name"]  as? String ?? ""
            
            self.currentUser = StepUser(uid: uid, count: count, name: name)
            
        }
        
        
    }
    
    public func handleSignOut() {
        do{
            try FirebaseManager.shared.auth.signOut()
        }
        catch{
            self.errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
               
        self.currentUser = nil
        self.isUserCurrentlyLoggedOut.toggle()
    }
    
}
