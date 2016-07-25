//
//  routing.swift
//  PerfectPress
//
//  Created by Ryan Collins on 6/9/16.
//  Copyright (C) 2016 Ryan M. Collins.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the PerfectPress open source blog project
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectMustache

func makeRoutes() -> Routes {

    var routes = Routes()

    routes.add(method: .get, uris: ["/", "index.html"], handler: {request, response in
        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: IndexHandler(), templatePath: webRoot + "/index.mustache")
    })

    routes.add(method: .get, uris: ["admin/post"], handler: {request, response in
        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: NewPostHandler(), templatePath: webRoot + "/post-new.mustache")
    })

    routes.add(method: .get, uris: ["blog"], handler: {request, response in
        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: BlogPageHandler(), templatePath: webRoot + "/blog.mustache")
    })

    return routes
}
