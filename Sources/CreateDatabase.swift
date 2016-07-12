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

struct DatabaseCreator {

	func createDatabaseAndTables() {
		//Create Database and/or Tables if none exist
		if Config().db == DatabaseType.SQLite {
			if !File(Config().getDatabasePath()).exists {
				SQLiteDatabase().createSQLiteDatabase()
			}
		}
	}
}

struct SQLiteDatabase {

	//SQLite Database Directory Definitions
	let DB_DIR = Config().dbDIR
	let DB_PATH: String = Config().getDatabasePath()

	//SQLite Database Creation
	func createSQLiteDatabase() {

		if !Dir(DB_DIR).exists {

			do {
				try Dir(DB_DIR).create()
			} catch {
				print("Dir creation failed!")
			}
		}

		do {
			let sqlite = try SQLite(DB_PATH)
			try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY NOT NULL, fname TEXT NOT NULL, lname TEXT NOT NULL, email TEXT NOT NULL, pwd TEXT NOT NULL)")
			try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS posts (id INTEGER PRIMARY KEY NOT NULL, post_title TEXT NOT NULL, post_content TEXT NOT NULL, featured_image_uri TEXT NOT NULL)")
			try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS options (id INTEGER PRIMARY KEY NOT NULL, option TEXT NOT NULL, value TEXT)")
			SQLiteDefaultOptions().addDefaultOptions()
		} catch {
			print("Failure creating database at \(DB_PATH)")
		}
	}

}
