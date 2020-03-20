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
		
		let source = "tell application \"Keyboard Maestro Engine\" to get the value of the first variable where name is \"\(name.escapingQuotes)\""
		let result = NSAppleScript(source: source)!.executeAndReturnError(nil)
		
		if let value = result.stringValue {
			return Variable(name: name, value: value)
		}
		
		return nil
	}
	
	static func delete(withName name: String) -> Bool {
		let source = "tell application \"Keyboard Maestro Engine\" to delete variable \"\(name.escapingQuotes)\""
		NSAppleScript(source: source)!.executeAndReturnError(nil)
		
		return true
	}
	
	func save() -> Bool {
		let source = "tell application \"Keyboard Maestro Engine\" to make variable with properties {name:\"\(name.escapingQuotes)\", value:\"\(value.escapingQuotes)\"}"
		NSAppleScript(source: source)!.executeAndReturnError(nil)
		
		return true
	}
	
	static var file = String(NSString(string: "~/Library/Application Support/Keyboard Maestro/Keyboard Maestro Variables.sqlite").expandingTildeInPath)
	
	static var db : Connection {
		return try! Connection(file)
	}
	
	static var table : Table {
		return Table("variables")
	}
	
	static var all : [Variable] {
//		let source = "tell application \"Keyboard Maestro Engine\" to get every variable"
//		var result = NSAppleScript(source: source)!.executeAndReturnError(nil)
//
//		print(result.value)
		
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
}
