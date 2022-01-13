//
//  AllUsersView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 05/01/22.
//

import SwiftUI

struct AllUsersView: View {
    
    
    @EnvironmentObject var allUsersViewModel: AllUsersViewModel
    @State var isFetchingData = false
    @State var shouldShowLogOutOptions = false
    
    
    var healthStore: HealthStore?
    init(healthStore: HealthStore) {
        self.healthStore = healthStore
    }
    
    
    
    
    var body: some View {
        NavigationView {
            
            VStack{
                
                if self.isFetchingData {
                    ProgressView()
                }
                else{
                    GeometryReader{ geometry in
                        ScrollView{
                            
                            BarChart(title: "Friends", legend: "", barColor: Color.orange, data: allUsersViewModel.chartData, x: geometry.size.width, y: geometry.size.height).padding()
                            
                            Text("👟 Your Steps: \(Int(allUsersViewModel.currentUserCount))")
                                .padding()
                            if let pos = allUsersViewModel.allUsers.firstPositionMatching(id: FirebaseManager.shared.auth.currentUser!.uid , in : allUsersViewModel.allUsers) {
                                Text("You are ranked #\(pos)")
                            }
                                                        
                            Divider().padding()
                            
                            
                            VStack{
                                ForEach(0..<allUsersViewModel.allUsers.count, id: \.self){ index in
                                    
                                    
                                    VStack{
                                        
                                        Text("#\(index+1). \(allUsersViewModel.allUsers[index].name)").padding()
                                        Divider()
                                        Text("👟 \(Int(allUsersViewModel.allUsers[index].count ?? 0))").padding()
                                    }.background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white).shadow(radius: 3))
                                        .frame(maxWidth: geometry.size.width * 0.6, maxHeight: geometry.size.height * 0.3)
                                }
                            }
                            .padding()
                            .frame(width: geometry.size.width)
                            
                        }
                    }
                }
                
            }
            
            .background(Color(.init(white: 0, alpha: 0.05)).edgesIgnoringSafeArea(.all))
            
            .navigationBarTitle("CakeWalk").font(.headline)
            
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
            
            
        }
        
        .onAppear {
            initializeViews()
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
    
    
    func initializeViews() {
        
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization{ success in
                
                if success {
                    healthStore.calculateSteps { statistics in
                        
                        DispatchQueue.main.sync {
                            
                            self.isFetchingData.toggle()
                            
                            allUsersViewModel.updateSteps(with: statistics)
                            allUsersViewModel.fetchAllUsers()
                            
                            self.isFetchingData.toggle()
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
        
    }
}
