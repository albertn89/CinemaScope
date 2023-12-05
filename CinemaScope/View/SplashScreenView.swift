//
//  SplashScreenView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        if isActive {
            HomeView().environmentObject(AccountAuth())
        } else {
            VStack{
                dispLogo
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
        
    }
    
    
    var dispLogo: some View {
        VStack{
            Image("cs-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .opacity(0.8)
            Image("cs-text")
                .resizable()
                .scaledToFit()
                .frame(width: 360)
                .opacity(0.8)
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.size = 0.9
                self.opacity = 1.0
            }
        }
    }
    
    
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView().environmentObject(AccountAuth())
    }
}
