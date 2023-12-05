//
//  AccountView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @EnvironmentObject var accAuth: AccountAuth
    @State var user: User?
    
    var body: some View {
        VStack {
            
            Rectangle()
                .fill(Color.gray.opacity(0.0))
                .frame(width: 200, height: 20)
            
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
            
            Spacer()
            
            HStack {
                Text("Email: ")
                
                if let user = user, let email = user.email {
                    Text(email)
                } else {
                    Text("N/A")
                }
                
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                accAuth.logout()
            }, label: {
                Text("Log Out")
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(red: 0.117, green: 0.733, blue: 0.843))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                
            })
            
            
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 20)
            
        }
        .navigationTitle("Account")
        .padding()
        .onAppear {
            Auth.auth().addStateDidChangeListener {
                auth, user in
                if let user = user {
                    self.user = user
                } else {
                    self.user = nil
                }
            }
        }

    }
    
    
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(AccountAuth())
    }
}
