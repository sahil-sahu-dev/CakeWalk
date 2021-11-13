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
        self.startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        self.endDate = Date()
        
    }
    
    public func setSteps(steps: [Step]) {
        stepModel.setSteps(with: steps)
    }
    
    public func getSteps()->[Step] {
        return stepModel.getSteps()
    }
    
    public func setCalories(calories: [Calories]) {
        stepModel.setCalories(with: calories)
    }
    
    public func setDistance(with distance: [Distance]) {
        stepModel.setDistance(with: distance)
    }
    
    
    
    
    public func updateSteps(with statisticsCollection: HKStatisticsCollection) {
        
        var newSteps = [Step]()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate, calories: 0, distance: 0)
            newSteps.append(step)

        }
        
        //set steps with updated steps
        setSteps(steps: newSteps)
        
    }
    
    
    public func updateCalories(with statisticsCollection: HKStatisticsCollection) {
        
        var newCalories = [Calories]()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let calories = Calories(calories: Int(count ?? 0), date: statistics.startDate)
            newCalories.append(calories)
        }
        
        setCalories(calories: newCalories)
        
    }
    
    
    public func updateDistance(with statisticsCollection: HKStatisticsCollection) {
        
        var newDistance = [Distance]()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            //let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let count = statistics.sumQuantity()?.doubleValue(for: .meter())
            let distance = Distance(distance: Int(count ?? 0), date: statistics.startDate)
            newDistance.append(distance)
        }
        
        //set new distance
        setDistance(with: newDistance)
        
        
    }
    
}
