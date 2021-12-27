//
//  StepCounterDocument.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 13/11/21.
//

import Foundation
import HealthKit


class StepCounterDocument: ObservableObject {
    
    @Published private var stepModel = StepCounterModel()
    var startDate: Date
    var endDate: Date
    
    init() {
        self.startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        self.endDate = Date()
        
    }
    
    public func getSteps()-> Step? {
        return stepModel.getSteps()
    }
    
    public func getStepsCount() -> Int? {
        return stepModel.getStepsCount()
    }
    
    
    
    public func updateSteps(with statisticsCollection: HKStatisticsCollection) {
        
        var newSteps: Step = Step(count: 1)
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0))
            newSteps = step

        }
        
        //set steps with updated steps
        stepModel.setSteps(with: newSteps)
        
        let document = FirebaseManager.shared.firestore.collection("steps").document()
        let numberOfSteps = FirebaseManager.shared.firestore.collection("steps").accessibilityElementCount()
        
        print(numberOfSteps)
        if let stepsCount = stepModel.getStepsCount(), let id = stepModel.getId() {
            
            let healthData = ["Steps": stepsCount , "id": id.uuidString] as [String : Any]
            
            document.setData(healthData) { error in
                if let error = error{
                    print("Error stroring health data to firestore \(error)")
                    return
                }
                
                print("Stored health data to firestore")
            }
        }
    }
    
    
}
