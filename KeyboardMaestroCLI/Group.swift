//
//  Group.swift
//  KeyboardMaestroCLI
//
//  Created by Kyle on 3/20/20.
//  Copyright © 2020 Kyle Carson. All rights reserved.
//

import Foundation

struct Group {
	var name : String
	var id : String
	
	static var all : [Group] {
		
		var allGroups : [Group] = []
		
		let plist = Macro.parsePlist()
		let groups = plist["MacroGroups"]! as! [ [String:Any] ]
		
		for group in groups {
			let name = group["Name"] as! String
			let id = group["UID"] as! String
			
			allGroups.append(
				Group(name: name, id: id)
			)
		}
		
		return allGroups
	}
}
