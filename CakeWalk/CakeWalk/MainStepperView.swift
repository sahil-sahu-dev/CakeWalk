//
//  MainStepperView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 03/12/21.
//

import SwiftUI

struct MainStepperView: View {
    
    @EnvironmentObject var userStepperViewModel: UserStepperViewModel
    
    var body: some View {
        TabView{
            AllUsersView(healthStore: HealthStore())
                .environmentObject(AllUsersViewModel())
               
                .tabItem {
                    Image(systemName: "house.fill")
                }
            UserStepperView()
              
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
    }
}

struct MainStepperView_Previews: PreviewProvider {
    static var previews: some View {
        MainStepperView().environmentObject(UserStepperViewModel())
    }
}




