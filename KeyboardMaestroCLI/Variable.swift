//
//  Variable.swift
//  KeyboardMaestroCLI
//
//  Created by Kyle on 3/20/20.
//  Copyright © 2020 Kyle Carson. All rights reserved.
//

import Foundation
import SQLite

struct Variable : Codable {
	var name : String
	var value : String
	
	static func fromDB(name : String) -> Variable? {
		for variable in self.all {
			if variable.name == name {
				return variable
			}
		}
		
		return nil
	}
	
	static func delete(withName name: String) -> Bool {
		return false
	}
	
	func save() -> Bool {
		return false
	}
	
	static var file = String(NSString(string: "~/Library/Application Support/Keyboard Maestro/Keyboard Maestro Variables.sqlite").expandingTildeInPath)
	
	static var db : Connection {
		return try! Connection(file)
	}
	
	static var table : Table {
		return Table("variables")
	}
	
	static var all : [Variable] {
		
		var variables : [Variable] = []
		for row in try! db.prepare(table) {
			let name = try! row.get(Expression<String>("name"))
			let value = try! row.get(Expression<String>("value"))
			
			variables.append(
				Variable(name: name, value: value)
			)
		}
		
		return variables
	}
		
//		guard let dictionary = NSDictionary(contentsOfFile: file) else {
//			return [:]
//		}
//
//		return dictionary as! [String: AnyObject]
//	}
}
