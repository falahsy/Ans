//
//  AnimalEntity+CoreDataProperties.swift
//  
//
//  Created by Syamsul Falah on 19/10/23.
//
//

import Foundation
import CoreData


extension AnimalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnimalEntity> {
        return NSFetchRequest<AnimalEntity>(entityName: "AnimalEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var liked: Bool
    @NSManaged public var species: String?
    @NSManaged public var family: String?
    @NSManaged public var src: String?
    @NSManaged public var id: Int32

}

extension AnimalEntity: Identifiable {}
