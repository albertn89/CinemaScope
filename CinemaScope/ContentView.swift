//
//  ContentView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var accAuth: AccountAuth
    
    var body: some View {
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AccountAuth())
    }
}
