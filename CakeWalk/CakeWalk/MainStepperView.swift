//
//  MainStepperView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 03/12/21.
//

import SwiftUI

struct MainStepperView: View {
    
    
    var body: some View {
        TabView{
            AllUsersView(healthStore: HealthStore())
                .environmentObject(AllUsersViewModel())
               
                .tabItem {
                    Image(systemName: "house.fill")
                }
        }
    }
}

struct MainStepperView_Previews: PreviewProvider {
    static var previews: some View {
        MainStepperView()
    }
}




