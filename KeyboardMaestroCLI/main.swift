//
//  main.swift
//  KeyboardMaestroCLI
//
//  Created by Kyle on 3/19/20.
//  Copyright © 2020 Kyle Carson. All rights reserved.
//

import Foundation
import ArgumentParser

struct KeyboardMaestro: ParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "km",
		abstract: "(Unofficial) Keyboard Maestro Command Line Interface",
		subcommands: [Run.self, Macros.self, Groups.self, Variables.self, SpecificVariable.self])
	
    struct Run: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Runs a Keyboard Maestro macro")

		@Argument(help: "Name or ID of the script to run")
		var nameOrID: String

		@Option(name: .shortAndLong, help: "Parameter to pass to your script")
		var parameter: String?
		
        func run() {
			var parameterAppendage = ""
			if let parameter = parameter {
				parameterAppendage = " with parameter \"\(parameter)\""
			}
			
			let source = "tell application \"Keyboard Maestro Engine\" to do script \"\(nameOrID)\"\(parameterAppendage)"
			
			NSAppleScript(source: source)!.executeAndReturnError(nil)
        }
    }
	
	struct Macros : ParsableCommand {
		@Flag(name: .short, help: "Only list IDs")
		var idsOnly : Bool
		
		@Flag(name: .short, help: "Only list Names")
		var namesOnly : Bool
		
		@Option(help: "Limit results to a group")
		var group: String?
		
        static let configuration = CommandConfiguration( abstract: "List your macros" )
		
        func run() {
			for macro in Macro.all {
				if let group = group {
					if macro.group != group && macro.groupID != group { continue }
				}
				
				if namesOnly {
					print(macro.name)
				} else if idsOnly {
					print(macro.id)
				} else {
					print("\(macro.id) \(macro.name)")
				}
			}
        }
	}
	
	struct Groups : ParsableCommand {
		@Flag(name: .short, help: "Only list IDs")
		var idsOnly : Bool
		
		@Flag(name: .short, help: "Only list Names")
		var namesOnly : Bool
		
        static let configuration = CommandConfiguration( abstract: "List your macro groups" )
		
        func run() {
			for group in Group.all {
				if namesOnly {
					print(group.name)
				} else if idsOnly {
					print(group.id)
				} else {
					print("\(group.id) \(group.name)")
				}
			}
        }
	}
	
	struct Variables : ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "List your variables")
		
		func run() {
			for variable in Variable.all {
				print("\(variable.name)")
			}
		}
	}
	
	struct SpecificVariable : ParsableCommand {
		static let configuration = CommandConfiguration(
			commandName: "variable",
			abstract: "Query variables"
		)
		
		@Argument(help: "Variable Name")
		var name: String
		
//		@Argument(help: "Sets the value of the variable")
		var value: String?
		
//		@Flag(name: .shortAndLong, help: "Delete the variable")
		var delete : Bool = false
		
		var variable : Variable? = nil
		
		mutating func validate() throws {
			self.variable = Variable.fromDB(name: name)
			guard value != nil || self.variable != nil else {
			   throw ValidationError("Variable could not be found")
			}
			
			guard !self.delete || self.value == nil else {
				throw ValidationError("You can either delete -or- set the variable")
			}
		}
		
		func run() throws {
			if let value = self.value {
				let variable = Variable(name: name, value: value)
				if !variable.save() {
					print("Failed to save variable")
					throw ExitCode.failure
				}
			} else if self.delete {
				if !Variable.delete(withName: name) {
					print("Failed to delete variable")
					throw ExitCode.failure
				}
			} else {
				print(variable!.value)
			}
		}
	}
}

KeyboardMaestro.main()
