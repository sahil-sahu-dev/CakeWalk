//
//  MainStepperView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 03/12/21.
//

import SwiftUI

struct userHealthData{
    var name: String?
    var stepsData: Step
}

class MainStepperViewModel: ObservableObject {
    
    @Published var allUserHealthData = [userHealthData]()
    
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("steps").getDocuments { healthDataDocument, error in
            
            if let error = error {
                print("Error fetching data from firestore \(error)")
                return
            }
            
            healthDataDocument?.documents.forEach { healthData in
                //let name = healthData["Name"] as! String
                let steps = healthData["Steps"] as! Int
                let uid = healthData["id"] as! UUID
                let stepData = Step(id: uid, count: steps)
                
                self.allUserHealthData.append(userHealthData(stepsData: stepData))
            }
            
        }
    }
    
    
}




