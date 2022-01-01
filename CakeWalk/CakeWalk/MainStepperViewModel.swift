//
//  MainStepperViewModel.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 01/01/22.
//

import Foundation



class MainStepperViewModel: ObservableObject {
    
    @Published var allUserHealthData = [StepUser]()
    @Published var errorMessage = ""
    
    
    init() {
        
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("steps").getDocuments { healthDataDocument, error in
            
            if let error = error {
                print("Error fetching data from firestore \(error)")
                self.errorMessage = error.localizedDescription
                return
            }
            
            healthDataDocument?.documents.forEach { healthData in
                let name = healthData["Name"] as? String ?? ""
                let steps = healthData["Steps"] as? Int ?? 0
                let uid = healthData["id"] as? String ?? ""
                let stepData = StepUser(uid: uid,count: steps, name: name)
                
                self.allUserHealthData.append(stepData)
            }
            
        }
    }
    
    
        
    
}
