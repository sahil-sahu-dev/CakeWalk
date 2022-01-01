//
//  LoginView.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 08/12/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View{
   
    @State private var isLoginMode = false
   @State private var email = ""
   @State private var password = ""
    @State private var name = ""

   var body: some View {
       NavigationView {
           
               VStack {
                   Text(name)
                   Spacer()
                   Button {
                       handleAction()
                   } label: {
                       HStack {
                           Spacer()
                           Text("Login with Google")
                               .foregroundColor(.white)
                               .padding(.vertical, 10)
                               .font(.system(size: 14, weight: .semibold))
                           Spacer()
                       }.background(Color.blue)
                       
                   }
                   
                   Spacer()
                   
               }
               .padding()
               
           
           .navigationTitle("Login")
           .background(Color(.init(white: 0, alpha: 0.05))
                           .ignoresSafeArea())
       }
       .navigationViewStyle(StackNavigationViewStyle())
       
   }
    
    
    private func handleAction() {
        guard let clientId = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting : getRootViewController()) {[self] user, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            FirebaseManager.shared.auth.signIn(with: credential) { result, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    print("unable to get the user")
                    return
                }
                
                self.name = user.displayName ?? "name"
                print(user.displayName ?? "Success")
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


extension View {
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes
                .first as? UIWindowScene else {
                    return .init()
                }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
