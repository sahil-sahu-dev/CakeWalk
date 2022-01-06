//
//  UserStepperViewModel.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 01/01/22.
//

import Foundation
import HealthKit


class UserStepperViewModel: ObservableObject {
    
    @Published var currentUser: StepUser?
    @Published var isUserCurrentlyLoggedOut: Bool 
    @Published var errorMessage = ""
    
    var startDate: Date
    var endDate: Date
    
    init() {
        self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil ? true : false
        self.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        self.endDate = Date()
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
            let count = data["count"] as? Double ?? 0
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
        self.isUserCurrentlyLoggedOut = true
    }
    
    
    public func getStepsCount() -> Int {
        if isUserCurrentlyLoggedOut {
            return 0
        }
        
        return Int(currentUser?.count ?? 0)
    }
    
    
    
    public func updateSteps(with statisticsCollection: HKStatisticsCollection) {
        
        if !isUserCurrentlyLoggedOut {
            
            var newCount: Double?
            
            statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in

                newCount = statistics.sumQuantity()?.doubleValue(for: .count())
            }
            
            if let newCount = newCount, let count = currentUser?.count {
                if newCount > count {
                    
                    guard let user_uid = FirebaseManager.shared.auth.currentUser?.uid else {
                        self.errorMessage = "Could not find user uid"
                        return
                    }
                    
                    self.errorMessage = "\(user_uid)"
                    
                    let uid = currentUser?.uid
                    let name = currentUser?.name
                    
                    let newData = ["uid": uid ?? "none" , "count": newCount , "name": name ?? "none"] as [String : Any]
                    
                    FirebaseManager.shared.firestore.collection("users").document(user_uid).setData(newData) { error in
                        
                        if let error = error {
                            print("Error stroring health data to firestore \(error)")
                            return
                        }

                        print("Stored health data to firestore + count = \(newCount)")
                    }
                }
            }
        }
    }
    
}
