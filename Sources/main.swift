//
//  main.swift
//  PerfectPress
//
//  Created by Ryan Collins on 6/9/16.
//  Copyright (C) 2016 Ryan M. Collins.
//
//===----------------------------------------------------------------------===//
//
// This source file has been modified from the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import SQLite

// Initialize base-level services
PerfectServer.initializeServices()

// Create webroot
let webRoot = "./webroot"
try Dir(webRoot).create()

addIndexHandlerRoutes()
Config().createDatabase()

do {
    
    // Launch the HTTP server on port 8181
    try HTTPServer(documentRoot: webRoot).start(port: 8181, bindAddress: "0.0.0.0")
    
} catch PerfectError.NetworkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
