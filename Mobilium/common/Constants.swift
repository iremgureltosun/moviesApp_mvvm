//
//  Constants.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation
import UIKit

public struct Colors {
    public static let vBackground = UIColor.secondarySystemBackground
    public static let vTitle = UIColor.black
}

struct Constants {
    struct Network {
        static let basePosterPath = "https://image.tmdb.org/t/p/w154"
        static let baseImagePath = "https://image.tmdb.org/t/p/original"
        static let baseUrlPath = "https://api.themoviedb.org/3/movie/"
        static let upcomingPath = "upcoming"
        static let nowPlayingPath = "now_playing"
      
        static let apiKEY = "?api_key=db6d605be8f93dd091ef06da184cbdf0"
        static let endPath = "&language=en-US&page=1"
    }

    struct Translations {
        static let loading = "Loading"
        static let ok = "OK"
        static let cancel = "Cancel"

        struct Error {
            static let jsonDecodingError = "Error: JSON decoding error."
            static let noDataError = "Error: No data received."
            static let noResultsFound = "No results were found for your search."
            static let statusCode404 = "404 Not found"
        }
    }

    struct MovieAPI {
        static let shortTextLength = 50
        static let minIdentifier = 1
        static let maxIdentifier = 1000
    }
}
