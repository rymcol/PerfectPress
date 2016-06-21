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
import SQLite

#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif

class BlogPageHandler: MustachePageHandler {

    let DB_PATH: String = Config().getDatabasePath()

    var contentID: String?

    var deafultContent = "No Posts Were Found That Matched The Requested Post"
    var content = [[String:Any]]()
    var postTitles = [String]()

    func extendValuesForResponse(context contxt: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) {

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
                    if key == "p" {
                        if let contentID = value as? String {
                            loadPageContent()
                        }
                    } else {
                      loadPageContent()
                    }
                }
            }

        } else {
          loadPageContent()
        }

        var values = MustacheEvaluationContext.MapType()

        let imageNumber = Int(arc4random_uniform(25) + 1)
        values["featuredImageURI"] = "/img/random/random-\(imageNumber).jpg"
        values["contentCount"] = content.count
        values["title"] = "Blog"
        values["content"] = content
        values["postTitle"] = postTitles

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

    func loadPageContent() {
      do {
          let sqlite = try SQLite(DB_PATH)
          defer {
              sqlite.close()  // defer ensures we close our db connection at the end of this request
          }

          let sqlStatement = "SELECT post_content, post_title FROM posts ORDER BY id DESC LIMIT 5"

          try sqlite.forEachRow(statement: sqlStatement) {
              (statement: SQLiteStmt, i:Int) -> () in

                    self.content.append([
                            "postContent": statement.columnText(position: 0),
                            "postTitle": statement.columnText(position: 1)
                        ])
              }

          } catch {
              
        }
    }

}
