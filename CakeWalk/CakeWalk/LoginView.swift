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
    
    let didCompleteLoginProcess: () -> ()

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                Text(name)
                Spacer()
                Button {
                    
                    
                    handleAction { error, success in
                        if success == 1 {
                            self.didCompleteLoginProcess()
                        }
                    }
                   
                    
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
    
    
    private func handleAction(completion: @escaping((Error?, Int?) -> Void)) {
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
                    completion(error, 0)
                    return
                }
                
                guard let user = result?.user else {
                    print("unable to get the user")
                    completion(error, 0)
                    return
                }
                
                self.name = user.displayName ?? "name"
                print(user.displayName ?? "Success")
                completion(nil,1)
            }
            
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView {
            
        }
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
