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

        var postTitle = "Default"
        var postContent = "Default Content"
        var makeFrontPage = false

        let request = contxt.webRequest
        let params = request.params()

        if params.count > 0 {
            var parameters = [[String:Any]]()

            for (name, value) in params {
                parameters.append([
                    name: value
                    ])
            }

            for dict in parameters {
              for (key, value) in dict {
                if key == "postTitle" {
                  postTitle = value as! String
                }
                if key == "postContent" {
                  postContent = value as! String
                }
              }
            }

            let DB_PATH: String = Config().getDatabasePath()

            do {
               let sqlite = try SQLite(DB_PATH)
               defer {
                 sqlite.close()
               }

               try sqlite.execute(statement: "INSERT INTO posts (post_title, post_content) VALUES (:1,:2)") {
                 (stmt:SQLiteStmt) -> () in

                 try stmt.bind(position: 1, postTitle)
                 try stmt.bind(position: 2, postContent)
               }

             } catch {

             }
        }

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
