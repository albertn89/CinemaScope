//
//  LoginView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var accAuth: AccountAuth
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String?
    
    var body: some View {
        
            VStack {
                Rectangle()
                    .fill(Color.red.opacity(0.0))
                    .frame(width: 100, height: 60)
                
                inputFields
                
                Rectangle()
                    .fill(Color.red.opacity(0.0))
                    .frame(width: 100, height: 3)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: ResetPasswordView(), label: {
                        Text("Forgot Password")
                            .underline()
                            .foregroundColor(.blue)
                    })
                }
                
                if let errMsg = accAuth.invalidLogin {
                    Text(errMsg)
                        .foregroundColor(.red)
                }
                
                
                Spacer()
                
                HStack {
                    Text("No Account yet?")
                    NavigationLink(destination: SignUpView(), label: {
                        Text("Sign up")
                            .underline()
                            .foregroundColor(.blue)
                    })
                    Text("here")
                }
                
                
                Spacer()
                loginButton
                Rectangle()
                    .fill(Color.red.opacity(0.0))
                    .frame(width: 100, height: 40)
                
            }
            .navigationTitle("Login")
            .padding()
            
        
    }
    
    
    var inputFields: some View {
        VStack {
            HStack {
                Text("Email:")
                    .font(.headline)
                Spacer()
            }
            
            TextField("Enter Email Address", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 14)
            
            HStack {
                Text("Password:")
                    .font(.headline)
                Spacer()
            }
            
            SecureField("Enter password", text: $password)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .foregroundColor(.black)
        }
        
    }
    
    var loginButton: some View {
        Button(action: {
            guard !email.isEmpty, !password.isEmpty else {
                errorMessage = "Please enter both email and password."
                return
            }
            
            accAuth.login(email: email, password: password)
            
        }, label: {
            Text("Login")
                .padding()
                .frame(width: 300, height: 50)
                .background(Color(red: 0.117, green: 0.733, blue: 0.843))
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.system(size: 22))
            
        })
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AccountAuth())
    }
}
