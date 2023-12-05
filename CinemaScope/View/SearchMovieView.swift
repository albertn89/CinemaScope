//
//  SearchMovieView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI

struct SearchMovieView: View {
    @ObservedObject private var movieData = MovieLoader()
    
    var body: some View {
        
        SearchBar(text: self.$movieData.searchQuery, hintText: "Search movies")
            .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .padding(.horizontal)
        
        List {
            if self.movieData.movieList != nil {
                ForEach(self.movieData.movieList!) { movie in
                    NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                        VStack(alignment: .leading) {
                            Text(movie.title)
                            Text(movie.yearRelease)
                        }
                    }
                }
            }
        }
        .navigationTitle("Search Movies")
        .onAppear {
            self.movieData.ObserveSearchBar()
        }
        
    }

}


struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    let hintText: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: self.$text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let sbUI = UISearchBar(frame: .zero)
        sbUI.placeholder = hintText
        sbUI.searchBarStyle = .minimal
        sbUI.enablesReturnKeyAutomatically = false
        sbUI.backgroundImage = UIImage()
        sbUI.delegate = context.coordinator
        return sbUI
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    } 
    
}



struct SearchMovieView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMovieView()
    }
}
