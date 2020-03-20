//
//  Macro.swift
//  KeyboardMaestroCLI
//
//  Created by Kyle on 3/20/20.
//  Copyright © 2020 Kyle Carson. All rights reserved.
//

import Foundation

struct Macro {
	var name : String
	var id : String
	var group : String
	var groupID : String
	
	static var file = String(NSString(string: "~/Library/Application Support/Keyboard Maestro/Keyboard Maestro Macros.plist").expandingTildeInPath)
	
	static func parsePlist() -> [String: AnyObject] {
		
		guard let dictionary = NSDictionary(contentsOfFile: file) else {
			return [:]
		}
		
		return dictionary as! [String: AnyObject]
	}
	
	static var all : [Macro] {
		
		var macros : [Macro] = []
		
		let plist = self.parsePlist()
		let groups = plist["MacroGroups"]! as! [ [String:Any] ]
		
		for group in groups {
			let groupName = group["Name"] as! String
			let groupID = group["UID"] as! String
			
			guard let groupMacros = group["Macros"] as? [ [String:Any] ] else { continue }
			
			for macro in groupMacros {
				guard let name = macro["Name"] as? String else { continue }
				let id = macro["UID"] as! String
				
				macros.append(
					Macro(name: name, id: id, group: groupName, groupID: groupID)
				)
			}
		}
		
		return macros
	}
	
	static func run(nameOrID: String, parameter : String? = nil) {
		var parameterAppendage = ""
		if let parameter = parameter {
			parameterAppendage = " with parameter \"\(parameter.escapingQuotes)\""
		}
		
		let source = "tell application \"Keyboard Maestro Engine\" to do script \"\(nameOrID.escapingQuotes)\"\(parameterAppendage)"
		
		NSAppleScript(source: source)!.executeAndReturnError(nil)
	}
	
	static func edit(nameOrID: String) {
		let source = """
			tell application \"Keyboard Maestro\"
				activate
				editMacro \"\(nameOrID.escapingQuotes)\"
			end tell
		"""
		
		NSAppleScript(source: source)!.executeAndReturnError(nil)
	}
	
	static func enable(nameOrID: String) {
		let source = "tell application \"Keyboard Maestro\" to setMacroEnable \"\(nameOrID.escapingQuotes)\" with enable"
		
		NSAppleScript(source: source)!.executeAndReturnError(nil)
	}
	
	static func disable(nameOrID: String) {
		let source = "tell application \"Keyboard Maestro\" to setMacroEnable \"\(nameOrID.escapingQuotes)\" without enable"
		
		NSAppleScript(source: source)!.executeAndReturnError(nil)
	}
	
	static func executeRaw(code: String) {
		
		let source : String
		
		if code.hasPrefix("<dict>") {
			source = "tell application \"Keyboard Maestro Engine\" to do script \"\(code.escapingQuotes)\""
		} else {
			source = "tell application \"Keyboard Maestro Engine\" to do script \"<dict><key>MacroActionType</key><string>\(code.escapingQuotes)</string></dict>\""
		}
		
		NSAppleScript(source: source)!.executeAndReturnError(nil)
	}
}
