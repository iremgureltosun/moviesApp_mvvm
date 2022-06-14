//
//  HttpStatusCodes.swift
//  Mobilium
//
//  Created by irem TOSUN on 14.06.2022.
//

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
