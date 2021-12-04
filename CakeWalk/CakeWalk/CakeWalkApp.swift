//
//  CakeWalkApp.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import SwiftUI

@main
struct CakeWalkApp: App {
    var body: some Scene {
        WindowGroup {
            UserStepperView(healthStore: HealthStore())
                .environmentObject(StepCounterDocument())
        }
    }
}
