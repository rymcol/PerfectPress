//
//  IndexHandler.swift
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

class IndexHandler: MustachePageHandler {

    let DB_PATH: String = Config().getDatabasePath()

    var contentID: String?

    var content = "No Posts Were Found That Matched The Requested Post"
    var postTitle = "Welcome"

    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {

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
                            loadPageContent(forPageID: contentID)
                        }
                    } else {
                      loadPageContent(forPageID: nil, frontPage: true)
                    }
                }
            }

        } else {
          loadPageContent(forPageID: nil, frontPage: true)
        }

        var values = MustacheEvaluationContext.MapType()

        let imageNumber = Int(arc4random_uniform(25) + 1)

        values["featuredImageURI"] = "/img/random/random-\(imageNumber).jpg"

        values["title"] = "Site Homepage"
        values["content"] = content
        values["postTitle"] = postTitle

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

    func loadPageContent(forPageID: String?, frontPage: Bool = false) {
      do {
          let sqlite = try SQLite(DB_PATH)
          defer {
              sqlite.close()  // defer ensures we close our db connection at the end of this request
          }

          let sqlStatement: String
          if !frontPage && forPageID != nil {
              sqlStatement = "SELECT post_content, post_title FROM posts WHERE id= \(forPageID!)"
          } else {
              sqlStatement = "SELECT post_content, post_title FROM posts WHERE id=(SELECT value FROM options WHERE option = 'front_page')"
          }

          // query the db for a random post
          try sqlite.forEachRow(statement: sqlStatement) {
              (statement: SQLiteStmt, i:Int) -> () in

                    self.content = statement.columnText(position: 0)
                    self.postTitle = statement.columnText(position: 1)
              }

          } catch {

        }
    }

}
