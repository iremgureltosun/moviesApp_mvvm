//
//  ListMoviesViewModel.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Combine
import Foundation
import os.log
import Swinject

struct NowPlayingViewModel {
    let id: Int
    let imagePath: String
    let titleYear: String
    let shortenedPlot: String

    init(_ result: Result) {
        id = result.id
        imagePath = "\(Constants.Network.baseImagePath)\(result.backdropPath)"
        titleYear = "\(result.title) (\(result.year))"
        shortenedPlot = result.shortPlot
    }
}

struct UpcomingViewModel {
    let posterPath: String
    let imagePath: String
    let titleYear: String
    let shortenedPlot: String
    let plot: String
    let date: String
    let score: String

    init(_ result: Result) {
        posterPath = "\(Constants.Network.basePosterPath)\(result.posterPath)"
        imagePath = "\(Constants.Network.baseImagePath)\(result.backdropPath)"

        titleYear = "\(result.title) (\(result.year))"
        shortenedPlot = result.shortPlot
        plot = result.overview
        date = result.releaseDate.toDate()?.getFormattedDate(format: "dd.MM.yyyy") ?? ""
        score = String(result.voteAverage)
    }
}

class HomeViewModel {
    @Published var upcomingMovies: [UpcomingViewModel] = []
    @Published var nowPlayingMovies: [NowPlayingViewModel] = []

    init() {
    }
}
