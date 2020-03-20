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
		subcommands: [Run.self])
	
    func run() throws {
		throw(CleanExit.helpRequest(self))
    }
	
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
}

KeyboardMaestro.main()
