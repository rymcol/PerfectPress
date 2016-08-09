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
	let ip: String = "169.254.237.101"
	let port: UInt16 = 8181
}
