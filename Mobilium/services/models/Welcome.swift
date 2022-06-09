//
//  Welcome.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation

// MARK: - Welcome

struct Welcome: Codable {
    let dates: Dates
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates

struct Dates: Codable {
    let maximum, minimum: String
}

enum OriginalLanguage: String, Codable {
    case en
    case es
    case fr
    case ja
    case ko
    case pl
}
