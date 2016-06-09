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

struct Config {

	//Database Setup
	let DB_PATH = "./db/sitedb"

	//Database Creation
	func createDatabase() {
		do {
			let sqlite = try SQLite(DB_PATH)
			try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY NOT NULL, fname TEXT NOT NULL, lname TEXT NOT NULL, email TEXT NOT NULL, pwd TEXT NOT NULL)")
			try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS posts (id INTEGER PRIMARY KEY NOT NULL, post_content TEXT NOT NULL, post_title TEXT NOT NULL)")
		} catch {
			print("Failure creating database at \(DB_PATH)")
		}
	}

}