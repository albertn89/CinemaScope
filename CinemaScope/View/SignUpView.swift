//
//  SignUpView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var accAuth: AccountAuth
    
    @State var email: String = ""
    @State var password: String = ""
    @State var rePassword: String = ""
    @State var passMatch = false
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 25)
            
            inputFields
            
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 30)
            
        
            if passMatch {
                Text("Passwords must match")
                    .foregroundColor(.red)
                    .padding(.top)
            } else if password.count < 6 {
                Text("Password must be at least 6 characters")
                    .foregroundColor(.red)
                    .padding(.top)
            }
            
            Spacer()
            
            HStack {
                Text("Have an account already?")
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Login")
                })
                Text("here")
            }
            
            
            Spacer()
            signupButton
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 40)
            
        }
        .navigationTitle("Sign Up")
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
            
            SecureField("Enter Password", text: $password)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .foregroundColor(.black)
            
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 14)
            
            HStack {
                Text("Re-enter Password:")
                    .font(.headline)
                Spacer()
            }
            
            SecureField("Re-enter Your Password", text: $rePassword)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .foregroundColor(.black)
            
        }
    }
    
    var signupButton: some View {
        Button(action: {
            guard !email.isEmpty, !password.isEmpty, !rePassword.isEmpty else {
                return
            }
            if password == rePassword {
                if password.count >= 6 {
                    accAuth.signUp(email: email, password: password)
                } else {
                    passMatch = false
                }
            } else {
                passMatch = true
            }
        }, label: {
            Text("Create Account")
                .padding()
                .frame(width: 300, height: 50)
                .background(Color(red: 0.117, green: 0.733, blue: 0.843))
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.system(size: 22))
            
        })
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AccountAuth())
    }
}
