//
//  SearchService.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Combine
import Foundation

struct HttpStatusCode {
    struct Informational {
        static let range = 100 ..< 200
    }

    struct Success {
        static let range = 200 ..< 300
    }

    struct Redirection {
        static let range = 300 ..< 400
    }

    struct ClientError {
        static let range = 400 ..< 500
        static let badRequest = 400
        static let notFoundError = 401
    }

    struct ServerError {
        static let range = 500 ..< 600
    }
}

protocol SearchServiceProtocol: AnyObject {
    func getUpcomingMovies() -> AnyPublisher<Data, Error>
    func getNowPlayingMovies() -> AnyPublisher<Data, Error>
}

class SearchService: SearchServiceProtocol {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func getUpcomingMovies() -> AnyPublisher<Data, Error> {
        let endpoint = MovieSearchEndpoint(searchType: .getUpcoming)
        return performRequest(urlRequest: endpoint.getUrlRequest())
    }

    func getNowPlayingMovies() -> AnyPublisher<Data, Error> {
        let endpoint = MovieSearchEndpoint(searchType: .getNowPlaying)
        return performRequest(urlRequest: endpoint.getUrlRequest())
    }

    func performRequest(urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPError
                        .invalidResponse(HttpStatusCode.ClientError.badRequest)
                }
                guard HttpStatusCode.Success.range.contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == HttpStatusCode.ClientError.notFoundError {
                        throw HTTPError.notFoundResponse
                    } else {
                        throw HTTPError.invalidResponse(httpResponse.statusCode)
                    }
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}

public enum HTTPError: Equatable {
    case statusCode(Int)
    case invalidResponse(Int)
    case notFoundResponse
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response"
        case .notFoundResponse:
            return "Not found"
        case let .statusCode(int):
            return String(int)
        }
    }
}
