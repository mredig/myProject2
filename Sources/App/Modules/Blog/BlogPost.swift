//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Foundation

struct BlogPost: Encodable {
	let title: String
	let slug: String
	let image: String
	let excerpt: String
	let date: String
	let category: String?
	let content: String
}
