//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Foundation

extension DateFormatter {
	static let year: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "y"
		return formatter
	}()

	static let shortDate: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter
	}()
}
