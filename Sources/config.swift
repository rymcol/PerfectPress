//
//  config.swift
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

public enum DatabaseType {
	case SQLite
	case MySQL
	case PostgreSQL
	case MongoDB
}

struct Config {

	//Server Details
	let ip: String = "192.168.1.153"
	let port: UInt16 = 8181

	//Select Database Type (This sets up for future options)
	var db = DatabaseType.SQLite

	//============================
	//Database Connection Details
	//============================

	//SQLite
	let dbDIR = "./db/"
	let dbName = "sitedb"

	func getDatabasePath() -> String {
		return "\(self.dbDIR)\(self.dbName)"
	}

}
