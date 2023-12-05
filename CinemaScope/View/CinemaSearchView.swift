//
//  CinemaSearchView.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import SwiftUI
import MapKit

struct CinemaSearchView: View {
    @ObservedObject private var mapService = MapViewModel()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.427204, longitude: -111.939896), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @State private var searchText = ""
    @State private var cinemas = [Cinema]()
 
    var body: some View {
        VStack {
            
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: cinemas) { cinema in
                MapAnnotation(coordinate: cinema.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Image(systemName: "film")
                        .foregroundColor(.red)
                }
                
            }
            .frame(height: 220)
            .cornerRadius(10)
            .onAppear {
                mapService.checkLocServiceEnabled()
                searchCinemas()
            }
            

            searchBar
            searchButton

            
            List(cinemas) { cinema in
                HStack {
                    VStack(alignment: .leading) {
                        Text(cinema.title!)
                            .font(.headline)
                        Text(cinema.locationName!)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: cinema.coordinate))
                        mapItem.name = cinema.title
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                    }, label: {
                        Image(systemName: "arrow.turn.up.right")
                            .foregroundColor(.blue)
                            .frame(width: 30, height: 30)
                    })
                    
                }
                
            }
            
            
            
        }
        .padding()
        .navigationTitle("Cinema Search")
    }
    
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for cinemas", text: $searchText)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.gray.opacity(0.3).cornerRadius(10))
        .foregroundColor(.black)
    }
    
    var searchButton: some View {
        Button(action: {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchText) {
                (placemarks, error) in
                guard let placemark = placemarks?.first else {
                    return
                }
                
                region = MKCoordinateRegion(center: placemark.location?.coordinate ?? region.center, span: region.span)
                searchCinemas()
            }
        }, label: {
            Text("Search Cinemas")
                .padding()
                .frame(width: 220, height: 40)
                .background(Color(red: 0.117, green: 0.733, blue: 0.843))
                .cornerRadius(10)
                .foregroundColor(.white)
            
        })
    }
    
    
    func searchCinemas() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "cinema"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                return
            }
            
            let cinemas = response.mapItems.map { item -> Cinema in
                let cinema = Cinema(title: item.name, locationName: item.placemark.title, coordinate: item.placemark.coordinate)
                return cinema
            }
            
            self.cinemas = cinemas
        }
    }
    
    
}






struct CinemaSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CinemaSearchView()
    }
}
