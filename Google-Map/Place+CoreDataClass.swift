//
//  Place+CoreDataClass.swift
//  Google-Map
//
//  Created by Summit on 28/02/21.
//
//

import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject {
    var coordinate: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}
