//
//  String.swift
//  KeyboardMaestroCLI
//
//  Created by Kyle on 3/20/20.
//  Copyright © 2020 Kyle Carson. All rights reserved.
//

import Foundation

extension String {
	var escapingQuotes : String {
		return self.replacingOccurrences(of: "\"", with: "\\\"")
	}
}
