//
//  CakeWalkApp.swift
//  CakeWalk
//
//  Created by Sahil Sahu on 09/11/21.
//

import SwiftUI
import GoogleSignIn
import Firebase

@main
struct CakeWalkApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    
    var body: some Scene {
        WindowGroup {
            MainStepperView().environmentObject(UserStepperViewModel())
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    
    
   func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
       return GIDSignIn.sharedInstance.handle(url)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
