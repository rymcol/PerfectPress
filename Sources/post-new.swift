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
import PerfectHTTPServer
import PerfectMustache
import SQLite

struct NewPostHandler: MustachePageHandler {

    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {

        var values = MustacheEvaluationContext.MapType()

        var postTitle = "Default"
        var postContent = ""
        var makeFrontPage = false
        var lastPost: String?

        let request = contxt.webRequest
        let params = request.params()

        if params.count > 0 {

          let DB_PATH: String = Config().getDatabasePath()

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
                    if let postedContent = value as? String {
                        let contentArray = postedContent.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
                        for paragraph in contentArray {
                            postContent.append("<p>\(paragraph)</p>")
                        }
                    }
                }
                if key == "makeFrontPage" {
                  if let valueCheck = value as? String {
                    if valueCheck == "FrontPage" {
                        makeFrontPage = true
                    }
                  }
                }
              }
            }

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

               if makeFrontPage {
                 try sqlite.forEachRow(statement: "SELECT id FROM posts ORDER BY id DESC LIMIT 1") {
                     (statement: SQLiteStmt, i:Int) -> () in

                         lastPost = statement.columnText(position: 0)
                     }

                     if let lastPostID: String = lastPost {
                       try sqlite.execute(statement: "UPDATE options SET value = :1 WHERE option = 'front_page'") {
                         (stmt:SQLiteStmt) -> () in

                         try stmt.bind(position: 1, lastPostID)
                       }
                     }
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
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}
