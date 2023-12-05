//
//  HomeView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var accAuth: AccountAuth
    @ObservedObject private var nowPlayingList = MovieLoader()
    @ObservedObject private var upcomingList = MovieLoader()
    

    var body: some View {
        NavigationView {
            if accAuth.loggedIn {
                disp
            } else {
                LoginView()
            }
        }
        .onAppear {
            accAuth.loggedIn = accAuth.isLoggedIn
        }
    }
    
    var disp: some View {
        VStack {
            navBarView
            
            List {
                if let nowPlaying = nowPlayingList.movieList {
                    PosterCarouselView(title: "Now Playing", movieCarousel: nowPlaying)
                        .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .listRowSeparator(.hidden)
                }
                
                if let upcoming = upcomingList.movieList {
                    BackdropCarouselView(title: "Upcoming", movieCarousel: upcoming)
                        .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            
        }
        .navigationTitle("CinemaScope")
        .onAppear {
            self.nowPlayingList.loadMovies(with: .nowPlaying)
            self.upcomingList.loadMovies(with: .upcoming)
        }
        
    }
        
    var navBarView: some View {
        Text("")
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    HStack{
                        
                        NavigationLink(destination: SearchMovieView(), label: {
                            VStack {
                                Image(systemName: "magnifyingglass")
                                
                                Text("Search")
                            }
                        })
                        .padding()
                        
                        NavigationLink(destination: CinemaSearchView(), label: {
                            VStack {
                                Image(systemName: "video.fill")
                                Text("Cinema")
                            }
                        })
                        .padding()
                        
                        NavigationLink(destination: AccountView(), label: {
                            VStack {
                                Image(systemName: "person.circle")
                                Text("Account")
                            }
                            
                        })
                        .padding()
                    }
                }
            }
    }


}

