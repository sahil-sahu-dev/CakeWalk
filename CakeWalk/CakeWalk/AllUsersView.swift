//
//  AllUsersView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 05/01/22.
//

import SwiftUI

struct AllUsersView: View {
    
    @EnvironmentObject var userStepperViewModel: UserStepperViewModel
    @EnvironmentObject var allUsersViewModel: AllUsersViewModel
    var healthStore: HealthStore?
    
    init(healthStore: HealthStore) {
        self.healthStore = healthStore
    }
    
    @State var shouldShowLogOutOptions = false
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                BarChart(title: "", legend: "", barColor: Color.orange, data: allUsersViewModel.chartData)
                
                //                List(allUsersViewModel.allUsers){ user in
                //                    VStack{
                //                        Text(user.name).padding()
                //                        Text(String(user.count ?? 0)).padding()
                //                    }.background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white).shadow(radius: 3))
                //
                //
                //                }
                
                
            }
            
            .onAppear {
                initializeViews()
            }
            
            .navigationBarTitle("Home")
            
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
                        
                        allUsersViewModel.handleSignOut()
                        
                        print("handle sign out")
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $allUsersViewModel.isUserCurrentlyLoggedOut, onDismiss: nil) {
                LoginView {
                    
                    self.initializeViews()
                    self.allUsersViewModel.isUserCurrentlyLoggedOut = false
                    
                }
            }
        }
    }
    
    
    func initializeViews() {
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization{ success in
                
                if success {
                    healthStore.calculateSteps { statistics in
                        
                        DispatchQueue.main.sync {
                            allUsersViewModel.updateSteps(with: statistics)
                            
                            allUsersViewModel.fetchAllUsers() {
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
    }
}

struct AllUsersView_Previews: PreviewProvider {
    static var previews: some View {
        AllUsersView(healthStore: HealthStore())
            .environmentObject(AllUsersViewModel())
            .environmentObject(UserStepperViewModel())
    }
}
