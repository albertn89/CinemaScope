//
//  ResetPasswordView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 4/22/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var accAuth: AccountAuth
    @State var showAlert = false
    @State var email: String = ""

    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 25)
            
            inputFields
            
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 30)
            
            
            
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
            resetPasswordButton
            
            Rectangle()
                .fill(Color.red.opacity(0.0))
                .frame(width: 100, height: 40)
            
        }
        .navigationTitle("Reset Password")
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
            

            
        }
    }
    
    var resetPasswordButton: some View {
        Button(action: {
            guard !email.isEmpty else {
                showAlert = true
                return
            }
            accAuth.resetPassword(email: email)
            showAlert = true
        }, label: {
            Text("Reset Password")
                .padding()
                .frame(width: 300, height: 50)
                .background(Color(red: 0.117, green: 0.733, blue: 0.843))
                .cornerRadius(10)
                .foregroundColor(.white)
                .font(.system(size: 22))
            
        })
        .alert("Reset Password", isPresented: $showAlert, actions: {
            Button("Close", role: .cancel, action: {
                showAlert = false
            })
        }, message: {
            Text(email.isEmpty ? "Please enter a your email." : "If an account exist, a password reset link will be sent to you.")
        })
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView().environmentObject(AccountAuth())
    }
}
