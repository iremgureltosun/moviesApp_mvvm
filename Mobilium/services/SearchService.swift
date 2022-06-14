//
//  SearchService.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchServiceProtocol: AnyObject {
    func getUpcomingMovies() throws -> Observable<Welcome>
    func getNowPlayingMovies() throws -> Observable<Welcome>
}

fileprivate extension Encodable {
    var dictionaryValue: [String: Any?]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}

class SearchService: SearchServiceProtocol {
    let session: URLSession
    private var bag = DisposeBag()

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    lazy var requestObservable = RequestObservable(config: .default)

    func getUpcomingMovies() throws -> Observable<Welcome> {
        let endPoint = SearchEndpoint(searchType: .getUpcoming)
        let request = endPoint.getUrlRequest()
        return requestObservable.callAPI(request: request)
    }

    func getNowPlayingMovies() throws -> Observable<Welcome> {
        let endPoint = SearchEndpoint(searchType: .getNowPlaying)
        let request = endPoint.getUrlRequest()
        return requestObservable.callAPI(request: request)
    }
}
