//
//  Step.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import Foundation


struct Step: Identifiable {
    var id = UUID()
    let count: Int
    let date: Date
    var calories: Int
    var distance: Int
}

struct Calories: Identifiable{
    var id = UUID()
    let calories: Int
    let date: Date
}

struct Distance: Identifiable {
    var id = UUID()
    let distance: Int
    let date: Date
}


struct StepCounterModel {
    
    private var steps = [Step]()

    public mutating func setSteps(with steps: [Step]) {
        self.steps = steps
    }
    
    public func getSteps() -> [Step] {
        return steps
    }
    
    public mutating func setCalories(with calories: [Calories]) {
        
        for i in 0..<steps.count {
            if steps[i].date == calories[i].date {
                steps[i].calories = calories[i].calories
            }
        }
    }
    
    
    public mutating func setDistance(with distance: [Distance]) {
        
        for i in 0..<steps.count {
            if steps[i].date == distance[i].date {
                steps[i].distance = distance[i].distance
                
                
            }
        }
    }
    
    
}
