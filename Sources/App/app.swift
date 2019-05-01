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

/// Creates an instance of `Application`. This is called from `main.swift` in the run target.
public func app(_ env: Environment) throws -> Application {
    var config = Config.default()
    var env = env
    var services = Services.default()
    try configure(&config, &env, &services)
    let app = try Application(config: config, environment: env, services: services)
    try boot(app)
    return app
}
