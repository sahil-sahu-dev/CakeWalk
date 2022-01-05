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

        FirebaseManager.shared.firestore.collection("users").getDocuments { healthDataDocument, error in

            if let error = error {
                print("Error fetching data from firestore \(error)")
                self.errorMessage = error.localizedDescription
                return
            }

            healthDataDocument?.documents.forEach { healthData in
                
                let name = healthData["name"] as? String ?? ""
                let steps = healthData["steps"] as? Double ?? 0
                let uid = healthData["uid"] as? String ?? ""
                
                let stepData = StepUser(uid: uid,count: steps, name: name)

                self.allUserHealthData.append(stepData)
            }

        }
    }
    
    
        
    
}
