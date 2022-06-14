//
//  RequestObservable.swift
//  Mobilium
//
//  Created by irem TOSUN on 14.06.2022.
//

import Foundation
import RxCocoa
import RxSwift

public class RequestObservable {
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config: URLSessionConfiguration) {
        urlSession = URLSession(configuration:
            URLSessionConfiguration.default)
    }

    public func callAPI<Welcome: Decodable>(request: URLRequest) -> Observable<Welcome> {
        return Observable.create { observer in
            let task = self.urlSession.dataTask(with: request) { data,
                response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        guard HttpStatusCode.Success.range.contains(statusCode) else {
                            if httpResponse.statusCode == HttpStatusCode.ClientError.notFoundError {
                                throw HTTPError.notFoundResponse
                            } else {
                                throw HTTPError.invalidResponse(httpResponse.statusCode)
                            }
                        }
                        let objs = try self.jsonDecoder.decode(Welcome.self, from:
                            _data)
                        observer.onNext(objs)

                    } catch {
                        observer.onError(error)
                    }
                }

                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
