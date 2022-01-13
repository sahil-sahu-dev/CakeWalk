//
//  Array+firstPositionMatching.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 13/01/22.
//

import Foundation

extension Array {
    
    func firstPositionMatching(id: String, in arr: [StepUser]) -> Int? {
        var count = 1
        for element in arr {
            if element.uid == id {
                return count
            }
            count+=1
        }
        
        return nil
    }
}
