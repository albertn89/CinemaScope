//
//  AccountAuth.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import Foundation
import FirebaseAuth

class AccountAuth: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var loggedIn = false
    @Published var invalidLogin: String?
    
    var isLoggedIn: Bool {
        return auth.currentUser != nil
    }
    
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.invalidLogin = error?.localizedDescription
                return
            }
            
            DispatchQueue.main.async {
                self?.loggedIn = true
                self?.invalidLogin = nil
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail:email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.loggedIn = true
            }
        }
    }
    
    func resetPassword(email: String) {
        auth.sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                return
            }
        }
    }
     
    func logout() {
        try? auth.signOut()
        self.loggedIn = false
    }
    
}
