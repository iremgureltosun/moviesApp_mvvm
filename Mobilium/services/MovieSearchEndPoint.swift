//
//  MovieSearchEndPoint.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation


public enum SearchType {
    case getUpcoming
    case getNowPlaying
    
    public var path: String {
        switch self {
        case .getUpcoming:
            return "\(Constants.Network.upcomingPath)\(Constants.Network.apiKEY)\(Constants.Network.endPath)"
        case .getNowPlaying:
            return "\(Constants.Network.nowPlayingPath)\(Constants.Network.apiKEY)\(Constants.Network.endPath)"
        }
    }
}

struct MovieSearchEndpoint {
    var searchType: SearchType
    
    public var baseURL: URL {
        return URL(string: "\(Constants.Network.baseUrlPath)")!
    }
    init(searchType: SearchType){
        self.searchType = searchType
    }
   

    public var method: String {
        return "GET"
    }

    public var headers: [String: String]? {
        return nil
    }
}

extension MovieSearchEndpoint {
    private func searchByURL() -> URL {
        let urlString = baseURL.absoluteString + searchType.path
        guard let url = URL(string: urlString) else {
            fatalError("Failed to create URL for endpoint: \(urlString)")
        }
        return url
    }
    public func getUrlRequest() -> URLRequest {
        let url = searchByURL()
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        return request
    }
    
}

