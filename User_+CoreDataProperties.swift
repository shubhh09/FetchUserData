//
//  User_+CoreDataProperties.swift
//  ShubhamLodhi_MT
//
//  Created by SHUBHAM on 21/11/24.
//
//

import Foundation
import CoreData


extension User_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User_> {
        return NSFetchRequest<User_>(entityName: "User_")
    }

    @NSManaged public var id: Int32
    @NSManaged public var email: String?
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var avatar: String?
    @NSManaged public var isFavorite: Bool

}

extension User_ : Identifiable {

}
