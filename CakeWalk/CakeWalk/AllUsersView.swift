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
    
    @State var shouldShowLogOutOptions = false
  
    
    var body: some View {
        NavigationView {
            
            List(allUsersViewModel.allUsers) { user in
                HStack{
                    
                    Text(user.name)
                    
                }
            }
            
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

struct AllUsersView_Previews: PreviewProvider {
    static var previews: some View {
        AllUsersView()
    }
}
