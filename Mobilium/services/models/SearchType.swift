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



