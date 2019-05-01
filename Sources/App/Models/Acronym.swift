/*
 * Copyright (c) 2019 Razeware LLC, Brick Water Studios L.L.C.
 *
 * TILApp
 *
 * Based on the TILApp from RayWinderlich 'Server Side Swift with Vapor'
 * book, modified by Brick Water Studios for use in their Julieanne server
 * technology. Original copyright Razeware LLC, modified application
 * copyright Brick Water Studios L.L.C.
 *
 */

import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    var userID: User.ID
    
    init(short: String, long: String, userID: User.ID) {
        self.short = short
        self.long = long
        self.userID = userID
    }
}

extension Acronym {
    var user: Parent<Acronym, User> {
        return parent(\.userID)
    }
    
    var categories: Siblings<Acronym, Category, AcronymCategoryPivot> {
        return siblings()
    }
}
extension Acronym: PostgreSQLModel {}
extension Acronym: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
extension Acronym: Content {}
extension Acronym: Parameter {}
