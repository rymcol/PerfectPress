//
//  CreateDatabase.swift
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
//imgort MySQL

struct SQLiteDefaultOptions {

    let DB_PATH: String = Config().getDatabasePath()

    func addDefaultOptions() {
        do {
            let sqlite = try SQLite(DB_PATH)
            try sqlite.execute(statement: "INSERT INTO options (option, value) VALUES ('front_page', NULL)")
        } catch {
            print("Failure loading options to database at \(DB_PATH)")
        }
    }

}

//MYSQL Defaults Here
