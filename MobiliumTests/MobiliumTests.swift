//
//  MobiliumTests.swift
//  MobiliumTests
//
//  Created by irem TOSUN on 6.06.2022.
//

import Combine
import Foundation
@testable import Mobilium
import XCTest

class MobiliumAPITests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testEndpointReturnsDataForUpcoming() {
        let searchService = SearchService()
        let expectation = self.expectation(description: "No results in response data")
       
        searchService.getUpcomingMovies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error: \(error)")
                    XCTFail("Error in the server call")
                case .finished:
                    print("All good")
                }
            }, receiveValue: { data in
                let length = data.count
                let response = String(data: data, encoding: .utf8)
                print("Response:\(String(describing: response))")
                print("We have some data.: \(length)")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 6, handler: nil)
    }

    func testEndpointReturnsDataForNowPlaying() {
        let searchService = SearchService()
        let expectation = self.expectation(description: "No results in response data")
        
        searchService.getNowPlayingMovies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Error: \(error)")
                    XCTFail("Error in the server call")
                case .finished:
                    print("All good")
                }
            }, receiveValue: { data in
                let length = data.count
                let response = String(data: data, encoding: .utf8)
                print("Response:\(String(describing: response))")
                print("We have some data.: \(length)")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 6, handler: nil)
    }
}
