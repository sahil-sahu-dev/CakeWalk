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
    
}


struct StepCounterModel {
    
    private var steps: Step?

    public mutating func setSteps(with steps: Step) {
        self.steps = steps
    }
    
    public func getSteps() -> Step? {
        return steps
    }
    
    public func getId() -> UUID? {
        if let step = steps {
            return step.id
        }
        return nil
    }
    
    public func getStepsCount() -> Int? {
        return steps?.count
    }
    
    
}
