//
//  BlogPageHandler.swift
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
import PerfectHTTPServer
import PerfectMustache
import SQLite

#if os(Linux)
import Glibc
#else
import Darwin
#endif

class BlogPageHandler: MustachePageHandler {

    var deafultContent = "No Posts Were Found That Matched The Requested Post"
    var content = [[String:Any]]()

    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {

        let request = contxt.webRequest
        let params = request.params()

        if params.count > 0 {
            loadPageContent()
        } else {
            loadPageContent()
        }

        var values = MustacheEvaluationContext.MapType()

        values["title"] = "PerfectPress | Blog"
        values["content"] = content

        contxt.extendValues(with: values)
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }

    func loadPageContent() {

        let randomContent = ContentGenerator().generate()

        for _ in 1...5 {
            let index: Int = Int(arc4random_uniform(UInt32(randomContent.count)))
            let value = Array(randomContent.values)[index]
            let imageNumber = Int(arc4random_uniform(25) + 1)
            self.content.append(["postTitle": "Test Post \(index)", "postContent": value, "featuredImageURI": "/img/random/random-\(imageNumber).jpg", "featuredImageAltText": "Demo Image \(imageNumber)"])
        }
    }

}
