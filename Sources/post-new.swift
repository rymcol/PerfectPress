//
//  post-new.swift
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
import SQLite

struct NewPostHandler: MustachePageHandler {

    func extendValuesForResponse(context contxt: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) {

        var values = MustacheEvaluationContext.MapType()

        let request = contxt.webRequest
        let params = request.params()

        if params.count > 0 {
            var parameters = [[String:Any]]()

            for (name, value) in params {
                parameters.append([
                    "paramName":name,
                    "paramValue":value
                    ])
            }

            values["params"] = parameters
            values["paramsCount"] = parameters.count
        }


//        let DB_PATH: String = Config().getDatabasePath()
//
//        do {
//            let sqlite = try SQLite(DB_PATH)
//            let options = try SQLite.execute()
//        } catch {
//            print("Database Failed")
//        }

        values["title"] = "Site Admin | Add New Post"

        contxt.extendValues(with: values)
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.setStatus(code: 500, message: "Server Error")
            response.appendBody(string: "\(error)")
            response.requestCompleted()
        }
    }
}
