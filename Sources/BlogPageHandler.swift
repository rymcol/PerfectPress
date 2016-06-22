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
import Glibc
#else
import Darwin
#endif

class BlogPageHandler: MustachePageHandler {

    let DB_PATH: String = Config().getDatabasePath()

    var contentID: String?

    var deafultContent = "No Posts Were Found That Matched The Requested Post"
    var content = [[String:Any]]()
    var postTitles = [String]()
    var page = 0
    var pageCount =  1

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
                    if key == "pg" {
                        if let contentID = value as? String {
                            if let pageID = Int(contentID) {
                                self.page = pageID
                            }
                            loadPageContent(forPage: page)
                        }
                    } else {
                      loadPageContent(forPage: page)
                    }
                }
            }

        } else {
          loadPageContent(forPage: page)
        }

        var values = MustacheEvaluationContext.MapType()

        let imageNumber = Int(arc4random_uniform(25) + 1)

        while pageCount <= content.count / 5 {
            pageCount += 1
        }

        values["pageCount"] = pageCount
        values["featuredImageURI"] = "/img/random/random-\(imageNumber).jpg"
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

    func loadPageContent(forPage: Int) {
      do {
          let sqlite = try SQLite(DB_PATH)
          defer {
              sqlite.close()  // defer ensures we close our db connection at the end of this request
          }

          let sqlStatement = "SELECT post_content, post_title FROM posts ORDER BY id DESC LIMIT 5 OFFSET :1"

          try sqlite.forEachRow(statement: sqlStatement, doBindings: {
              (statement: SQLiteStmt) -> () in

              let bindPage: Int

              if self.page == 0 || self.page == 1 {
                  bindPage = 0
              } else {
                  bindPage = forPage * 5 - 5
              }

              try statement.bind(position: 1, bindPage)
          }) {
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
