//
//  SearchEndPoint.swift
//  Mobilium
//
//  Created by irem TOSUN on 14.06.2022.
//

import Foundation
import RxCocoa
import RxSwift

struct SearchEndpoint {
    var searchType: SearchType

    public var baseURL: URL {
        return URL(string: "\(Constants.Network.baseUrlPath)")!
    }

    init(searchType: SearchType) {
        self.searchType = searchType
    }

    public var method: String {
        return "GET"
    }

    public var headers: [String: String]? {
        return nil
    }
}

extension SearchEndpoint {
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
