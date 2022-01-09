//
//  AllUsersViewModel.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 05/01/22.
//

import Foundation
import HealthKit


class AllUsersViewModel: ObservableObject {
    
    @Published var allUsers = [StepUser]()
    @Published var errorMessage = ""
    @Published var currentUser: StepUser?
    @Published var isUserCurrentlyLoggedOut: Bool
    @Published var chartData = [ChartData]()
    
    var startDate: Date
    var endDate: Date
    
    
    init() {
        self.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        self.endDate = Date()
        self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil ? true : false
        
    }
    
    public func fetchAllUsers(completion: @escaping () -> Void) {
        
        allUsers.removeAll()
        chartData.removeAll()
        
        FirebaseManager.shared.firestore.collection("users").getDocuments { healthDataDocument, error in
            
            if let error = error {
                print("Error fetching data from firestore \(error)")
                self.errorMessage = error.localizedDescription
                return
            }
            
            healthDataDocument?.documents.forEach { healthData in
                
                
                let name = healthData["name"] as? String ?? ""
                let count = healthData["count"] as? Double ?? 0
                let uid = healthData["uid"] as? String ?? ""
                
                if(FirebaseManager.shared.auth.currentUser?.uid == uid) {
                    self.currentUser?.uid = uid
                    self.currentUser?.name = name
                    self.currentUser?.count = count
                }
                
                
                let stepData = StepUser(uid: uid,count: count, name: name)
                
                self.allUsers.append(stepData)
                self.chartData.append(ChartData(label: name, value: count))
                
            }
            
        }
        
        completion()
    }
    
    
    
    public func updateSteps(with statisticsCollection: HKStatisticsCollection) {
        
        if !isUserCurrentlyLoggedOut {
            
            var newCount: Double?
            
            statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                
                newCount = statistics.sumQuantity()?.doubleValue(for: .count())
            }
            
            guard let user_uid = FirebaseManager.shared.auth.currentUser?.uid else {
                self.errorMessage = "Could not find user uid"
                return
            }
            
            self.errorMessage = "\(user_uid)"
            
            let uid = FirebaseManager.shared.auth.currentUser?.uid
            let name = FirebaseManager.shared.auth.currentUser?.displayName
            
            let newData = ["uid": uid ?? "none" , "count": newCount ?? 0 , "name": name ?? "none"] as [String : Any]
            
            FirebaseManager.shared.firestore.collection("users").document(user_uid).setData(newData) { error in
                
                if let error = error {
                    print("Error stroring health data to firestore \(error)")
                    return
                }
                
                print("Stored health data to firestore + count = \(String(describing: newCount))")
            }
        }
        
        
    }




public func getStepsCount() -> Int {
    if isUserCurrentlyLoggedOut {
        return 0
    }
    
    return Int(currentUser?.count ?? 0)
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




}
