//
//  CarouselView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 4/18/23.
//

import SwiftUI

struct PosterCarouselView: View {
    let title: String
    let movieCarousel: [MovieModel]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 15) {
                    ForEach(self.movieCarousel) { movie in
                        NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                            SinglePoster(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                    }
                }
                .padding(.horizontal)
            }
            
        }
    }
}


struct SinglePoster: View {
    @ObservedObject var imgLoader = LoadImage()
    let movie: MovieModel
        
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                if self.imgLoader.bgImage != nil {
                    Image(uiImage: self.imgLoader.bgImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    Text(movie.title)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 204, height: 306)
            .cornerRadius(10)
            .shadow(radius: 3)
            
        }
        .lineLimit(1)
        .onAppear {
            self.imgLoader.loadImg(with: self.movie.posterURL)
        }
    }
}




struct BackdropCarouselView: View {
    let title: String
    let movieCarousel: [MovieModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 15) {
                    ForEach(self.movieCarousel) { movie in
                        NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                            SingleBackdrop(movie: movie)
                                .frame(width: 272, height: 200)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            
        }
    }
}


struct SingleBackdrop: View {
    @ObservedObject var imgLoader = LoadImage()
    let movie: MovieModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                if self.imgLoader.bgImage != nil {
                    Image(uiImage: self.imgLoader.bgImage!)
                        .resizable()
                }
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(10)
            .shadow(radius: 3)
            
            Text(movie.title)
        }
        .lineLimit(1)
        .onAppear {
            self.imgLoader.loadImg(with: self.movie.backdropURL)
        }
    }
}


