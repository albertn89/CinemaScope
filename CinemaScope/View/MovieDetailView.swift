//
//  MovieDetailView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject private var movieDetails = MovieLoader()
    @ObservedObject private var imgLoader = LoadImage()
    let movieID: Int

    var body: some View {
        VStack {
            if movieDetails.movie != nil {
                List {
                    ZStack {
                        Rectangle().fill(Color.gray.opacity(0.3))
                        
                        if self.imgLoader.bgImage != nil {
                            Image(uiImage: self.imgLoader.bgImage!)
                                .resizable()
                        }
                    }
                    .aspectRatio(16/9, contentMode: .fit)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        self.imgLoader.loadImg(with: self.movieDetails.movie!.backdropURL)
                    }
                    
                    HStack {
                        Text(movieDetails.movie!.movieGenre)
                        Text("·")
                        Text(movieDetails.movie!.yearRelease)
                        Spacer()
                        
                        
                        Text("Rating: ")
                            .font(.headline)
                        
                        Text(movieDetails.movie!.movieRating)
                            
                     
                    }
                    
                    HStack {
                        Text("Duration: ")
                            .font(.headline)
                        
                        Text(movieDetails.movie!.movieDuration)
                        
                    }
                    
                    VStack {
                        HStack {
                            Text("Overview")
                                .font(.headline)
                         
                            Spacer()
                        }
                        
                        Rectangle()
                            .fill(Color.red.opacity(0.0))
                            .frame(width: 100, height: 5)
                        
                        Text(movieDetails.movie!.overview)
                    }
                    
 
                    creds
                    
                }
            }
        }
        .navigationBarTitle(movieDetails.movie?.title ?? "")
        .onAppear {
            self.movieDetails.loadMovieDetails(with: self.movieID)
        }
    }
    
    
    var creds: some View {
        HStack(alignment: .top, spacing: 4) {
            
            if (movieDetails.movie!.cast != nil && movieDetails.movie!.cast!.count > 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Casts")
                        .font(.headline)
                    
                    ForEach(self.movieDetails.movie!.cast!.prefix(8)) { cast in
                        Text(cast.name)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                
            }
            
            if (movieDetails.movie!.crew != nil && movieDetails.movie!.crew!.count > 0) {
                VStack(alignment: .leading, spacing: 4) {
                    
                    if (movieDetails.movie!.directors != nil && movieDetails.movie!.directors!.count > 0) {
                        Text("Director(s)")
                            .font(.headline)
                        
                        ForEach(self.movieDetails.movie!.directors!.prefix(2)) {
                            crew in
                            Text(crew.name)
                            
                        }
                    }
                    
                    if (movieDetails.movie!.producers != nil && movieDetails.movie!.producers!.count > 0) {
                        Text("Producer(s)")
                            .padding(.top)
                            .font(.headline)
                        
                        ForEach(self.movieDetails.movie!.producers!.prefix(2)) {
                            crew in
                            Text(crew.name)
                            
                        }
                    }
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            
        }
    }
    
}

