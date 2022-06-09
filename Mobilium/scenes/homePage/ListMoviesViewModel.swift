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
    let queue = DispatchQueue.main
    var searchCancellableUpcoming: AnyCancellable?
    var searchCancellableNowPlaying: AnyCancellable?
    @Published private(set) var upcomingMovies: [UpcomingViewModel] = []
    @Published private(set) var nowPlayingMovies: [NowPlayingViewModel] = []
    var searchService: SearchServiceProtocol

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        searchService = (appDelegate.assembler?.resolver.resolve(SearchServiceProtocol.self))!
    }

    func fetchUpcoming() {
        var welcome: Welcome?
        searchCancellableUpcoming = searchService.getUpcomingMovies()
            .receive(on: queue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.upcomingMovies = []
                case .finished:
                    self.upcomingMovies = welcome?.results.compactMap { UpcomingViewModel($0) } ?? []
                }

            }, receiveValue: { data in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    welcome = try decoder.decode(Welcome.self, from: data)

                    os_log("Success: %s", log: Log.network, type: .default, "Loaded")
                } catch {
                    let errorMessage = "\(error.localizedDescription)"
                    os_log("Error: %s", log: Log.data, type: .error, errorMessage)
                }
            })
    }

    func fetchNowPlaying() {
        var welcome: Welcome?
        searchCancellableNowPlaying = searchService.getNowPlayingMovies()
            .receive(on: queue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.nowPlayingMovies = []
                case .finished:
                    self.nowPlayingMovies = welcome?.results[0 ..< 3].compactMap { NowPlayingViewModel($0) } ?? []
                }

            }, receiveValue: { data in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    welcome = try decoder.decode(Welcome.self, from: data)

                    os_log("Success: %s", log: Log.network, type: .default, "Loaded")
                } catch {
                    let errorMessage = "\(error.localizedDescription)"
                    os_log("Error: %s", log: Log.data, type: .error, errorMessage)
                }
            })
    }
}
