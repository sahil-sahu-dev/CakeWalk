//
//  ContentView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    
    var healthStore: HealthStore?
    @ObservedObject var stepCounterDocument: StepCounterDocument
    
    var body: some View {
        
        List(stepCounterDocument.getSteps(), id: \.id) {step in
            VStack(alignment: .leading){
                Text("\(step.count)")
                Text("\(step.distance)")
                Text(step.date,style: .date).opacity(0.5)
            }
            
        }
        .padding()
        .onAppear {
            if let healthStore = healthStore {
                healthStore.requestAuthorization{ success in
                    
                    if success {
                        healthStore.calculateSteps {statistics in
                            DispatchQueue.main.async {
                                stepCounterDocument.updateSteps(with: statistics)
                            }
                            
                            
                        }
                        healthStore.calculateActiveCaloriedBurned { statistics in
                            DispatchQueue.main.async {
                                stepCounterDocument.updateCalories(with: statistics)
                            }
                        }
                        
                        healthStore.calculateDistance { statistics in
                            DispatchQueue.main.async {
                                stepCounterDocument.updateDistance(with: statistics)
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
}





//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
