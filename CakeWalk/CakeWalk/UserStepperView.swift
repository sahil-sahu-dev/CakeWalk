//
//  MainStepperView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import SwiftUI
import HealthKit

struct UserStepperView: View {
    
    
    var healthStore: HealthStore?
    @EnvironmentObject var stepCounterDocument: StepCounterDocument
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(.init(white: 0, alpha: 0.15)).edgesIgnoringSafeArea(.all)
                ScrollView {
                    
                VStack{
                    Text("\(stepCounterDocument.getStepsCount() ?? 0)")
                    GraphView()
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
    
                            }
    
                        }
                    }
                }
                
            }
                
            }
            .navigationTitle("Your steps data")
    }
}

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserStepperView()
    }
}
