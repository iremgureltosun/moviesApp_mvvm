//
//  ListMoviesViewModel.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation
import os.log
import RxCocoa
import RxSwift
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
    var searchService: SearchServiceProtocol
    private var disposeBag = DisposeBag()
    var upcomingList: PublishSubject<[UpcomingViewModel]>
    var nowPlayingList: PublishSubject<[NowPlayingViewModel]>
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        searchService = (appDelegate.assembler?.resolver.resolve(SearchServiceProtocol.self))!
        upcomingList = PublishSubject<[UpcomingViewModel]>()
        nowPlayingList = PublishSubject<[NowPlayingViewModel]>()
    }

    func fetchUpcoming() {
        do {
            try searchService.getUpcomingMovies()
                .subscribe(
                    onNext: { response in
                        let list = response.results.compactMap { UpcomingViewModel($0) }
                        self.upcomingList.onNext(list)
                    },
                    onError: { error in
                        print(error)
                    },
                    onCompleted: {
                        print("completed")

                    })
                .disposed(by: disposeBag)

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchNowPlaying() {
        do {
            try searchService.getNowPlayingMovies()
                .subscribe(
                    onNext: { response in
                        guard response.results.count>3 else{
                            return
                        }
                        let firstThree = response.results[0..<3]
                        let list = firstThree.compactMap { NowPlayingViewModel($0) }
                        self.nowPlayingList.onNext(list)
                    },
                    onError: { error in
                        print(error)
                    },
                    onCompleted: {
                        print("completed")

                    })
                .disposed(by: disposeBag)

        } catch {
            print(error.localizedDescription)
        }
    }
}
