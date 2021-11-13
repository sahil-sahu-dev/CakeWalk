//
//  HealthStore.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import Foundation
import HealthKit

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore  = HKHealthStore() //if we have health data available then we create an instance of health store
        }
    }
    
    public func calculateSteps(completion: @escaping (HKStatisticsCollection) -> Void){
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day:1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .init())
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = {query, statisticsCollection, error in
            if(statisticsCollection != nil) {
                completion(statisticsCollection!)
            }
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
    }
    
    
    public func calculateActiveCaloriedBurned(completion: @escaping (HKStatisticsCollection) -> Void) {
        let calType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day:1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .init())

        query = HKStatisticsCollectionQuery.init(quantityType: calType, quantitySamplePredicate: predicate, options: .init(), anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = {query, statisticsCollection, error in
            if statisticsCollection != nil{
                
                completion(statisticsCollection!)
            }
        }

        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    
    public func calculateDistance(completion: @escaping (HKStatisticsCollection) -> Void) {
        
        let calType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day:1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .init())

        query = HKStatisticsCollectionQuery.init(quantityType: calType, quantitySamplePredicate: predicate, options: .init(), anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = {query, statisticsCollection, error in
            if statisticsCollection != nil{
                
                completion(statisticsCollection!)
            }
            
        }

        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    
    
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let calType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        guard let healthStore = self.healthStore else { return completion(false)}
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
        
        healthStore.requestAuthorization(toShare: [], read: [calType]) { (success, error) in
            completion(success)
        }
        
        healthStore.requestAuthorization(toShare: [], read: [distanceType]) { (success, error) in
            completion(success)
        }
        
    }
    
    
}
