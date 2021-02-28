//
//  Place+CoreDataProperties.swift
//  Google-Map
//
//  Created by Summit on 28/02/21.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var placeid: String?

}

extension Place : Identifiable {

}
