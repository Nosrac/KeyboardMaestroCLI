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
}
