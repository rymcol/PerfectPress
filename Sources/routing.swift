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

func addRoutes() {

    Routing.Routes["/"] = {
        request, response in

        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: IndexHandler(), templatePath: webRoot + "/index.mustache")
    }

    Routing.Routes["admin/post"] = {
        request, response in

        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: NewPostHandler(), templatePath: webRoot + "/post-new.mustache")
    }

    Routing.Routes["blog"] = {
        request, response in

        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: BlogPageHandler(), templatePath: webRoot + "/blog.mustache")
    }
}

public func PerfectServerModuleInit() {
    addRoutes()
}
