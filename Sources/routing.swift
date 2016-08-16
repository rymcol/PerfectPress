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

    routes.add(method: .get, uris: ["/", "index.html"], handler: indexHandler)

    routes.add(method: .get, uris: ["blog"], handler: blogHandler)

    return routes
}

func indexHandler(request: HTTPRequest, _ response: HTTPResponse) {
    let header = CommonHandler().getHeader()
    let footer = CommonHandler().getFooter()
    let body = IndexHandler().loadPageContent()
    let indexPage = header + body + footer
    
    response.appendBody(string: indexPage)
    response.completed()
}

func blogHandler(request: HTTPRequest, _ response: HTTPResponse) {
    let header = CommonHandler().getHeader()
    let footer = CommonHandler().getFooter()
    let body = BlogPageHandler().loadPageContent()
    let blogPage = header + body + footer
    
    response.appendBody(string: blogPage)
    response.completed()
}
