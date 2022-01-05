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
    @EnvironmentObject var userStepperViewModel: UserStepperViewModel
    @State var shouldShowLogOutOptions = false
    
    var isLoggedIn: Bool {
        FirebaseManager.shared.auth.currentUser == nil ? false : true
    }
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(.init(white: 0, alpha: 0.15)).edgesIgnoringSafeArea(.all)
                ScrollView {
                    
                    VStack{
                        Text("\(userStepperViewModel.getStepsCount())")
                        GraphView()
                    }
                    
                    
                    .padding()
                    .onAppear {
                        if let healthStore = healthStore {
                            healthStore.requestAuthorization{ success in
                                
                                if success {
                                    healthStore.calculateSteps { statistics in
                                        
                                        DispatchQueue.main.async {
                                            userStepperViewModel.updateSteps(with: statistics)
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Your steps data")
            .toolbar {
                ToolbarItem {
                    Button {
                        shouldShowLogOutOptions.toggle()
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(.label))
                    }
                }
            }
            .actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        
                        userStepperViewModel.handleSignOut()
                        
                        print("handle sign out")
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $userStepperViewModel.isUserCurrentlyLoggedOut, onDismiss: nil) {
                LoginView {
                    
                    userStepperViewModel.fetchCurrentUser()
                    self.userStepperViewModel.isUserCurrentlyLoggedOut = false
                    
                }
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserStepperView()
    }
}
