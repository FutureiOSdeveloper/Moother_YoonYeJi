//
//  Location+CoreDataProperties.swift
//  
//
//  Created by 윤예지 on 2021/08/17.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: NSObject?
    @NSManaged public var latitude: NSObject?
    @NSManaged public var longtitude: NSObject?

}
