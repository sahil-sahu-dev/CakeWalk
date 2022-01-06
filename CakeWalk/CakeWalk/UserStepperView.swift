//
//  MainStepperView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import SwiftUI
import HealthKit

struct UserStepperView: View {
    
    
   
    @EnvironmentObject var userStepperViewModel: UserStepperViewModel
    @State var shouldShowLogOutOptions = false
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(.init(white: 0, alpha: 0.05)).edgesIgnoringSafeArea(.all)
                ScrollView {
                    
                    VStack{
                        Text("\(userStepperViewModel.getStepsCount())")
                        GraphView()
                    }
                    .padding()
                }
            }
            .navigationTitle("Your steps data")
            .onAppear {
                userStepperViewModel.fetchCurrentUser()
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserStepperView().environmentObject(UserStepperViewModel())
    }
}
