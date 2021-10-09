//
//  DescriptionData.swift
//  Description
//
//  Created by MacBook on 09.10.2021.
//

import Foundation

//query.pages[26537].extract
//query.pages[19595060].extract

struct DescriptionData: Codable {
    let query: Query
}

struct Query: Codable {
    let pageids: [String]
    let pages: [String: Pages]
}

struct Pages: Codable {
    let extract: String
}
