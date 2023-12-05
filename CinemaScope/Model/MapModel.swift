//
//  MapModel.swift
//  CinemaScope
//
//  Created by Albert Negoro on 4/21/23.
//

import Foundation
import MapKit

class Cinema: NSObject, MKAnnotation, Identifiable {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}
