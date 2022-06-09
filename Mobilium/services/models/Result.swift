//
//  Result.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation

// MARK: - Result

struct Result: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Result {
    var shortPlot: String {
        guard overview.count > 0 else { return overview }
        guard overview.count > Constants.MovieAPI.shortTextLength else { return overview }

        let index = overview.index(overview.startIndex, offsetBy: Constants.MovieAPI.shortTextLength)
        let plotShortened = overview[..<index]
        return String(plotShortened) + "..."
    }

    var year: String {
        guard let date = releaseDate.toDate() else {
            return ""
        }
        let calendar = Calendar.current

        return String(calendar.component(.year, from: date))
    }
}
