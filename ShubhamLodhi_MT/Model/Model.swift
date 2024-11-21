//
//  Model.swift
//  ShubhamLodhi_MT
//
//  Created by SHUBHAM on 21/11/24.
//

import Foundation
import ObjectMapper

//MARK: - Model(s)
//MARK:-
struct UserData: Mappable {
    var id: Int?
    var email: String?
    var first_name: String?
    var last_name: String?
    var avatar: String?
    var favorite: Bool?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        email       <- map["email"]
        first_name       <- map["first_name"]
        last_name <- map["last_name"]
        avatar    <- map["avatar"]
        favorite    <- map["favorite"]
    }
}
