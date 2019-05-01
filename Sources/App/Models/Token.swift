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

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

final class Token: Codable {
    var id: UUID?
    var token: String
    var userID: User.ID
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

extension Token: PostgreSQLUUIDModel {}
extension Token: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
extension Token: Content {}
extension Token {
    static func generate(for user: User) throws -> Token {
        let random = try CryptoRandom().generateData(count: 16)
        return try Token(token: random.base64EncodedString(), userID: user.requireID())
    }
}
extension Token: Authentication.Token {
    static let userIDKey: UserIDKey = \Token.userID
    typealias UserType = User
}
extension Token: BearerAuthenticatable {
    static let tokenKey: TokenKey = \Token.token
}
