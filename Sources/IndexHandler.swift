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
import SQLite

class IndexHandler: MustachePageHandler {

    var content = "No Posts Were Found"
    var postTitle = "Welcome"

    func extendValuesForResponse(context contxt: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) {

        let DB_PATH: String = Config().getDatabasePath()

        do {
            let sqlite = try SQLite(DB_PATH)
            defer {
                sqlite.close()  // defer ensures we close our db connection at the end of this request
            }

            // query the db for a random post
            try sqlite.forEachRow(statement: "SELECT post_content, post_title FROM posts ORDER BY RANDOM() LIMIT 1") {
                (statement: SQLiteStmt, i:Int) -> () in

                    self.content = statement.columnText(position: 0)
                    self.postTitle = statement.columnText(position: 1)
                }

            } catch {
              print("content retrieval failed")
        }

        var values = MustacheEvaluationContext.MapType()

        values["title"] = "Site Homepage"
        values["content"] = content
        values["postTitle"] = postTitle

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
